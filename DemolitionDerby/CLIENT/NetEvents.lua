RegisterNetEvent('DD:C:ToConsole')
AddEventHandler('DD:C:ToConsole', function(String)
	Citizen.Trace(String)
end)

RegisterNetEvent('DD:C:Countdown')
AddEventHandler('DD:C:Countdown', function(State, GoPhase)
	if State >= 1 then
		PlaySoundFrontend(-1, '3_2_1', 'HUD_MINI_GAME_SOUNDSET', 1)
	end
	if GoPhase then
		PlaySoundFrontend(-1, 'GO', 'HUD_MINI_GAME_SOUNDSET', 1)
	else
		StartState = State
	end
end)

RegisterNetEvent('DD:C:Ready')
AddEventHandler('DD:C:Ready', function(Player)
	table.insert(ReadyPlayers, Player)
end)

RegisterNetEvent('DD:C:GameFinished')
AddEventHandler('DD:C:GameFinished', function(NumberOfSpawnedPlayers)
	if NumberOfSpawnedPlayers > 1 and not AdminTestMode and IsPlayerAbleToPlay(PlayerId()) then
		TriggerServerEvent('DD:S:UpdateLeaderboard', true)
	end

	ScreenFadeOut(1000)
	if NetworkIsInSpectatorMode() then
		ClearFocus()
		Spectate(false, PlayerId())
	end
	
	ResetVariables()
	RemoveMyVehicle()
	Respawn()
end)

RegisterNetEvent('DD:C:SpawnMap')
AddEventHandler('DD:C:SpawnMap', function(MapName, MapTable, Class)
	MapVoteMaps = {}; MapVoteMapCount = 0; PlayAgainAvailable = false; MapVoteStarted = false; MapSelectionMade = false
	VehiclesClasses = {}; VehicleClassVoteStarted = false; VehicleClassSelectionMade = false
	
	MapReceived[2] = MapName
	MapReceived[3] = MapTable
	MapReceived[4] = Class
	MapReceived[5] = true
	MapReceived[1] = true
	
	TriggerServerEvent('DD:S:GotLivingPlayer', GetLivingPlayers())
end)

RegisterNetEvent('DD:C:SyncTimeAndWeather')
AddEventHandler('DD:C:SyncTimeAndWeather', function(Time, Weather)
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

RegisterNetEvent('DD:C:GameRunning')
AddEventHandler('DD:C:GameRunning', function()
	DoCountdown = false
	GameRunning = true
end)

RegisterNetEvent('DD:C:GameStatus')
AddEventHandler('DD:C:GameStatus', function(State, NumberOfPlayers, FreezeT, Time, FreezeW, Weather)
	if FreezeT ~= nil then
		FreezeTime = FreezeT
	end
	if Time ~= nil then
		FrozenTime = Time
		CurrentTime = Time
	end
	if FreezeW ~= nil then
		FreezeWeather = FreezeW
	end
	if Weather ~= nil then
		FrozenWeather = Weather
		CurrentWeather = Weather
	end
	if State then
		GameStarted = true
		GameRunning = true
		MidGameJoiner = true
		
		if not MapReceived[1] then
			TriggerServerEvent('DD:S:GetMap')
		end
		StopLoadingScreen()
		TriggerServerEvent('DD:S:GetLeaderboard')
	else
		if NumberOfPlayers ~= 2 then
			Respawn()
		end
	end
end)

RegisterNetEvent('DD:C:GotAdminInfos')
AddEventHandler('DD:C:GotAdminInfos', function(Allowed, Maps)
	IsAdmin = Allowed
	AvailableMaps = Maps
	TriggerEvent('DD:C:SetUpAdminMenu')
end)

RegisterNetEvent('DD:C:TestMode')
AddEventHandler('DD:C:TestMode', function(TestMode, Admin)
	AdminTestMode = TestMode
	if AdminTestMode then
		NeededPlayer = 1
	else
		NeededPlayer = 2
	end
end)

RegisterNetEvent('DD:C:AdminDisconnected')
AddEventHandler('DD:C:AdminDisconnected', function()
	AdminTestMode = false
	NeededPlayer = 2
end)

RegisterNetEvent('DD:C:FreezeTime')
AddEventHandler('DD:C:FreezeTime', function(FreezeT, Time)
	FrozenTime = Time
	CurrentTime = Time
	FreezeTime = FreezeT
end)

RegisterNetEvent('DD:C:FreezeWeather')
AddEventHandler('DD:C:FreezeWeather', function(FreezeW, Weather)
	FrozenWeather = Weather
	CurrentWeather = FrozenWeather
	FreezeWeather = FreezeW
end)

AddEventHandler('onClientGameTypeStart', function()
	ScreenFadeOut(0)

	local Ped = PlayerPedId()
	if not HasModelLoaded(SpawnValues.Hash) then
		RequestModel(SpawnValues.Hash)
		while not HasModelLoaded(SpawnValues.Hash) do
			Citizen.Wait(250)
		end
	end
	SetPlayerModel(PlayerId(), SpawnValues.Hash)
	SetModelAsNoLongerNeeded(SpawnValues.Hash)
	while not IsEntityAPed(Ped) do
		Citizen.Wait(250)
		Ped = PlayerPedId()
	end
	
	SetPedRandomComponentVariation(Ped, false)
	SetPedRandomProps(Ped)
	SetCanAttackFriendly(Ped, true, false)
	NetworkSetFriendlyFireOption(true)

	TriggerServerEvent('DD:S:GetAdminInfos')

	TriggerServerEvent('DD:S:GetGameStatus')
end)

RegisterNetEvent('DD:C:UpdateLeaderboard')
AddEventHandler('DD:C:UpdateLeaderboard', function(LB)
	Leaderboard = LB
end)

RegisterNetEvent('DD:C:PickupCollected')
AddEventHandler('DD:C:PickupCollected', function(Pickup)
	if Pickup[2] == PlayerId() and IsBoostPickup(Pickup[5]) then
		if CollectedBoostPickups < 3 then
			DisplayHelpMessage(GetLabelText('VEX_SM_HELP1'):gsub('INPUT_FRONTEND_LS', 'INPUT_VEH_HORN'), 'string', false, true, 3000)
			
			CollectedBoostPickups = CollectedBoostPickups + 1
		end
	end
end)

AddEventHandler('gameEventTriggered', function(Name, Arguments)
	if Name == 'CEventNetworkPlayerCollectedPickup' then
		TriggerEvent('DD:C:PickupCollected', Arguments)
	end
end)

RegisterNetEvent('DD:C:MapVote')
AddEventHandler('DD:C:MapVote', function(Maps, MapCount, IsFirstRound)
	ClientIsConnecting = false
	StartMapVote(Maps, MapCount, IsFirstRound)
end)

RegisterNetEvent('DD:C:VehicleClassVote')
AddEventHandler('DD:C:VehicleClassVote', function(Classes)
	StartVehicleClassVote(Classes)
end)

RegisterNetEvent('DD:C:VoteCountdown')
AddEventHandler('DD:C:VoteCountdown', function(Timer)
	VoteTimer = Timer
end)

RegisterNetEvent('DD:C:GetLivingPlayer')
AddEventHandler('DD:C:GetLivingPlayer', function()
	TriggerServerEvent('DD:S:GotLivingPlayer', GetLivingPlayers())
end)

RegisterNetEvent('DD:C:WaitingForPlayer')
AddEventHandler('DD:C:WaitingForPlayer', function(Waiting)
	WaitingForPlayer = Waiting
end)

RegisterNetEvent('DD:C:ClientIsJoiningOrSpawning')
AddEventHandler('DD:C:ClientIsJoiningOrSpawning', function()
	ClientIsConnecting = true
end)

RegisterNetEvent('DD:C:GotMap')
AddEventHandler('DD:C:GotMap', function(MapName, MapTable)
	MapVoteMaps = {}; MapVoteMapCount = 0; PlayAgainAvailable = false; MapVoteStarted = false; MapSelectionMade = false
	VehiclesClasses = {}; VehicleClassVoteStarted = false; VehicleClassSelectionMade = false
	
	MapReceived[2] = MapName
	MapReceived[3] = MapTable
	MapReceived[4] = Class
	MapReceived[5] = false
	MapReceived[1] = true
end)

