function SpawnMe(SpawnLocation, VehicleClass)
	local Ped = PlayerPedId(); Player = PlayerId()
	RemoveMyVehicle()

	local Vehicle = GetRandomVehicleFromClass(VehicleClass);
		  X = tonumber(SpawnLocation.X); Y = tonumber(SpawnLocation.Y); Z = tonumber(SpawnLocation.Z);
		  Pitch = tonumber(SpawnLocation.Pitch); Roll = tonumber(SpawnLocation.Roll); Yaw = tonumber(SpawnLocation.Yaw);

	if not HasModelLoaded(Vehicle) then
		RequestModel(Vehicle)
		while not HasModelLoaded(Vehicle) do
			Citizen.Wait(0)
		end
	end

	local VehicleHandle = CreateVehicle(Vehicle, X, Y, Z, 0.0, true, false)
	while not VehicleHandle do
		Citizen.Wait(0)
	end
	SetPedIntoVehicle(Ped, VehicleHandle, -1)
	SetEntityRotation(VehicleHandle, Pitch, Roll, Yaw, 0, true)
	SetPedCanBeKnockedOffVehicle(Ped, 1)
	SetPedCanBeDraggedOut(Ped, false)
	SetPedConfigFlag(Ped, 32, false)

	FreezeEntityPosition(VehicleHandle, true)

	SetVehicleDoorsLocked(VehicleHandle, 4)
	SetVehicleDoorsLockedForAllPlayers(VehicleHandle, true)
	SetVehicleHasBeenOwnedByPlayer(VehicleHandle, true)

	SetModelAsNoLongerNeeded(Vehicle)

--[[	while not IsVehicleOnAllWheels(Vehicle) do
		Citizen.Wait(0)
		SetEntityCoords(VehicleHandle, X, Y, Z, false, false, false, false)
		SetEntityRotation(VehicleHandle, Pitch, Roll, Yaw, 0, true)
		SetVehicleOnGroundProperly(VehicleHandle)
	end]]

	ScreenFadeIn(1500)

	TriggerServerEvent('DD:S:Ready', Player)

	GameStarted = true

	ShowNotification('~g~' .. GetLabelText('FM_COR_FLCH'):gsub('~a~', GetActualMapName(MapReceived[2])))
	ShowNotification('~g~' .. GetLabelText('PM_CREATED') .. ' ' .. GetMapCreator(MapReceived[2]))
end

