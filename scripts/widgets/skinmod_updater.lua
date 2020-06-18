--Addapted from RLP
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"
local ModsScreen = require "screens/redux/modsscreen"

package.loaded["version_syncer"] = nil
local VersionSyncer = require "version_syncer"

local mod = mods.open_skins
local s = mod.strings

local COLOUR_RED = {255/255,25/255,0,1}

local UpdateChecker = Class(Widget, function(self)
    Widget._ctor(self, "UPDATE_CHECKER")
	--sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text
	self.bg = self:AddChild(TEMPLATES.CurlyWindow(150, 175, s.WARNING,
	{
		{ text = s.UPDATE, cb = function() 
			TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return ModsScreen() end)
		end},
	},
	nil, s.UPDATE_BODY))
	
	if self.bg.actions then
		self.bg.actions:SetPosition(0, 30)
	end
	
	if self.bg.body then
		self.bg.body:SetPosition(0, 50)
		self.bg.body:SetScale(.9)
	end
	
	self.last_ver_text = self.bg:AddChild(Text(HEADERFONT, 48))
	self.last_ver_text:SetRegionSize(185, 200)
	self.last_ver_text:SetColour(COLOUR_RED)
	self.last_ver_text:SetPosition(0, -30)
	
	self:Hide()
	
	VersionSyncer:GetLatestVersion()
	self.inst:DoTaskInTime(1 + math.random(), function() self:SyncVersion() end)
end)

function UpdateChecker:SyncVersion()
	if (VersionSyncer.LatestVersion and VersionSyncer.LatestVersion ~= "ERROR") and not VersionSyncer:IsSynced(mod.version) then
		self.last_ver_text:SetString(VersionSyncer.LatestVersion)
		self:Show()
		self.bg:MoveTo(Vector3(0, 550, 0), Vector3(0, 0, 0), .5)
	end
end


return UpdateChecker