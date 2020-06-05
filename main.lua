local env = env
local AddClassPostConstruct = AddClassPostConstruct
local MODROOT = MODROOT
local modinfo = modinfo
local modoptions = {
	format = GetModConfigData("skinext_date_format")
}

GLOBAL.setfenv(1, GLOBAL)

local mods = rawget(_G, "mods")
if not mods then
	mods = {}
	rawset(_G, "mods", mods)
end

if mods.open_skins then
	return
end

mods.open_skins = {
	root = MODROOT,
	name = modinfo.name,
	version = modinfo.version,
	strings = (
		mods.RussianLanguagePack and {
			WARNING = "Внимание!",
			UPDATE_BODY = "Нужно обновить "..modinfo.name.."! Версия:",
			UPDATE = "Обновить!",
			history = "История скинов",
			clear = "Очистить",
			clear_title = "Очистить запись скинов?",
			clear_body = "Вы действительно хотите очистить данные о полученых скинах?",
			write_fail_title = "Не удалось записать файл",
			write_fail_body = "Не удалось записать файл с данными о скинах. Проверьте целостность файлов игры и настройки сохранений.",
			no_items = "Не найдено ни одной записи о полученых скинах.",
		} or
		{
			WARNING = "Warning!",
			UPDATE_BODY = "You need to update "..modinfo.name.."! Latest version:",
			UPDATE = "Update!",
			history = "Skins history",
			clear = "Clear",
			clear_title = "Clear skins data?",
			clear_body = "Are you sure want to clear you skins data?",
			write_fail_title = "Failed to write a save file",
			write_fail_body = "We can't write a skins data file for some reason. Check your game file and your storage settings.",
			no_items = "You don't have any skins data yet.",
		}
	),
}

if not MODROOT:find("workshop-") then
	CHEATS_ENABLED = true

	TheInput:AddKeyUpHandler(KEY_F2, function()
		package.loaded["screens/skinshistory"] = nil
		local SkinsHistory = require "screens/skinshistory"
		TheFrontEnd:PushScreen(SkinsHistory(modoptions))
	end)
end

require "skin_saver"
-- env.SkinSaver = SkinSaver

--[[
local UpdateChecker = require "widgets/skinmod_updater"
AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self, ...)
	self.skin_updt = self.fixed_root:AddChild(UpdateChecker())
	self.skin_updt:SetPosition(-400, 160)
end)]]

env.AddGamePostInit(function()
	local updateskins = scheduler:ExecutePeriodic(FRAMES, function()
		local inst = TheGlobalInstance
		if not inst then
			return
		end

		local unopened = #TheInventory:GetUnopenedItems()
		if unopened > 0 then
			inst:PushEvent("gift_recieved")
		end
	end)

	scheduler:ExecuteInTime(FRAMES, function() SkinSaver:LoadData() end)
end)

AddClassPostConstruct("widgets/controls", function(self)
	if self.item_notification then
		self.item_notification:Hide()
	end
end)

local TEMPLATES = require "widgets/redux/templates"
local SkinsHistory = require "screens/skinshistory"
AddClassPostConstruct("screens/redux/playersummaryscreen", function(self)
	local onclick = function()
		TheFrontEnd:PushScreen(SkinsHistory(modoptions))
	end

	self.skin_history = self.bottom_root:AddChild(TEMPLATES.StandardButton(onclick, mods.open_skins.strings.history, {225, 40}))
	self.skin_history:SetPosition(0, 65)
end)

env.AddGlobalClassPostConstruct("frontend", "FrontEnd", function(self)
	local Widget = require "widgets/widget"
	local GiftItemToast = require "widgets/giftitemtoast_fox"

	if not self.fixoverlay then
		self.fixoverlay = self.overlayroot:AddChild(Widget(""))
		self.fixoverlay:SetVAnchor(ANCHOR_MIDDLE)
		self.fixoverlay:SetHAnchor(ANCHOR_MIDDLE)
		self.fixoverlay:SetScaleMode(SCALEMODE_PROPORTIONAL)
	end

	self.skinopen = self.fixoverlay:AddChild(GiftItemToast())
	self.skinopen:SetPosition(-450, 250)
end)

AddClassPostConstruct("screens/thankyoupopup", function(self)
	local _OpenGift = self.OpenGift
	function self:OpenGift(...)
		local skin = self.items[self.current_item]
		if skin and skin.item_id ~= 0 then
			printwrap("skin", skin)
			SkinSaver:AddSkin(skin.item, skin.item_id)
		end
		return _OpenGift(self, ...)
	end
end)
