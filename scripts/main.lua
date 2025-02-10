local env = env
local AddClassPostConstruct = AddClassPostConstruct
local modinfo = modinfo

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
	name = modinfo.name,
	version = modinfo.version,
}

if not MODROOT:find("workshop-") then
	CHEATS_ENABLED = true
end

AddClassPostConstruct("widgets/controls", function(self)
	local GiftItemToast = require "widgets/giftitemtoast_fox"

	if self.item_notification then
		self.item_notification:Hide()
	end

	self.fox_item_notification = self.topleft_root:AddChild(GiftItemToast())
    self.fox_item_notification:SetPosition(115, 150)
end)