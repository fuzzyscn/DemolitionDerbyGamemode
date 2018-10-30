SaveLeaderboard = function(MapName)
	local LeaderboardJSON = json.encode(Leaderboard):sub(1, json.encode(Leaderboard):len() - 1):gsub('{', '{\n    ', 1):gsub('},', '},\n    ') .. '\n}'
	SaveResourceFile(GetCurrentResourceName(), 'Leaderboards' .. GetOSSep() .. MapName .. '.json', LeaderboardJSON, -1)
	Leaderboard = {}
end

LoadLeaderboard = function(MapName, MapFileContentToLUA, VehicleClass)
	Leaderboard = {}

	local CurrentMapLeaderboard = LoadResourceFile(GetCurrentResourceName(), 'Leaderboards' .. GetOSSep() .. MapName .. '.json')

	if CurrentMapLeaderboard ~= nil and CurrentMapLeaderboard ~= '' then
		Leaderboard = json.decode(CurrentMapLeaderboard)
	end

	TriggerClientEvent('DD:C:UpdateLeaderboard', -1, Leaderboard)
	TriggerClientEvent('DD:C:SpawnMap', -1, MapName, MapFileContentToLUA, VehicleClass)
end

