GameStarted = false; GameRunning = false; StartState = nil; ReadyPlayers = {}; CurrentlySpectating = -1; RequestingDone = false; IsAlive = true;
CountdownScaleform = nil; MidGameJoiner = false; AFKKickEnabled = false; NeededPlayer = 2; ScaleformCheckValue = -1; 
DoCountdown = false; VoteTimer = 15; CollectedBoostPickups = 0

Leaderboard = {}; ShowLeaderboard = false

LossAdded = false; WinAdded = false

WaitingForPlayer = true

SpawnedProps = {}; SpawnedPickups = {['Repair'] = {}, ['Boost'] = {}}; MapReceived = {false}; MySpawnPosition = nil; ReferenceZ = 0.0

IsAdmin = false; AvailableMaps = {}; CurrentMap = ''; AdminTestMode = false; CurrentWeather = ''; CurrentTime = {['Hour'] = 0, ['Minute'] = 0}

MaximumPlayer = 32

AvailableWeatherTypes = {
						 'BLIZZARD',
						 'CLEAR',
						 'CLEARING',
						 'CLOUDS',
						 'EXTRASUNNY',
						 'FOGGY',
						 'HALLOWEEN',
						 'NEUTRAL',
						 'OVERCAST',
						 'RAIN',
						 'SMOG',
						 'SNOW',
						 'SNOWLIGHT',
						 'THUNDER',
						 'XMAS',
						}

function ResetVariables()
	GameStarted = false; GameRunning = false; StartState = nil; ReadyPlayers = {}; CurrentlySpectating = -1; IsAlive = true;
	CountdownScaleform = nil; MidGameJoiner = false; AFKKickEnabled = false; ScaleformCheckValue = -1; DoCountdown = false;
	VoteTimer = 15; CollectedBoostPickups = 0; Leaderboard = {}; ShowLeaderboard = false; LossAdded = false; WinAdded = false;
	WaitingForPlayer = true;
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function IsTableContainingKey(Table, SearchedFor)
	if type(Table) == 'table' then
		for Key, Value in pairs(Table) do
			if Key == SearchedFor then
				return true
			end
		end
	end
    return false
end

function IsTableContainingValue(Table, SearchedFor, ValueInSubTable)
	if type(Table) == 'table' then
		for Key, Value in pairs(Table) do
			if not ValueInSubTable and Value == SearchedFor then
				return true
			elseif ValueInSubTable then
				for SubKey, SubValue in pairs(Value) do
					if Value == SearchedFor then
						return true
					end
				end
			end
		end
	end
    return false
end

function GetKeyInTable(Table, SearchedFor)
	for Key, Value in pairs(Table) do
		if Value == SearchedFor then
			return Key
		end
	end
    return nil
end

function StringSplit(Input, Seperator)
    Result = {}
    for match in (Input .. Seperator):gmatch('(.-)' .. Seperator) do
        table.insert(Result, match)
    end
    return Result
end

function GetPlayers()
	local Players = {}
	for i = 0, 31 do
		if NetworkIsPlayerConnected(i) and NetworkIsPlayerActive(i) then
			table.insert(Players, {['id'] = i, ['name'] = GetPlayerName(i)})
		end
	end
    return Players
end

function GetLivingPlayers()
	local LivingPlayers = {}
	for Key, Player in ipairs(GetPlayers()) do
		if IsPlayerAbleToPlay(Player.id) then
			table.insert(LivingPlayers, Player.id)
		end
	end
	return LivingPlayers
end

function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.35)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry('STRING')
	AddTextComponentString(text)
	EndTextCommandDisplayText(x, y)
end

function Draw(Text, R, G, B, A, X, Y, Width, Height, Layer, Center, Font)
	SetTextColour(R, G, B, A)
	SetTextFont(Font)
	SetTextScale(Width, Height)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(Center)
	SetTextDropshadow(0, 0, 0, 0, 0)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry('STRING')
	AddTextComponentSubstringPlayerName(Text)
	SetUiLayer(Layer)
	EndTextCommandDisplayText(X, Y)
end

function _DrawRect(X, Y, Width, Height, R, G, B, A, Layer)
	SetUiLayer(Layer)
	DrawRect(X, Y, Width, Height, R, G, B, A)
end

function _DrawSprite(Dict, Name, X, Y, Width, Height, Heading, R, G, B, A, Layer)
	SetUiLayer(Layer)
	DrawSprite(Dict, Name, X, Y, Width, Height, Heading, R, G, B, A)
end

function ShowNotification(Text)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(Text)
	DrawNotification(false, true)
end

function GetRandomVehicleFromClass(Class)
	local ClassVehicles = Vehicles[Class]

	local RandomIndex = math.random(#ClassVehicles)
	local Vehicle = GetHashKey(ClassVehicles[RandomIndex])
	if not IsModelValid(Vehicle) then
		return GetRandomVehicleFromClass(Class)
	end
	return Vehicle
end

function GetRandomPed()
	local RandomIndex = math.random(#Peds)
	if not IsModelValid(GetHashKey(Peds[RandomIndex][1])) then
		return GetRandomPed()
	end
	return Peds[RandomIndex][1]
end

function ScreenFadeOut(Duration)
	Duration = Duration or 1000
	if not IsScreenFadedOut() then
		DoScreenFadeOut(Duration)
		while IsScreenFadingOut() do
			Citizen.Wait(250)
		end
	end
end

function ScreenFadeIn(Duration)
	Duration = Duration or 1000
	if not IsScreenFadedIn() then
		DoScreenFadeIn(Duration)
		while IsScreenFadingIn() do
			Citizen.Wait(250)
		end
	end
end

function Spectate(Toggle, Player)
	NetworkSetOverrideSpectatorMode(Toggle)
	NetworkSetInSpectatorMode(Toggle, GetPlayerPed(Player))
end

function TeleportMyBodyAway()
	local Ped = PlayerPedId()
	if not IsEntityAtCoord(Ped, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 1, 0) then
		SetEntityVisible(Ped, false, 0)
		SetEntityCollision(Ped, false, 0)
		SetEntityCoords(Ped, 0.0, 0.0, 0.0, false, false, false, false)
	end
end

function SetSpectating()
	local LivingPlayer = GetLivingPlayers()
	CurrentlySpectating = LivingPlayer[math.random(#LivingPlayer)]
	while not IsPlayerAbleToPlay(CurrentlySpectating) do
		Citizen.Wait(250)
		LivingPlayer = GetLivingPlayers()
		CurrentlySpectating = LivingPlayer[math.random(#LivingPlayer)]
	end
	Spectate(true, CurrentlySpectating)
end

function PreviousPlayer(LivingPlayer, CurrentKey)
	if CurrentKey and CurrentKey == 1 then
		CurrentlySpectating = LivingPlayer[#LivingPlayer]
	else
		CurrentlySpectating = LivingPlayer[CurrentKey - 1]
	end
	ScreenFadeOut(1000)
	Spectate(true, CurrentlySpectating)
	ScreenFadeIn(1000)
end

function NextPlayer(LivingPlayer, CurrentKey)
	if CurrentKey and CurrentKey < #LivingPlayer then
		CurrentlySpectating = LivingPlayer[CurrentKey + 1]
	else
		CurrentlySpectating = LivingPlayer[1]
	end
	ScreenFadeOut(1000)
	Spectate(true, CurrentlySpectating)
	ScreenFadeIn(1000)
end

function SpectatingControl()
	local PedSpectating = GetPlayerPed(CurrentlySpectating)
	local LivingPlayer = GetLivingPlayers()
	local CurrentKey = GetKeyInTable(LivingPlayer, CurrentlySpectating)

	if not IsPlayerAbleToPlay(CurrentlySpectating) then
		NextPlayer(LivingPlayer, CurrentKey)
	end

	if not IsEntityFocus(PedSpectating) then
		SetFocusEntity(PedSpectating)
	end

	ScaleformHandle = PreIBUse('INSTRUCTIONAL_BUTTONS', {{['Slot'] = 0, ['Control'] = 175, ['Text'] = GetLabelText('HUD_SPECDN')}, {['Slot'] = 1, ['Control'] = 174, ['Text'] = GetLabelText('HUD_SPECUP')}})
	DrawScaleformMovieFullscreen(ScaleformHandle, 255, 255, 255, 255, 0)

	if IsControlJustPressed(1, 174) then
		PreviousPlayer(LivingPlayer, CurrentKey)
	elseif IsControlJustPressed(1, 175) then
		NextPlayer(LivingPlayer, CurrentKey)
	end
end

function RemoveMyVehicle()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped, true) then
		local Vehicle = GetVehiclePedIsIn(Ped, false)
		SetEntityAsMissionEntity(Vehicle, true, true)
		DeleteEntity(Vehicle)
	end
end

SpawnLocations = {
				  {['x'] = 261.4586, ['y'] = -998.8196, ['z'] = -99.00863, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -18.07856, ['y'] = -583.6725, ['z'] = 79.46569, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -35.31277, ['y'] = -580.4199, ['z'] = 88.71221, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -1468.14, ['y'] = -541.815, ['z'] = 73.4442, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -1477.14, ['y'] = -538.7499, ['z'] = 55.5264, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -915.811, ['y'] = -379.432, ['z'] = 113.6748, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -614.86, ['y'] = 40.6783, ['z'] = 97.60007, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -773.407, ['y'] = 341.766, ['z'] = 211.397, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -169.286, ['y'] = 486.4938, ['z'] = 137.4436, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = 340.9412, ['y'] = 437.1798, ['z'] = 149.3925, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = 373.023, ['y'] = 416.105, ['z'] = 145.7006, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -676.127, ['y'] = 588.612, ['z'] = 145.1698, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -763.107, ['y'] = 615.906, ['z'] = 144.1401, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -857.798, ['y'] = 682.563, ['z'] = 152.6529, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = 120.5, ['y'] = 549.952, ['z'] = 184.097, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -1288, ['y'] = 440.748, ['z'] = 97.69459, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = 261.4586, ['y'] = -998.8196, ['z'] = -99.00863, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -18.07856, ['y'] = -583.6725, ['z'] = 79.46569, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -35.31277, ['y'] = -580.4199, ['z'] = 88.71221, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -1468.14, ['y'] = -541.815, ['z'] = 73.4442, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -1477.14, ['y'] = -538.7499, ['z'] = 55.5264, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -915.811, ['y'] = -379.432, ['z'] = 113.6748, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -614.86, ['y'] = 40.6783, ['z'] = 97.60007, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -773.407, ['y'] = 341.766, ['z'] = 211.397, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -169.286, ['y'] = 486.4938, ['z'] = 137.4436, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = 340.9412, ['y'] = 437.1798, ['z'] = 149.3925, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = 373.023, ['y'] = 416.105, ['z'] = 145.7006, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -676.127, ['y'] = 588.612, ['z'] = 145.1698, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = -763.107, ['y'] = 615.906, ['z'] = 144.1401, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -857.798, ['y'] = 682.563, ['z'] = 152.6529, ['h'] = 0.0, ['hash'] = GetRandomPed()},
				  {['x'] = 120.5, ['y'] = 549.952, ['z'] = 184.097, ['h'] = 0.0, ['hash'] = GetRandomPed()}, {['x'] = -1288, ['y'] = 440.748, ['z'] = 97.69459, ['h'] = 0.0, ['hash'] = GetRandomPed()},
			     };
				 
function Respawn()
	local Ped = PlayerPedId()
	local PlayerID = PlayerId()

	ScreenFadeOut(1500)

	if GetIsLoadingScreenActive() then
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
	end

	SetPlayerControl(PlayerID, false, false)
	SetPlayerInvincible(PlayerID, true)

	SetEntityVisible(Ped, false)
	SetEntityCollision(Ped, false)
	FreezeEntityPosition(Ped, true)

	local SpawnValues = SpawnLocations[PlayerID + 1]
	if not HasModelLoaded(SpawnValues.hash) then
		RequestModel(SpawnValues.hash)
		while not HasModelLoaded(SpawnValues.hash) do
			Citizen.Wait(250)
		end
	end
	SetPlayerModel(PlayerID, SpawnValues.hash)
	SetModelAsNoLongerNeeded(SpawnValues.hash)
	while not IsEntityAPed(Ped) do
		Citizen.Wait(250)
		Ped = PlayerPedId()
	end
	RequestCollisionAtCoord(SpawnValues.x, SpawnValues.y, SpawnValues.z)
	SetEntityCoordsNoOffset(Ped, SpawnValues.x, SpawnValues.y, SpawnValues.z, false, false, false, true)
	NetworkResurrectLocalPlayer(SpawnValues.x, SpawnValues.y, SpawnValues.z, SpawnValues.h, true, true, false)

	ClearPedTasksImmediately(Ped)

	while not HasCollisionLoadedAroundEntity(Ped) do
		Citizen.Wait(250)
	end

	SetPlayerControl(PlayerID, true, false)
	SetPlayerInvincible(PlayerID, false)

	SetPedRandomComponentVariation(Ped, false)
	SetPedRandomProps(Ped)

	SetEntityVisible(Ped, true)
	if not IsPedInAnyVehicle(Ped) then SetEntityCollision(Ped, true) end
	FreezeEntityPosition(Ped, false)
	
	TriggerServerEvent('DD:S:Spawned')
	
	ScreenFadeIn(1500)
end

function PreIBUse(ScaleformName, Controls)
	local ScaleformHandle = RequestScaleformMovie(ScaleformName)
	while not HasScaleformMovieLoaded(ScaleformHandle) do
		Citizen.Wait(0)
	end

	PushScaleformMovieFunction(ScaleformHandle, 'CLEAR_ALL')
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(ScaleformHandle, 'SET_CLEAR_SPACE')
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	for Key, Value in pairs(Controls) do
		PushScaleformMovieFunction(ScaleformHandle, 'SET_DATA_SLOT')
		PushScaleformMovieFunctionParameterInt(Value.Slot)
		if Value.Control == 'Load' then
			PushScaleformMovieMethodParameterInt(50)
		else
			PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, Value.Control, true))
		end
		BeginTextCommandScaleformString('STRING')
		AddTextComponentScaleform(Value.Text)
		EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
	end

	PushScaleformMovieFunction(ScaleformHandle, 'DRAW_INSTRUCTIONAL_BUTTONS')
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(ScaleformHandle, 'SET_BACKGROUND_COLOUR')
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()

	return ScaleformHandle
end

function IsPlayerAbleToPlay(Player)
	if Player ~= nil and not IsPlayerDead(Player) and not (GetEntityModel(GetPlayerPed(Player)) == GetHashKey('PLAYER_ZERO')) then
		return true
	end
	return false
end

function IsRepairPickup(Pickup)
	Pickup = tonumber(Pickup)
	if Pickup == 0xF145F439 or Pickup == 0xE6FA7770 or Pickup == 0x48AC6542 then
		return true
	end
	return false
end

function IsBoostPickup(Pickup)
	Pickup = tonumber(Pickup)
	if Pickup == 0x537308AE or Pickup == 0x65EAF4B2 then
		return true
	end
	return false
end

function GetActualMapName(Map)
	local MapNameDotPosition = Map:reverse():find('%.')
	return Map:sub(1, Map:len() - MapNameDotPosition)
end

function GetWeatherIndex()
	for Key, Weather in ipairs(AvailableWeatherTypes) do
		if GetPrevWeatherTypeHashName() == GetHashKey(Weather) then
			return Key
		end
	end
	return 1
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
	local iter, id = initFunc()
	if not id or id == 0 then
	  disposeFunc(iter)
	  return
	end
	
	local enum = {handle = iter, destructor = disposeFunc}
	setmetatable(enum, entityEnumerator)
	
	local next = true
	repeat
	  coroutine.yield(id)
	  next, id = moveFunc(iter)
	until not next
	
	enum.destructor, enum.handle = nil, nil
	disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function DisplayHelpMessage(Content, Type, Loop, Beep, Duration)
	ClearHelp(1)
	
	Loop = Loop or false
	Beep = Beep or false
	Duration = Duration or -1
	
	BeginTextCommandDisplayHelp('STRING')
	
	if Type:lower() == 'string' and type(Content) == 'string' then
		AddTextComponentSubstringPlayerName(Content)
	elseif Type:lower() == 'label' and type(Content) == 'string' then
		AddTextComponentSubstringTextLabel(Content)
	elseif Type:lower() == 'labelhash' and type(Content) == 'number' then
		AddTextComponentSubstringTextLabelHashKey(Content)
	elseif Type:lower() == 'blip' and type(Content) == 'number' then
		AddTextComponentSubstringBlipName(Content)
	elseif Type:lower() == 'time' and type(Content) == 'table' then
		AddTextComponentSubstringTime(Content[1], Content[2] or 0)
	elseif Type:lower() == 'website' and type(Content) == 'string' then
		AddTextComponentSubstringWebsite(Content)
	end
	
	EndTextCommandDisplayHelp(0, Loop, Beep, Duration)
end

