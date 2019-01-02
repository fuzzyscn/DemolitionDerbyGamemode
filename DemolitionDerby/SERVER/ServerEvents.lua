RegisterServerEvent('DD:S:ToRCON')
AddEventHandler('DD:S:ToRCON', function(String)
	print(String)
end)

RegisterServerEvent('DD:S:SyncTimeAndWeather')
AddEventHandler('DD:S:SyncTimeAndWeather', function(Time, Weather)
	TriggerClientEvent('DD:C:SyncTimeAndWeather', -1, Time, Weather)
end)

RegisterServerEvent('DD:S:FreezeTime')
AddEventHandler('DD:S:FreezeTime', function(FreezeTime, Time)
	FreezeT = FreezeTime
	FrozenTime = Time
	TriggerClientEvent('DD:C:FreezeTime', -1, FreezeTime, Time)
end)

RegisterServerEvent('DD:S:FreezeWeather')
AddEventHandler('DD:S:FreezeWeather', function(FreezeWeather, Weather)
	FreezeW = FreezeWeather
	FrozenWeather = Weather
	TriggerClientEvent('DD:C:FreezeWeather', -1, FreezeWeather, Weather)
end)

RegisterServerEvent('DD:S:GameFinished')
AddEventHandler('DD:S:GameFinished', function(NumberOfSpawnedPlayers)
	ResetVariables()

	TriggerClientEvent('DD:C:GameFinished', -1, NumberOfSpawnedPlayers)
end)

RegisterServerEvent('DD:S:GetGameStatus')
AddEventHandler('DD:S:GetGameStatus', function()
	local Source = source
	TriggerClientEvent('DD:C:GameStatus', Source, GameStarted, GetNumPlayerIndices(), FreezeT, FrozenTime, FreezeW, Weather)
end)

RegisterServerEvent('DD:S:GetAdminInfos')
AddEventHandler('DD:S:GetAdminInfos', function()
	local Source = source
	TriggerClientEvent('DD:C:GotAdminInfos', Source, IsPlayerAceAllowed(Source, 'DD'), Maps)
end)

RegisterServerEvent('DD:S:TestMode')
AddEventHandler('DD:S:TestMode', function(TestMode)
	local Source = source
	AdminTestMode = TestMode
	AdminTestModeAdmin = GetIdentifier(Source, 'license')
	TriggerClientEvent('DD:C:TestMode', -1, AdminTestMode)
end)

RegisterServerEvent('DD:S:LoadMap')
AddEventHandler('DD:S:LoadMap', function(Map, VehicleClass)
	if IsTableContainingValue(Maps, Map[1], true) then
		LastMap = Map
		local MapFile = io.open(ConvertedMapsPath .. Map[1] .. '.json', 'r')
		local MapFileContent = MapFile:read('*a')
		MapFile:close()
		LoadLeaderboard(Map[1], json.decode(MapFileContent), VehicleClass)
	else
		print('ERROR!\nMap \'' .. Map[1] .. '\' not found!')
	end
end)

RegisterServerEvent('DD:S:UpdateLeaderboard')
AddEventHandler('DD:S:UpdateLeaderboard', function(IsWin, Client)
	print('Server Event \'DD:S:UpdateLeaderboard\' called')
	local Source = source or Client
	local Identifier = GetIdentifier(Source, 'license')
	if Identifier then
		if not IsTableContainingKey(Leaderboard, Identifier) then
			Leaderboard[Identifier] = {['Name'] = GetPlayerName(Source), ['Won'] = 0, ['Lost'] = 0}
		end

		Leaderboard[Identifier].Name = GetPlayerName(Source)

		if IsWin then
			Leaderboard[Identifier].Won = Leaderboard[Identifier].Won + 1
		else
			Leaderboard[Identifier].Lost = Leaderboard[Identifier].Lost + 1
		end

		if not AdminTestMode then
			SaveLeaderboard(LastMap[1])
		end
		
		TriggerClientEvent('DD:C:UpdateLeaderboard', -1, Leaderboard)
	end
end)

RegisterServerEvent('DD:S:GetLeaderboard')
AddEventHandler('DD:S:GetLeaderboard', function()
	local Source = source
	TriggerClientEvent('DD:C:UpdateLeaderboard', Source, Leaderboard)
end)

RegisterServerEvent('DD:S:Ready')
AddEventHandler('DD:S:Ready', function(Player)
	local Source = source
	if not IsTableContainingValue(ReadyPlayers, Source, false) then
		if not GameStarted then
			GameStarted = true
		end
		table.insert(ReadyPlayers, Source)
		TriggerClientEvent('DD:C:Ready', -1, Player)
	end
end)

RegisterServerEvent('DD:S:Spawned')
AddEventHandler('DD:S:Spawned', function()
	local Source = source
	if not IsTableContainingValue(SpawnedPlayers, Source, false) then
		table.insert(SpawnedPlayers, Source)
	end
end)

RegisterServerEvent('DD:S:Died')
AddEventHandler('DD:S:Died', function()
	local Source = source
	if not IsTableContainingValue(DiedPlayers, Source, false) then
		table.insert(DiedPlayers, Source)
	end
end)

RegisterServerEvent('DD:S:MapSelectionMade')
AddEventHandler('DD:S:MapSelectionMade', function(SelectedMap, SelectionIsPlayAgain)
	local Source = source
	if SelectionIsPlayAgain then
		SelectedMap = 10
	end
	if SelectedMap > 0 or SelectedMap < 10 then
		if type(MapSelections[SelectedMap]) ~= 'table' then
			MapSelections[SelectedMap] = {}
		end
		table.insert(MapSelections[SelectedMap], Source)
		table.insert(MapVoted, Source)
	end
end)

RegisterServerEvent('DD:S:VehicleClassSelectionMade')
AddEventHandler('DD:S:VehicleClassSelectionMade', function(SelectedVehicleClass)
	local Source = source
	if SelectedVehicleClass > 0 or SelectedVehicleClass < 10 then
		if type(VehicleClassSelections[SelectedVehicleClass]) ~= 'table' then
			VehicleClassSelections[SelectedVehicleClass] = {}
		end
		table.insert(VehicleClassSelections[SelectedVehicleClass], Source)
		table.insert(VehicleClassVoted, Source)
	end
end)

RegisterServerEvent('DD:S:GotLivingPlayer')
AddEventHandler('DD:S:GotLivingPlayer', function(LivingPlayersTable)
	LivingPlayers = LivingPlayersTable
end)

RegisterServerEvent('DD:S:AmIAlone')
AddEventHandler('DD:S:AmIAlone', function(Players)
	if GetNumPlayerIndices() == 1 and GetNumPlayerIndices() ~= #Players then
		TriggerEvent('DD:S:GameFinished', #SpawnedPlayers)
	end
end)

RegisterServerEvent('DD:S:GetMap')
AddEventHandler('DD:S:GetMap', function()
	local Source = source
	local MapFile = io.open(ConvertedMapsPath .. LastMap[1] .. '.json', 'r')
	local MapFileContent = MapFile:read('*a')
	MapFile:close()

	TriggerClientEvent('DD:C:UpdateLeaderboard', -1, Leaderboard)
	TriggerClientEvent('DD:C:GotMap', Source, LastMap[1], json.decode(MapFileContent))
end)

AddEventHandler('playerDropped', function()
	local Source = source
	local Name = GetPlayerName(Source)
	
	if GetIdentifier(Source, 'license') == AdminTestModeAdmin then
		AdminDisconnected()
	end
	
	local Spawned = IsTableContainingValue(SpawnedPlayers, Source, false)
	local Ready = IsTableContainingValue(ReadyPlayers, Source, false)
	local Died = IsTableContainingValue(DiedPlayers, Source, false)
	local OnePlayerLeft = #SpawnedPlayers - #DiedPlayers == 1
	if Spawned then
		if not OnePlayerLeft and not Died then
			TriggerEvent('DD:S:UpdateLeaderboard', false, Source)
		end
		SpawnedPlayers = RemoveValueFromTable(SpawnedPlayers, Source)
	end
	if Ready then
		ReadyPlayers = RemoveValueFromTable(ReadyPlayers, Source)
	end
	if Died then
		DiedPlayers = RemoveValueFromTable(DiedPlayers, Source)
	end
end)

