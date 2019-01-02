function SpawnMap(MapName, MapTable, Class, SpawnPlayer)
	if #MapTable.Vehicles >= MaximumPlayer then
		if NetworkIsHost() then
			local SpawnLocation = MapReceived[3].Vehicles[Player + 1]
			local Ped = PlayerPedId()

			SetEntityCoords(Ped, tonumber(SpawnLocation.X), tonumber(SpawnLocation.Y), tonumber(SpawnLocation.Z), false, false, false, false)
			
			FreezeEntityPosition(Ped, true)

			local Deleted = 0
			for Ped in EnumeratePeds() do
				if not IsPedAPlayer(Ped) and Deleted < 100 then
					Deleted = Deleted + 1
					FreezeEntityPosition(Ped, false)
					SetEntityAsMissionEntity(Ped, false, false)
					DeleteEntity(Ped)
				else
					break
				end
			end
			Deleted = 0
			for Vehicle in EnumerateVehicles() do
				if Deleted < 100 then
					Deleted = Deleted + 1
					FreezeEntityPosition(Vehicle, false)
					SetEntityAsMissionEntity(Vehicle, false, false)
					DeleteEntity(Vehicle)
				else
					break
				end
			end
		end
		if #SpawnedProps > 0 then
			local Coords = GetEntityCoords(SpawnedProps[1], false)
			ClearAreaOfCops(Coords, 500.0, 0)
			ClearAreaOfObjects(Coords, 500.0, 0)
			ClearAreaOfPeds(Coords, 500.0, 1)
			ClearAreaOfProjectiles(Coords, 500.0, true)
			ClearAreaOfVehicles(Coords, 500.0, false, false, false, false, false)
		end

		for Key, Prop in ipairs(SpawnedProps) do
			while DoesEntityExist(Prop) do
				Citizen.Wait(0)
				if not IsEntityAMissionEntity(Prop) then
					SetEntityAsMissionEntity(Prop, true, true)
				end
				DeleteObject(Prop)
			end
		end
		SpawnedProps = {}

		for CategoryKey, PickupCategory in pairs(SpawnedPickups) do
			for PickupKey, Pickup in pairs(PickupCategory) do
				while DoesPickupExist(Pickup.Id) do
					Citizen.Wait(0)
					RemovePickup(Pickup.Id)
				end
			end
		end
		SpawnedPickups = {['Repair'] = {}, ['Boost'] = {}}

		for Key, Value in ipairs(MapTable.Props) do
			if Key == 1 then ReferenceZ = tonumber(Value.Z) end
			if IsModelValid(tonumber(Value.ModelHash)) then
				if not HasModelLoaded(tonumber(Value.ModelHash)) then
					RequestModel(tonumber(Value.ModelHash))
					while not HasModelLoaded(tonumber(Value.ModelHash)) do
						Citizen.Wait(0)
					end
				end
				if IsRepairPickup(Value.ModelHash) then
					local Pickup = CreatePickupRotate(160266735, tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), 0.0, 0.0, 0.0, 512, 1000, 2, 1, tonumber(Value.ModelHash))
					table.insert(SpawnedPickups.Repair, {['Hash'] = tonumber(Value.ModelHash), ['Id'] = Pickup, ['Object'] = GetPickupObject(Pickup)})
					SetPickupRegenerationTime(Pickup, 10000)
				elseif IsBoostPickup(Value.ModelHash) then
					local Pickup = CreatePickupRotate(-1514616151, tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), 0.0, 0.0, 0.0, 512, 1000, 2, 1, tonumber(Value.ModelHash))
					table.insert(SpawnedPickups.Boost, {['Hash'] = tonumber(Value.ModelHash), ['Id'] = Pickup, ['Object'] = GetPickupObject(Pickup)})
					SetPickupRegenerationTime(Pickup, 10000)
				else
					local Dynamic = false
					if Value.Dynamic == 'true' or IsExplosive(Value.ModelHash) then Dynamic = true end
					Value.Pitch = tonumber(Value.Pitch) + 0.0
					Value.Roll = tonumber(Value.Roll) + 0.0
					Value.Yaw = tonumber(Value.Yaw) + 0.0

					local Prop = CreateObject(tonumber(Value.ModelHash), tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), false, false, Dynamic)

					table.insert(SpawnedProps, Prop)

					SetEntityCollision(Prop, false, false)
					SetEntityCoords(Prop, tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), false, false, false, false)
					SetEntityDynamic(Prop, Dynamic)
					SetEntityRotation(Prop, Value.Pitch, Value.Roll, Value.Yaw, 2, 0)
					FreezeEntityPosition(Prop, not Dynamic)
					SetEntityCollision(Prop, true, true)

					SetEntityAsMissionEntity(Prop, true, true)
				end
				SetModelAsNoLongerNeeded(tonumber(Value.ModelHash))
			end
		end

		if SpawnPlayer then
			SpawnMe(MapReceived[3].Vehicles[PlayerId() + 1], Class)
		end
	else
		GameStarted = false
		ShowNotification('~r~ERROR!~n~Only ' .. #MapTable.Vehicles .. ' of ' .. MaximumPlayer .. ' Spawnpoints.')
		ShowNotification('~r~' .. GetLabelText('FMMC_RANDFAIL') .. '~y~' .. GetLabelText('USJ_FAILSAFE'))
	end
end

