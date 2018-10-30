local function Countdown(State)
	if State then
		local CountdownMessages = {{GetLabelText('collision_yq6ipu7') .. '!', ''}, {'...', ''}, {GetLabelText('collision_3mddt3c'), ''}}
		if not HasScaleformMovieLoaded(CountdownScaleform) then
			CountdownScaleform = RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
			while not HasScaleformMovieLoaded(CountdownScaleform) do
				Citizen.Wait(0)
			end
		end

		if State ~= 0 then
			BeginScaleformMovieMethod(CountdownScaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
			PushScaleformMovieMethodParameterString('~r~' .. CountdownMessages[State][1])
			PushScaleformMovieMethodParameterString('~y~' .. CountdownMessages[State][2])
			EndScaleformMovieMethod()
			DrawScaleformMovieFullscreen(CountdownScaleform, 255, 255, 255, 255)
		else
			if not GameRunning then
				DoCountdown = false
				GameRunning = true
			end
		end
	end
end

--[[
local function Finished(IsLastPlayer)
	local Deleted = 0
	ScreenFadeOut(1500)
	
	if IsLastPlayer then
		RemoveMyVehicle()
	else
		local SpawnLocation = MapReceived[3].Vehicles[Player + 1]
		local Ped = PlayerPedId()

		SetEntityCoords(Ped, tonumber(SpawnLocation.X), tonumber(SpawnLocation.Y), tonumber(SpawnLocation.Z), false, false, false, false)
		
		FreezeEntityPosition(Ped, true)
	end
	
	for Ped in EnumeratePeds() do
		if not IsPedAPlayer(Ped) and Deleted > 100 then
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
		if Deleted > 100 then
			Deleted = Deleted + 1
			FreezeEntityPosition(Vehicle, false)
			SetEntityAsMissionEntity(Vehicle, false, false)
			DeleteEntity(Vehicle)
		else
			break
		end
	end

	TeleportMyBodyAway()
		
	TriggerServerEvent('DD:S:GameFinished', MapReceived[2], AdminTestMode)
end
]]

Citizen.CreateThread(function()
	local AT = {'fmmc'}
	local Players
	local PerodicalCheck = GetGameTimer()
	while true do
		Citizen.Wait(0)
		if not HasStreamedTextureDictLoaded('TIMERBARS') then
			RequestStreamedTextureDict('TIMERBARS')
			while not HasStreamedTextureDictLoaded('TIMERBARS') do
				Citizen.Wait(0)
			end
		end

		if not RequestingDone then
			local CurrentSlot = 0
			for i, CAT in ipairs(AT) do
				while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
					Citizen.Wait(0)
					CurrentSlot = CurrentSlot + 1
				end
				if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
					ClearAdditionalText(CurrentSlot, true)
					RequestAdditionalText(CAT, CurrentSlot)
					while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
						Citizen.Wait(0)
					end
				end
			end
			RequestingDone = true
		end

		if MapReceived[1] then
			ScreenFadeOut(1500)

			SpawnMap(MapReceived[2], MapReceived[3], MapReceived[4])
			MapReceived[1] = false
		end
		
		if FreezeTime then
			NetworkOverrideClockTime(FrozenTime.Hour, FrozenTime.Minute, 0)
		end
		if FreezeWeather then
			SetOverrideWeather(FrozenWeather)
			SetWeatherTypeNowPersist(FrozenWeather)
		end
		
		HideHudAndRadarThisFrame()
		BlockWeaponWheelThisFrame()
		SetRadioToStationName('OFF')
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	end
end)

Citizen.CreateThread(function()
	while not RequestingDone do
		Citizen.Wait(0)
	end

	local Players, LivingPlayer, ScaleformHandle
	while true do
		Citizen.Wait(0)
		Players = GetPlayers()
		LivingPlayer = GetLivingPlayers()
		local Ped = PlayerPedId(); Player = PlayerId()
		if not GameStarted and not GameRunning then
			if IsPlayerAbleToPlay(Player) then
				SetEntityInvincible(Ped, true)
			end
		elseif GameStarted and not GameRunning then
			while WaitingForPlayer do
				Citizen.Wait(0)
				if ScaleformCheckValue ~= 0 and not MainMenu:Visible() and not SubMenu:Visible() then
					ScaleformHandle = PreIBUse('INSTRUCTIONAL_BUTTONS', {{['Slot'] = 0, ['Control'] = 'Load', ['Text'] = GetLabelText('FM_COR_PRDY'):gsub('~1~', #ReadyPlayers, 1):gsub('~1~', #LivingPlayer)}})
					ScaleformCheckValue = 0
				end
				DrawScaleformMovieFullscreen(ScaleformHandle, 255, 255, 255, 255, 0)
			end

			DoCountdown = true
			while not GameRunning and DoCountdown do
				Citizen.Wait(0)
				if StartState then
					Countdown(StartState)
				end
			end
		elseif GameStarted and GameRunning then
			RenderPlayerList(Players)
			RenderLeaderBoard()
			
			local Vehicle = GetVehiclePedIsIn(Ped, false)
			if IsControlJustPressed(1, 56) then
				ShowLeaderboard = not ShowLeaderboard
			end
			if IsAlive then
				IsAlive = IsPlayerAbleToPlay(Player)

				if not IsPedInAnyVehicle(Ped, false) then
					SetEntityHealth(Ped, 0)
				end

				if not AFKKickEnabled then
					SetEntityInvincible(Ped, false)
					FreezeEntityPosition(Ped, false)
					FreezeEntityPosition(Vehicle, false)
					AFKKickEnabled = true
				end

				SetPedConfigFlag(Ped, 32, false)

				if #SpawnedPickups.Boost > 0 then
					if CollectedBoostPickups > 3 then
						CollectedBoostPickups = 3
					else
						local Correction = ((1.0 - round(GetSafeZoneSize(), 2)) * 100) * 0.005
							  X, Y = 0.9345 - Correction, 0.94 - Correction

						_DrawSprite('TIMERBARS', 'ALL_BLACK_BG', X, Y, 0.10, 0.0305, 0.0, 255, 255, 255, 180, 0)
						
						for Index = 1, 3 do
							if Index <= CollectedBoostPickups then
								_DrawSprite('TIMERBARS', 'BOOST', X + 0.01 + (Index * 0.01), Y, 0.013, 0.0275, 0.0, 55, 155, 255, 255, 1)
							else
								_DrawSprite('TIMERBARS', 'BOOST', X + 0.01 + (Index * 0.01), Y, 0.013, 0.0275, 0.0, 255, 255, 255, 255, 1)
							end
						end
						
						Draw(GetLabelText('vvhud_speedb'), 255, 255, 255, 255, X - 0.025, Y - 0.012, 0.3, 0.3, 3, true, 0)
						
						if CollectedBoostPickups > 0 and IsVehicleOnAllWheels(Vehicle) and IsControlJustPressed(1, 86) then
							CollectedBoostPickups = CollectedBoostPickups - 1
							SetVehicleBoostActive(Vehicle, 1, 0)
							StartScreenEffect("RaceTurbo", 0, 0)
							
							local SpeedVector = GetEntitySpeedVector(Vehicle, true)
							local Speed = GetEntitySpeed(Vehicle)
							if SpeedVector.y < 0.0 then
								SetVehicleForwardSpeed(Vehicle, 0.0 - (Speed * 2.5))
							elseif SpeedVector.y > 0.0 then
								SetVehicleForwardSpeed(Vehicle, Speed * 2.5)
							end
							
							SetVehicleBoostActive(Vehicle, 0, 0)
						end
					end
				end

				local MyCoords = GetEntityCoords(Ped, true)
				
				if ReferenceZ - MyCoords.z > 10.0 or IsEntityInWater(Vehicle) or not IsVehicleDriveable(Vehicle, true) then
					NetworkExplodeVehicle(Vehicle, true, false, 0)
				end

				if (#LivingPlayer == 1 and IsPlayerAbleToPlay(Player) and #Players > 1) and not AdminTestMode then
					if not WinAdded then
						TriggerServerEvent('DD:S:UpdateLeaderboard', true)
						WinAdded = true
					end
				end
			else
				if (IsControlJustReleased(13, 199) or IsControlJustReleased(13, 200)) and GetCurrentFrontendMenu() == -1 then
					SetFrontendActive(true)
				end
				
				if not LossAdded and not MidGameJoiner and not AdminTestMode then
					TriggerServerEvent('DD:S:Died')
					if #Players > 1 then
						TriggerServerEvent('DD:S:UpdateLeaderboard', false)
					end
					LossAdded = true
				end
				
				if AFKKickEnabled then
					AFKKickEnabled = false
				end
				
				if not NetworkIsInSpectatorMode() and #LivingPlayer > 1 then
					ScreenFadeOut(1500)
					RemoveMyVehicle()
					TeleportMyBodyAway()
					SetSpectating()
					ScreenFadeIn(1500)
				end
				if #LivingPlayer > 1 then
					SpectatingControl()
				else
					if not AdminTestMode then
						ScreenFadeOut(1500)
						RemoveMyVehicle()
						TeleportMyBodyAway()
					end
				end
			end
		end
	end
end)

