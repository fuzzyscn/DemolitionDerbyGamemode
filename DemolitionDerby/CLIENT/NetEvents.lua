RegisterNetEvent('DD:Client:ToConsole')
AddEventHandler('DD:Client:ToConsole', function(String)
	Citizen.Trace(String)
end)

RegisterNetEvent('DD:Client:Countdown')
AddEventHandler('DD:Client:Countdown', function(State)
	StartState = State
end)

RegisterNetEvent('DD:Client:Ready')
AddEventHandler('DD:Client:Ready', function(Player)
	table.insert(ReadyPlayers, Player)
end)

RegisterNetEvent('DD:Client:GameFinished')
AddEventHandler('DD:Client:GameFinished', function()
	GameStarted = false; GameRunning = false; StartState = nil; ReadyPlayers = {}; CurrentlySpectating = -1;
	IsAlive = true; CountdownScaleform = nil; MidGameJoiner = false; AFKKickEnabled = false; DoCountdown = false;
	ScaleformCheckValue = -1; FinishTriggered = false; Leaderboard = {}; LossAdded = false; WinAdded = false;
	ShowLeaderboard = false;

	if NetworkIsInSpectatorMode() then
		Spectate(false, PlayerId())
	end
	RemoveMyVehicle()
	Respawn()
end)

RegisterNetEvent('DD:Client:SpawnMap')
AddEventHandler('DD:Client:SpawnMap', function(MapName, MapTable, Source)
	MapReceived[2] = MapName
	MapReceived[3] = MapTable
	MapReceived[4] = Source
	MapReceived[1] = true
end)

RegisterNetEvent('DD:Client:MapInformations')
AddEventHandler('DD:Client:MapInformations', function(RandomVehicleClass)
	VehicleClass = RandomVehicleClass

	MySpawnPosition = MapReceived[3].Vehicles[PlayerId() + 1]
	if MySpawnPosition then
		SpawnMeNow = true
	end
end)

RegisterNetEvent('DD:Client:SyncTimeAndWeather')
AddEventHandler('DD:Client:SyncTimeAndWeather', function(Time, Weather)
	if not NetworkIsHost() then
		SetClockDate(Time.Day, Time.Month, Time.Year)
		SetClockTime(Time.Hour, Time.Minute, Time.Second)
		SetWeatherTypeNow(Weather)
		SetOverrideWeather(Weather)
	end
end)

RegisterNetEvent('DD:Client:IsGameRunning')
AddEventHandler('DD:Client:IsGameRunning', function(Player)
	if NetworkIsHost() then
		TriggerServerEvent('DD:Server:IsGameRunningAnswer', Player, GameStarted)
	end
end)

RegisterNetEvent('DD:Client:IsGameRunningAnswer')
AddEventHandler('DD:Client:IsGameRunningAnswer', function(State)
	GameStarted = State; GameRunning = State; MidGameJoiner = State
	if not GameStarted then
		Respawn()
	else
		TriggerServerEvent('DD:Server:GetLeaderboard')
	end
end)

RegisterNetEvent('DD:Client:GotDevInfos')
AddEventHandler('DD:Client:GotDevInfos', function(Allowed, Maps)
	IsDev = Allowed
	AvailableMaps = Maps
	TriggerEvent('DD:Client:SetUpDevMenu')
end)

RegisterNetEvent('DD:Client:DevMode')
AddEventHandler('DD:Client:DevMode', function(DevMode)
	DevTestMode = DevMode
	if DevTestMode then
		NeededPlayer = 1
	else
		NeededPlayer = 2
	end
end)

AddEventHandler('onClientGameTypeStart', function()
	if GetIsLoadingScreenActive() then
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
	end

	TriggerServerEvent('DD:Server:GetDevInfos')

	if NetworkGetNumConnectedPlayers() > 1 then
		TriggerServerEvent('DD:Server:IsGameRunning')
	else
		TriggerEvent('DD:Client:IsGameRunningAnswer', false)
	end
end)

RegisterNetEvent('DD:Client:UpdateLeaderboard')
AddEventHandler('DD:Client:UpdateLeaderboard', function(LB)
	Leaderboard = LB
end)

