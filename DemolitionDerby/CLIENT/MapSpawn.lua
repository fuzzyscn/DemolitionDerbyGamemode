function SpawnMap(MapName, MapTable, Class)
	if #MapTable.Vehicles >= MaximumPlayer then
		if #SpawnedProps > 0 and NetworkIsHost() then
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
					if Value.Dynamic == 'true' then Dynamic = true end
					local Prop = CreateObject(tonumber(Value.ModelHash), tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), false, false, Dynamic)

					table.insert(SpawnedProps, Prop)

					SetEntityCollision(Prop, false, false)
					SetEntityCoords(Prop, tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), false, false, false, false)
					Value.Pitch = tonumber(Value.Pitch) + 0.0
					Value.Roll = tonumber(Value.Roll) + 0.0
					Value.Yaw = tonumber(Value.Yaw) + 0.0
					if Value.Pitch < 0.0 then Value.Pitch = 180.0 + (180.0 - math.abs(Value.Pitch)) end
					SetEntityRotation(Prop, Value.Pitch, Value.Roll, Value.Yaw, 3, 0)
					FreezeEntityPosition(Prop, true)
					SetEntityCollision(Prop, true, true)

					SetEntityAsMissionEntity(Prop, false, true)
					SetEntityAsMissionEntity(Prop, true, true)
				end
				SetModelAsNoLongerNeeded(tonumber(Value.ModelHash))
				
			end
		end
		
		SpawnMe(MapReceived[3].Vehicles[PlayerId() + 1], Class)
	else
		GameStarted = false
		ShowNotification('~r~ERROR!~n~Only ' .. #MapTable.Vehicles .. ' Spawnpoints.~n~' .. MaximumPlayer - #MapTable.Vehicles .. ' missing!')
		ShowNotification('~r~' .. GetLabelText('FMMC_RANDFAIL') .. '~y~' .. GetLabelText('USJ_FAILSAFE'))
	end
end

