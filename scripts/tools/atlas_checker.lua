--(c) by Cunning fox (https://steamcommunity.com/id/FoxyTheCunningFox/)
local cache = setmetatable({}, {__mode="k"})

return function(img_name, atlas)
	if not cache[img_name] then
		cache[img_name] = {}
		
		local f = io.open(atlas or "images/inventoryimages.xml","r")
		
		if not f then
			print(string.format("Atlas Checker: ERROR! Can't read file %s!", (atlas or "images/inventoryimages.xml")))
			return false
		end
		
		local content = f:read("*all")
		f:close()
		
		local i = 0
		repeat
			i = content:find('name="',i+6,true)
			if i ~= nil then
				local j = content:find('"',i+6,true)
				if j ~= nil then
					table.insert(cache[img_name], content:sub(i+6,j-1))
				end
			end
		until i == nil
	end
	
	for i, name in ipairs(cache[img_name]) do
		if name == img_name..".tex" then
			return true
		end
	end
	
	return false
end

