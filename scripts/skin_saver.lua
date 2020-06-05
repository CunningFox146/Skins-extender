local PopupDialogScreen = require "screens/redux/popupdialog"
local str = mods.open_skins.strings

SkinSaver = {
	ver = 1.0,
	file = "skins_data.json",
	loaded_data = {},
}

function SkinSaver:LoadData()
	local f = io.open(self.file, "r")
    if f ~= nil then
        local content = f:read("*all")
        f:close()
        self.loaded_data = json.decode(content)
	else
		print("[Skins]: Failed to read data base. Creating new one...")
		self:Save()
    end
end

function SkinSaver:AddSkin(name, id)
	table.insert(self.loaded_data, {name = name, id = id, time_int = os.time()})
	self:Save()
end

function SkinSaver:Save()
	local f = io.open(self.file, "w")
	if f ~= nil then
		f:write(json.encode(self.loaded_data))
		f:close()
	else
		print("[Skins]: Failed to write "..self.file)
		TheFrontEnd:PushScreen(PopupDialogScreen(str.write_fail_title, str.write_fail_body,
			{
				{text=STRINGS.UI.SERVERLISTINGSCREEN.OK, cb = function() TheFrontEnd:PopScreen() end},
			}
		))
	end
end

function SkinSaver:ClearData()
	self.loaded_data = {}
	self:Save()
end

function SkinSaver:GetSkins()
	return self.loaded_data
end
