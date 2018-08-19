function SpawnMap(MapName, MapTable, ID)
	if #MapTable.Vehicles >= MaximumPlayer then
		for Key, Value in ipairs(SpawnedProps) do
			while DoesEntityExist(Value) do
				Citizen.Wait(0)
				if not IsEntityAMissionEntity(Value) then
					SetEntityAsMissionEntity(Value, true, true)
				end
				DeleteObject(Value)
			end
		end
		SpawnedProps = {}

		for Key, Value in ipairs(SpawnedPickups) do
			while DoesPickupExist(Value[2]) do
				Citizen.Wait(0)
				RemovePickup(Value[2])
			end
		end
		SpawnedPickups = {}

		for Key, Value in ipairs(MapTable.Props) do
			if Key == 1 then ReferenceZ = tonumber(Value.Z) end
			if IsModelValid(tonumber(Value.ModelHash)) then
				if not HasModelLoaded(tonumber(Value.ModelHash)) then
					RequestModel(tonumber(Value.ModelHash))
					while not HasModelLoaded(tonumber(Value.ModelHash)) do
						Citizen.Wait(0)
					end
				end
				if IsRepairPickup(Value.ModelHash) or IsBoostPickup(Value.ModelHash) then
					local Pickup = CreatePickupRotate(1104334678, tonumber(Value.X), tonumber(Value.Y), tonumber(Value.Z), 0.0, 0.0, 0.0, 512, 0, 2, 1, tonumber(Value.ModelHash))
					table.insert(SpawnedPickups, {tonumber(Value.ModelHash), Pickup})
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
		if GetPlayerServerId(PlayerId()) == ID then
			MapSpawned = true
		end
	else
		GameStarted = false
		ShowNotification('~r~ERROR!~n~Only ' .. #MapTable.Vehicles .. ' Spawnpoints.~n~' .. MaximumPlayer - #MapTable.Vehicles .. ' missing!')
		ShowNotification('~r~' .. GetLabelText('FMMC_RANDFAIL') .. '~y~' .. GetLabelText('USJ_FAILSAFE'))
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if MapReceived[1] then
			SpawnMap(MapReceived[2], MapReceived[3], MapReceived[4])
			MapReceived[1] = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if MapSpawned then
			TriggerServerEvent('DD:Server:MapInformations', GetRandomVehicleClass())
			MapSpawned = false
		end
	end
end)

