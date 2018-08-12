SaveLeaderboard = function(MapName)
	local LeaderboardJSON = json.encode(Leaderboard):sub(1, json.encode(Leaderboard):len() - 1):gsub('{', '{\n    ', 1):gsub('},', '},\n    ') .. '\n}'
	SaveResourceFile(GetCurrentResourceName(), 'Leaderboards' .. GetOSSep() .. MapName .. '.json', LeaderboardJSON, -1)
	Leaderboard = {}
end

LoadLeaderboard = function(MapName, MapFileContentToLUA, Source)
	Leaderboard = {}
	
	local CurrentMapLeaderboard = LoadResourceFile(GetCurrentResourceName(), 'Leaderboards' .. GetOSSep() .. MapName .. '.json')
	
	if CurrentMapLeaderboard ~= nil and CurrentMapLeaderboard ~= '' then
		Leaderboard = json.decode(CurrentMapLeaderboard)
	end
	
	TriggerClientEvent('DD:Client:SpawnMap', -1, MapName, MapFileContentToLUA, Source)
	TriggerClientEvent('DD:Client:UpdateLeaderboard', -1, Leaderboard)
end

