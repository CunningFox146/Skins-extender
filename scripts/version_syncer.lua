local VersionSyncer = {
	LatestVersion = nil,
}

local URL = "https://cunningfox146.github.io/skin_opener.htm"

function VersionSyncer:GetLatestVersion()
	TheSim:QueryServer(
		URL,
		function(result, isSuccessful, resultCode)
			if isSuccessful and string.len(result) > 1 and resultCode == 200 then
				VersionSyncer.LatestVersion = result
				print("[VersionSyncer] Got latest version: "..result)
			else
				print("[VersionSyncer] ERROR: Failed to get latest version.")
			end
		end,
		"GET"
	)
end

function VersionSyncer:IsSynced(ver)
	return ver == VersionSyncer.LatestVersion
end

return VersionSyncer