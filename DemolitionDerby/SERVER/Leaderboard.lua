SaveLeaderboard = function(MapName)
	if LogMode then
		print('Function \'SaveLeaderboard\' called')
	end
	
	local LeaderboardJSON = json.encode(Leaderboard):sub(1, json.encode(Leaderboard):len() - 1):gsub('{', '{\n    ', 1):gsub('},', '},\n    ') .. '\n}'
	
	local MapLeaderboardFile = io.open(LeaderboardsPath .. MapName .. '.json', 'w+')
	MapLeaderboardFile:write(LeaderboardJSON)
	MapLeaderboardFile:flush()
	MapLeaderboardFile:close()
end

LoadLeaderboard = function(MapName, MapFileContentToLua, VehicleClass)
	if LogMode then
		print('Function \'LoadLeaderboard\' called')
	end
	
	Leaderboard = {}
	
	local MapLeaderboardFile = io.open(LeaderboardsPath .. MapName .. '.json', 'r')
	
	if MapLeaderboardFile then
		local MapLeaderboardFileContent = MapLeaderboardFile:read('*a')
		MapLeaderboardFile:close()

		
		if MapLeaderboardFileContent ~= nil and MapLeaderboardFileContent ~= '' then
			Leaderboard = json.decode(MapLeaderboardFileContent)
		end

		if type(Leaderboard) ~= 'table' then
			Leaderboard = {}
		end
	end
	
	for PlayerIndex = 0, GetNumPlayerIndices() - 1 do
		local PlayerID = GetPlayerFromIndex(PlayerIndex)
		local License = GetIdentifier(PlayerID, 'license')
		if License and not IsTableContainingKey(Leaderboard, License) then
			Leaderboard[License] = {['Name'] = GetPlayerName(PlayerID), ['Won'] = 0, ['Lost'] = 0}
		end
	end
	SetMapName(GetActualMapName(MapName))
	SetConvarServerInfo('Map Creator', GetMapCreator(MapName))

	TriggerClientEvent('DD:C:UpdateLeaderboard', -1, Leaderboard)
	TriggerClientEvent('DD:C:SpawnMap', -1, MapName, MapFileContentToLua, VehicleClass)
end

