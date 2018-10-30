RegisterServerEvent('DD:S:ToRCON')
AddEventHandler('DD:S:ToRCON', function(String)
	print(String)
end)

RegisterServerEvent('DD:S:SyncTimeAndWeather')
AddEventHandler('DD:S:SyncTimeAndWeather', function(Time, Weather)
	TriggerClientEvent('DD:C:SyncTimeAndWeather', -1, Time, Weather)
end)

RegisterServerEvent('DD:S:FreezeTime')
AddEventHandler('DD:S:FreezeTime', function(FreezeT, Time)
	TriggerClientEvent('DD:C:FreezeTime', -1, FreezeT, Time)
end)

RegisterServerEvent('DD:S:FreezeWeather')
AddEventHandler('DD:S:FreezeWeather', function(FreezeW, Weather)
	TriggerClientEvent('DD:C:FreezeWeather', -1, FreezeW, Weather)
end)

RegisterServerEvent('DD:S:GameFinished')
AddEventHandler('DD:S:GameFinished', function(MapName, IsTestMode)
	if not IsTestMode then
		SaveLeaderboard(MapName)
	end
	
	ResetVariables()

	TriggerClientEvent('DD:C:GameFinished', -1)
end)

RegisterServerEvent('DD:S:IsGameRunning')
AddEventHandler('DD:S:IsGameRunning', function()
	if GetNumPlayerIndices() > 1 then
		TriggerClientEvent('DD:C:IsGameRunning', -1, source)
	else
		TriggerClientEvent('DD:C:IsGameRunningAnswer', source, false)
	end
end)

RegisterServerEvent('DD:S:IsGameRunningAnswer')
AddEventHandler('DD:S:IsGameRunningAnswer', function(Player, State, FreezeT, Time, FreezeW, Weather)
	TriggerClientEvent('DD:C:IsGameRunningAnswer', Player, State, FreezeT, Time, FreezeW, Weather)
end)

RegisterServerEvent('DD:S:GetAdminInfos')
AddEventHandler('DD:S:GetAdminInfos', function()
	TriggerClientEvent('DD:C:GotAdminInfos', source, IsPlayerAceAllowed(source, 'DD'), Maps)
end)

RegisterServerEvent('DD:S:TestMode')
AddEventHandler('DD:S:TestMode', function(TestMode)
	AdminTestMode = TestMode
	AdminTestModeAdmin = GetIdentifier(source, 'license')
	TriggerClientEvent('DD:C:TestMode', -1, AdminTestMode)
end)

RegisterServerEvent('DD:S:LoadMap')
AddEventHandler('DD:S:LoadMap', function(Map, VehicleClass)
	local Source = tonumber(source)
	if Source == nil then Source = tonumber(GetPlayers()[1]) end
	Citizen.CreateThread(function()
		if IsTableContainingValue(Maps, Map[1], true) then
			LastMap = Map
			local MapFile = io.open('DemolitionDerbyMaps' .. GetOSSep() .. Map[1], 'r')
			local MapFileContent = MapFile:read('*a')
			local MapFileContentToLUA = MapToLUA(MapFileContent)
			MapFile:close()
			LoadLeaderboard(Map[1], MapFileContentToLUA, VehicleClass)
		else
			print('ERROR!\nMap not found!')
		end
	end)
end)

RegisterServerEvent('DD:S:UpdateLeaderboard')
AddEventHandler('DD:S:UpdateLeaderboard', function(IsWin)
	print('Server Event \'DD:S:UpdateLeaderboard\' called')
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

	TriggerClientEvent('DD:C:UpdateLeaderboard', -1, Leaderboard)
end)

RegisterServerEvent('DD:S:GetLeaderboard')
AddEventHandler('DD:S:GetLeaderboard', function()
	TriggerClientEvent('DD:C:UpdateLeaderboard', source, Leaderboard)
end)

RegisterServerEvent('DD:S:Ready')
AddEventHandler('DD:S:Ready', function(Player)
	if not GameStarted then
		GameStarted = true
	end
	table.insert(ReadyPlayers, source)
	TriggerClientEvent('DD:C:Ready', -1, Player)
end)

RegisterServerEvent('DD:S:Spawned')
AddEventHandler('DD:S:Spawned', function()
	table.insert(SpawnedPlayers, source)
end)

RegisterServerEvent('DD:S:Died')
AddEventHandler('DD:S:Died', function()
	table.insert(DiedPlayers, source)
end)

RegisterServerEvent('DD:S:MapSelectionMade')
AddEventHandler('DD:S:MapSelectionMade', function(SelectedMap, SelectionIsPlayAgain)
	if SelectionIsPlayAgain then
		SelectedMap = 10
	end
	table.insert(MapSelections[SelectedMap], source)
	table.insert(MapVoted, source)
end)

RegisterServerEvent('DD:S:VehicleClassSelectionMade')
AddEventHandler('DD:S:VehicleClassSelectionMade', function(SelectedVehicleClass)
	table.insert(VehicleClassSelections[SelectedVehicleClass], source)
	table.insert(VehicleClassVoted, source)
end)

RegisterServerEvent('DD:S:GotLivingPlayer')
AddEventHandler('DD:S:GotLivingPlayer', function(LivingPlayersTable)
	LivingPlayers = LivingPlayersTable
end)

RegisterServerEvent('DD:S:AmIAlone')
AddEventHandler('DD:S:AmIAlone', function(Players)
	if GetNumPlayerIndices() == 1 and GetNumPlayerIndices() ~= #Players then
		TriggerEvent('DD:S:GameFinished', LastMap[1], AdminTestMode)
	end
end)

AddEventHandler("playerDropped", function(Reason)
	if IsTableContainingValue(SpawnedPlayers, source, false) then
		SpawnedPlayers = RemoveValueFromTable(SpawnedPlayers, source)
	end
	if IsTableContainingValue(ReadyPlayers, source, false) then
		ReadyPlayers = RemoveValueFromTable(ReadyPlayers, source)
	end
	if IsTableContainingValue(DiedPlayers, source, false) then
		DiedPlayers = RemoveValueFromTable(DiedPlayers, source)
	end
end)

