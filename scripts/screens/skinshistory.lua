local Screen = require "widgets/screen"
local TEMPLATES = require "widgets/redux/templates"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local ItemImage = require "widgets/redux/itemimage"
local PopupDialogScreen = require "screens/redux/popupdialog"

local str = mods.open_skins.strings

local SkinsHistory = Class(Screen, function(self,options)
	Screen._ctor(self, "SkinsHistory")
	self.format = options.format or "%c"
	self.bg = self:AddChild(TEMPLATES.BackgroundTint())
    self.root = self:AddChild(TEMPLATES.ScreenRoot())

	self.back_button = self.root:AddChild(TEMPLATES.BackButton(
		function()
			self:Close()
		end
	))

	self.title = self.root:AddChild(
		Text(
			HEADERFONT,
			28,
			str.history,
			UICOLOURS.GOLD_SELECTED
		)
	)
	self.title:SetPosition(0, 235)

	self.dialog = self.root:AddChild(TEMPLATES.RectangleWindow(736, 425))
	local r, g, b = unpack(UICOLOURS.BROWN_DARK)
	self.dialog:SetBackgroundTint(r, g, b, 0.8)
	self.dialog:SetPosition(0, -5)
	self.dialog.top:Hide()


	self.clear = self.root:AddChild(TEMPLATES.StandardButton(function()
		TheFrontEnd:PushScreen(PopupDialogScreen(str.clear_title, str.clear_body,
			{
				{text=STRINGS.UI.SAVELOAD.YES, cb = function()
					SkinSaver:ClearData()
					TheFrontEnd:PopScreen()
					self:BuildSkinsMenu()
				end},
				{text=STRINGS.UI.SAVELOAD.NO, cb = function() TheFrontEnd:PopScreen() end},
			}
		))
	end, str.clear, {225, 40}))
	self.clear:SetPosition(0, -195)

	self.no_skins = self.root:AddChild(Text(HEADERFONT, 35, str.no_items))

	self:BuildSkinsMenu()
end)

function SkinsHistory:BuildSkinsMenu()
	local function scrollWidgetCtorFn(context, index)
		local w = Widget("")

		w.bg = w:AddChild(
			TEMPLATES.ListItemBackground(
				235,
				120,
				function() end
			)
		)
		w.bg:Disable()
		w.bg:SetPosition(6, 0)
		w.bg.move_on_click = true

		w.item = w.bg:AddChild(
			ItemImage(
				Profile,
				self
			)
		)
		w.item:SetPosition(-55, 0)
		w.item:ScaleToSize(90)
		w.item:Disable()
		w.item.warn_marker:Hide()

		w.name = w.bg:AddChild(
			Text(
				HEADERFONT,
				20,
				nil,
				UICOLOURS.GOLD_SELECTED
			)
		)

		w.date = w.bg:AddChild(Text(NEWFONT_OUTLINE, 28))
		w.date:SetPosition(45, -24)

		return w
	end

	local function scrollWidgetApplyFn(context, widget, data, index)
		if not data then
			widget.bg:Hide()
			return
		end
		print(GetTypeForItem(data.name))
		widget:Show()
		widget.item:SetItem(
			GetTypeForItem(data.name),
			data.name
		)

		widget.name:SetMultilineTruncatedString(
			GetSkinName(data.name),
			2,
			110
		)
		widget.name:SetPosition(48, 18)
		if (data.time_int ~= nil) then
			data.time = os.date(self.format,data.time_int)
		end
		widget.date:SetString(string.gsub(data.time, " ", "\n"))

		widget.bg:Show()
	end

	if self.grid then
		self.grid:Kill()
	end

	self.grid = self.root:AddChild(TEMPLATES.ScrollingGrid(
		{},
		{
			context = SkinSaver:GetSkins(),
			item_ctor_fn = scrollWidgetCtorFn,
			apply_fn = scrollWidgetApplyFn,
			widget_width = 245,
			widget_height = 130,
			num_visible_rows = 3,
			num_columns = 3,
			scrollbar_offset = 0,
			scrollbar_height_offset = -70,
			scroll_per_click = 0.5,
			scissor_pad = 16,
			peek_percent = 0,
			allow_bottom_empty_row = true,
		}
	))
	self.grid:SetPosition(-10, 12)

	local skins = SkinSaver:GetSkins()
	if #skins > 0 then
		self.no_skins:Hide()
		self.grid:SetItemsData(SkinSaver:GetSkins())
	else
		self.no_skins:Show()
	end
end

function SkinsHistory:OnControl(control, down)
	if self._base.OnControl(self, control, down) then
		return true
	end
	if not down and control == CONTROL_CANCEL then
		self:Close()
		return true
	end
end

function SkinsHistory:Close()
	TheFrontEnd:PopScreen(self)
end

return SkinsHistory
