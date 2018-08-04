GameStarted = false; GameRunning = false; StartState = nil; ReadyPlayers = {}; CurrentlySpectating = -1; RequestingDone = false;
CountdownScaleform = nil; MidGameJoiner = false; AFKKickEnabled = false; NeededPlayer = 2; ScaleformCheckValue = -1

wins = 0;losses = 0;kills = 0

SpawnMeNow = false; VehicleClass = 0

SpawnedPropsLocal = {}; SpawnedProps = {}; MapReceived = {false}; MapSpawned = false; MySpawnPosition = nil; ReferenceZ = 0.0

IsDev = false; AvailableMaps = {}; CurrentMap = ''; DevTestMode = false

MaximumPlayer = 32

function TableContainsKey(Table, SearchedFor)
	for Key, Value in pairs(Table) do
		if Key == SearchedFor then
			return true
		end
	end
    return false
end

function IsTableContainingValue(Table, SearchedFor)
	for Key, Value in pairs(Table) do
		if Value == SearchedFor then
			return true
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
    for match in (Input .. Seperator):gmatch("(.-)" .. Seperator) do
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
	SetTextEntry("STRING")
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
	Set_2dLayer(Layer)
	EndTextCommandDisplayText(X, Y)
end

function _DrawRect(X, Y, Width, Height, R, G, B, A, Layer)
	SetUiLayer(Layer)
	DrawRect(X, Y, Width, Height, R, G, B, A)
end

function ShowNotification(Text)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(Text)
	DrawNotification(false, true)
end

function GetRandomVehicleClass()
	local Class = math.random(0, 8)
	if Class == 8 then
		Class = 9
	end
	return Class
end

function GetRandomVehicleFromClass(Class)
	local ClassVehicles = {}
	for Key, Value in ipairs(Vehicles) do
		if GetVehicleClassFromName(GetHashKey(Value)) == Class then
			table.insert(ClassVehicles, Value)
		end
	end
	
	local RandomIndex = math.random(1, #ClassVehicles)
	local Vehicle = GetHashKey(ClassVehicles[RandomIndex])
	if not IsModelValid(Vehicle) then
		return GetRandomVehicleFromClass(Class)
	end
	return Vehicle
end

function GetRandomPed()
	local RandomIndex = math.random(1, #Peds)
	if not IsModelValid(GetHashKey(Peds[RandomIndex][1])) then
		return GetRandomPed()
	end
	return Peds[RandomIndex][1]
end

function ScreenFadeOut(Duration)
	DoScreenFadeOut(Duration)
	while IsScreenFadingOut() do
		Citizen.Wait(250)
	end
end

function ScreenFadeIn(Duration)
	DoScreenFadeIn(Duration)
	while IsScreenFadingIn() do
		Citizen.Wait(250)
	end
end

function Spectate(Toggle, Player)
	NetworkSetOverrideSpectatorMode(Toggle)
	NetworkSetInSpectatorMode(Toggle, GetPlayerPed(Player))
end

function RemoveMyVehicle()
	if IsPedInAnyVehicle(PlayerPedId(), true) then
		SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), false), true, true)
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
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
	if GetIsLoadingScreenActive() then
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
	end

	ScreenFadeOut(500)

	if IsEntityAttached(PlayerPedId()) then
		DetachEntity(PlayerPedId(), false, true)
	end
	
	SetPlayerControl(PlayerId(), false, false)
	SetPlayerInvincible(PlayerId(), true)

	SetEntityVisible(PlayerPedId(), false)
	SetEntityCollision(PlayerPedId(), false)
	FreezeEntityPosition(PlayerPedId(), true)

	local SpawnValues = SpawnLocations[PlayerId() + 1]
	if not HasModelLoaded(SpawnValues.hash) then
		RequestModel(SpawnValues.hash)
		while not HasModelLoaded(SpawnValues.hash) do
			Citizen.Wait(500)
		end
	end
	SetPlayerModel(PlayerId(), SpawnValues.hash)
	SetModelAsNoLongerNeeded(SpawnValues.hash)
	while not PlayerPedId() do
		Citizen.Wait(1000)
	end
	RequestCollisionAtCoord(SpawnValues.x, SpawnValues.y, SpawnValues.z)
	SetEntityCoordsNoOffset(PlayerPedId(), SpawnValues.x, SpawnValues.y, SpawnValues.z, false, false, false, true)
	NetworkResurrectLocalPlayer(SpawnValues.x, SpawnValues.y, SpawnValues.z, SpawnValues.h, true, true, false)
	
	ClearPedTasksImmediately(PlayerPedId())

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Citizen.Wait(500)
	end

	ScreenFadeIn(500)

	SetPlayerControl(PlayerId(), true, false)
	SetPlayerInvincible(PlayerId(), false)

	SetPedRandomComponentVariation(PlayerPedId(), false)
	SetPedRandomProps(PlayerPedId())

	SetEntityVisible(PlayerPedId(), true)
	if not IsPedInAnyVehicle(PlayerPedId()) then SetEntityCollision(PlayerPedId(), true) end
	FreezeEntityPosition(PlayerPedId(), false)
end

function PreIBUse(ScaleformName, Controls)
	local ScaleformHandle = RequestScaleformMovie(ScaleformName)
	while not HasScaleformMovieLoaded(ScaleformHandle) do
		Citizen.Wait(0)
	end
	
	PushScaleformMovieFunction(ScaleformHandle, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()
	
	PushScaleformMovieFunction(ScaleformHandle, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	for Key, Value in pairs(Controls) do
		PushScaleformMovieFunction(ScaleformHandle, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(Value.Slot)
		if Value.Control == 'Load' then
			PushScaleformMovieMethodParameterInt(50)
		else
			PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, Value.Control, true))
		end
		BeginTextCommandScaleformString("STRING")
		AddTextComponentScaleform(Value.Text)
		EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
	end

	PushScaleformMovieFunction(ScaleformHandle, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(ScaleformHandle, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()

	return ScaleformHandle
end

function IsPlayerAbleToPlay(Player)
	if not IsPlayerDead(Player) and not (GetEntityModel(GetPlayerPed(Player)) == GetHashKey('PLAYER_ZERO')) then
		return true
	end
	return false
end

