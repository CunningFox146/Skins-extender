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

if not env.MODROOT:find("workshop-") then
	CHEATS_ENABLED = true
	mods.open_skins.debug_skins_queue = {}

	local TEST_ITEM_NAME = "birdcage_pirate"
	local SkinGifts = require("skin_gifts")

	TheInput:AddKeyUpHandler(KEY_F2, function()
		table.insert(mods.open_skins.debug_skins_queue, { item = TEST_ITEM_NAME, item_id = 0, item_type = TEST_ITEM_NAME })
	end)
end

AddClassPostConstruct("widgets/controls", function(self)
	local GiftItemToast = require("widgets/giftitemtoast_fox")

	if self.item_notification then
		self.item_notification:Hide()
	end

	self.fox_item_notification = self.topleft_root:AddChild(GiftItemToast())
    self.fox_item_notification:SetPosition(300, -115)
end)

