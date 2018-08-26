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
		ClearFocus()
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
	if Time then
		CurrentTime = Time
		NetworkOverrideClockTime(Time.Hour, Time.Minute, Time.Second)
	end
	if Weather then
		CurrentWeather = Weather
		SetOverrideWeather(CurrentWeather)
		SetWeatherTypeNowPersist(CurrentWeather)
		ClearOverrideWeather()
		ClearWeatherTypePersist()
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

RegisterNetEvent('DD:Client:GotAdminInfos')
AddEventHandler('DD:Client:GotAdminInfos', function(Allowed, Maps)
	IsAdmin = Allowed
	AvailableMaps = Maps
	TriggerEvent('DD:Client:SetUpAdminMenu')
end)

RegisterNetEvent('DD:Client:TestMode')
AddEventHandler('DD:Client:TestMode', function(TestMode)
	AdminTestMode = TestMode
	if AdminTestMode then
		NeededPlayer = 1
	else
		NeededPlayer = 2
	end
end)

RegisterNetEvent('DD:Client:FreezeTime')
AddEventHandler('DD:Client:FreezeTime', function(FreezeT, Time)
	FrozenTime = Time
	CurrentTime = FrozenTime
	FreezeTime = FreezeT
end)

RegisterNetEvent('DD:Client:FreezeWeather')
AddEventHandler('DD:Client:FreezeWeather', function(FreezeW, Weather)
	FrozenWeather = Weather
	CurrentWeather = FrozenWeather
	FreezeWeather = FreezeW
end)

AddEventHandler('onClientGameTypeStart', function()
	if GetIsLoadingScreenActive() then
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
	end

	TriggerServerEvent('DD:Server:GetAdminInfos')

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

RegisterNetEvent('DD:Client:PickupCollected')
AddEventHandler('DD:Client:PickupCollected', function(Pickup)
	if Pickup['2'] == PlayerId() and IsBoostPickup(Pickup['8']) then
		local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local SpeedVector = GetEntitySpeedVector(Vehicle, true)
		if SpeedVector.y > 0.0 then
			SetVehicleForwardSpeed(Vehicle, 60.0)
		end
	end
end)

--[[
AddEventHandler('gameEventTriggered', function(Name, Arguments)
	print('---------------------------------')
	print(Name)
	print(type(Arguments))
	print(#Arguments)
	for Key, Value in pairs(Arguments) do
		print(Key .. ' - ' .. Value)
	end
	print('---------------------------------')
	
end)
]]