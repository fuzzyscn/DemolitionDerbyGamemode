RegisterServerEvent('DD:Server:ToRCON')
AddEventHandler('DD:Server:ToRCON', function(String)
	print(String)
end)

RegisterServerEvent('DD:Server:MapInformations')
AddEventHandler('DD:Server:MapInformations', function(RandomVehicleClass)
	TriggerClientEvent('DD:Client:MapInformations', -1, RandomVehicleClass)
end)

RegisterServerEvent('DD:Server:SyncTimeAndWeather')
AddEventHandler('DD:Server:SyncTimeAndWeather', function(Time, Weather)
	TriggerClientEvent('DD:Client:SyncTimeAndWeather', -1, Time, Weather)
end)

RegisterServerEvent('DD:Server:FreezeTime')
AddEventHandler('DD:Server:FreezeTime', function(FreezeT, Time)
	TriggerClientEvent('DD:Client:FreezeTime', -1, FreezeT, Time)
end)

RegisterServerEvent('DD:Server:FreezeWeather')
AddEventHandler('DD:Server:FreezeWeather', function(FreezeW, Weather)
	TriggerClientEvent('DD:Client:FreezeWeather', -1, FreezeW, Weather)
end)

RegisterServerEvent('DD:Server:Ready')
AddEventHandler('DD:Server:Ready', function(Player)
	TriggerClientEvent('DD:Client:Ready', -1, Player)
end)

RegisterServerEvent('DD:Server:GetRandomMap')
AddEventHandler('DD:Server:GetRandomMap', function()
	local Source = source
	Citizen.CreateThread(function()
		math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
		local RandomMapName = Maps[math.random(MapCount)][1]
		local MapFile = io.open('DemolitionDerbyMaps' .. GetOSSep() .. RandomMapName, 'r')
		local MapFileContent = MapFile:read('*a')
		local MapFileContentToLUA = MapToLUA(MapFileContent)
		MapFile:close()
		LoadLeaderboard(RandomMapName, MapFileContentToLUA, Source)
	end)
end)

RegisterServerEvent('DD:Server:Countdown')
AddEventHandler('DD:Server:Countdown', function(State)
	TriggerClientEvent('DD:Client:Countdown', -1, State)
end)

RegisterServerEvent('DD:Server:GameFinished')
AddEventHandler('DD:Server:GameFinished', function(MapName, IsTestMode)
	if not IsTestMode then
		SaveLeaderboard(MapName)
	end
	TriggerClientEvent('DD:Client:GameFinished', -1)
end)

RegisterServerEvent('DD:Server:IsGameRunning')
AddEventHandler('DD:Server:IsGameRunning', function()
	if GetNumPlayerIndices() > 1 then
		TriggerClientEvent('DD:Client:IsGameRunning', -1, source)
	else
		TriggerClientEvent('DD:Client:IsGameRunningAnswer', source, false)
	end
end)

RegisterServerEvent('DD:Server:IsGameRunningAnswer')
AddEventHandler('DD:Server:IsGameRunningAnswer', function(Player, State, FreezeT, Time, FreezeW, Weather)
	TriggerClientEvent('DD:Client:IsGameRunningAnswer', Player, State, FreezeT, Time, FreezeW, Weather)
end)

RegisterServerEvent('DD:Server:GetAdminInfos')
AddEventHandler('DD:Server:GetAdminInfos', function()
	TriggerClientEvent('DD:Client:GotAdminInfos', source, IsPlayerAceAllowed(source, 'DD'), Maps)
end)

RegisterServerEvent('DD:Server:TestMode')
AddEventHandler('DD:Server:TestMode', function(TestMode)
	TriggerClientEvent('DD:Client:TestMode', -1, TestMode, GetIdentifier(source, 'license'))
end)

RegisterServerEvent('DD:Server:CheckAdminConnectionStatus')
AddEventHandler('DD:Server:CheckAdminConnectionStatus', function(Admin)
	local Clients = GetPlayers()
	for Key, Value in ipairs(Clients) do
		if GetIdentifier(Value, 'license') == Admin then
			return
		end
		
		if Key == #Clients then
			TriggerClientEvent('DD:Client:AdminDisconnected', -1, false)
		end
	end
end)

RegisterServerEvent('DD:Server:LoadMap')
AddEventHandler('DD:Server:LoadMap', function(Map)
	local Source = source
	Citizen.CreateThread(function()
		if IsTableContainingValue(Maps, Map[1], true) then
			local MapFile = io.open('DemolitionDerbyMaps' .. GetOSSep() .. Map[1], 'r')
			local MapFileContent = MapFile:read('*a')
			local MapFileContentToLUA = MapToLUA(MapFileContent)
			MapFile:close()
			LoadLeaderboard(Map[1], MapFileContentToLUA, Source)
		else
			print('ERROR!\nMap not found!')
		end
	end)
end)

RegisterServerEvent('DD:Server:UpdateLeaderboard')
AddEventHandler('DD:Server:UpdateLeaderboard', function(IsWin)
	local Source = source
	local Identifier = GetIdentifier(Source, 'license')

	if not IsTableContainingKey(Leaderboard, Identifier) then
		Leaderboard[Identifier] = {['Name'] = GetPlayerName(Source), ['Won'] = 0, ['Lost'] = 0}
	end

	Leaderboard[Identifier].Name = GetPlayerName(Source)

	if IsWin then
		Leaderboard[Identifier].Won = Leaderboard[Identifier].Won + 1
	else
		Leaderboard[Identifier].Lost = Leaderboard[Identifier].Lost + 1
	end

	TriggerClientEvent('DD:Client:UpdateLeaderboard', -1, Leaderboard)
end)

RegisterServerEvent('DD:Server:GetLeaderboard')
AddEventHandler('DD:Server:GetLeaderboard', function()
	TriggerClientEvent('DD:Client:UpdateLeaderboard', source, Leaderboard)
end)

