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

			SpawnMap(MapReceived[2], MapReceived[3], MapReceived[4], MapReceived[5])
			MapReceived[1] = false
		end
		
		if FreezeTime then
			NetworkOverrideClockTime(FrozenTime.Hour, FrozenTime.Minute, 0)
		end
		if FreezeWeather then
			SetOverrideWeather(FrozenWeather)
			SetWeatherTypeNowPersist(FrozenWeather)
		end
		
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(16)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudAndRadarThisFrame()
		BlockWeaponWheelThisFrame()
		SetRadioToStationName('OFF')
	end
end)

Citizen.CreateThread(function()
	while not RequestingDone do
		Citizen.Wait(0)
	end

	local Players, LivingPlayer, IBScaleformHandle
	while true do
		Citizen.Wait(0)
		Players = GetPlayers()
		LivingPlayer = GetLivingPlayers()
		local Ped = PlayerPedId(); Player = PlayerId()
		TogglePvP(false)
		if not GameStarted and not GameRunning then
			SetPedArmour(Ped, 100)
			SetEntityHealth(Ped, 200)
			ClearPedBloodDamage(Ped)
			ResetPedVisibleDamage(Ped)
			ClearPedLastWeaponDamage(Ped)
			
			if IsPlayerAbleToPlay(Player) then
				SetEntityInvincible(Ped, true)
			end
			
			if IsFirstSpawn then
				AddTextEntry('DD:FirstSpawnMessageHeader', '~r~This Server is still in development')
				AddTextEntry('DD:FirstSpawnMessageLine1', 'If you encounter any problems, please check the command "/help" out to see how to report bugs.~n~Also you can contact me in the official Demolition Derby Gamemode Discord Channel: ~y~discord.gg/CupFkQN~n~~n~')
				AddTextEntry('DD:FirstSpawnMessageLine2', '~y~How to play:~n~~s~The goal is to destroy the other players by damaging their vehicle or pushing them off the platform.~n~To begin the game just vote for a map ond vehicle class.~n~If you\'re alone on the server the game starts as a training mode.~n~')

				local Timer = GetGameTimer()
				while not (IsControlJustPressed(2, 176) or IsDisabledControlJustPressed(2, 176) or GetGameTimer() - Timer > 10000) do
					Citizen.Wait(0)
					SetWarningMessageWithHeader('DD:FirstSpawnMessageHeader', 'DD:FirstSpawnMessageLine1', 2, 'DD:FirstSpawnMessageLine2', false, 0, false, 0, false)
				end

				IsFirstSpawn = false
			end
			while ClientIsConnecting do
				Citizen.Wait(0)
				if ScaleformCheckValue ~= 1 and not MainMenu:Visible() and not SubMenu:Visible() then
					IBScaleformHandle = PreIBUse({{['Slot'] = 0, ['Control'] = 'Load', ['Text'] = GetLabelText('FM_LSC_LF_J')}})
					ScaleformCheckValue = 1
				end
				DrawScaleformMovieFullscreen(IBScaleformHandle, 255, 255, 255, 255, 0)
			end
		elseif GameStarted and not GameRunning then
			while WaitingForPlayer do
				Citizen.Wait(0)
				if ScaleformCheckValue ~= 0 and not MainMenu:Visible() and not SubMenu:Visible() then
					IBScaleformHandle = PreIBUse({{['Slot'] = 0, ['Control'] = 'Load', ['Text'] = GetLabelText('FM_COR_PRDY'):gsub('~1~', #ReadyPlayers, 1):gsub('~1~', #LivingPlayer)}})
					ScaleformCheckValue = 0
				end
				DrawScaleformMovieFullscreen(IBScaleformHandle, 255, 255, 255, 255, 0)
			end

			DoCountdown = true
			while not GameRunning and DoCountdown do
				Citizen.Wait(0)
				if StartState then
					if not HasScaleformMovieLoaded(CountdownScaleform) then
						CountdownScaleform = RequestScaleformMovie('COUNTDOWN')
						while not HasScaleformMovieLoaded(CountdownScaleform) do
							Citizen.Wait(0)
						end
					end
					local R, G, B, A

					BeginScaleformMovieMethod(CountdownScaleform, 'SET_MESSAGE')

					if StartState ~= 0 then
						R, G, B, A = 240, 200, 80, 255
						BeginTextCommandScaleformString('NUMBER')
						AddTextComponentInteger(StartState)
					else
						R, G, B, A = 114, 204, 114, 255
						BeginTextCommandScaleformString('CNTDWN_GO')
					end
					EndTextCommandScaleformString()
					PushScaleformMovieMethodParameterInt(R)
					PushScaleformMovieMethodParameterInt(G)
					PushScaleformMovieMethodParameterInt(B)
					PushScaleformMovieMethodParameterInt(A)
					PushScaleformMovieMethodParameterBool(true)

					EndScaleformMovieMethod()

					DrawScaleformMovieFullscreen(CountdownScaleform, 255, 255, 255, 100, 0)
				end
			end
		elseif GameStarted and GameRunning then
			TogglePvP(true)
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
				
				if HasEntityCollidedWithAnything(Vehicle) and HasEntityCollidedWithExplosiveProps(Vehicle) then
					AddExplosion(MyCoords.x, MyCoords.y, MyCoords.z, 16, 50.0, true, false, 1.0, false)
				end

				if ReferenceZ - MyCoords.z > 10.0 or IsEntityInWater(Vehicle) or not IsVehicleDriveable(Vehicle, true) or GetEntityHealth(Vehicle) <= CriticalVehicleDamage or GetVehicleEngineHealth(Vehicle) <= 300 or GetVehiclePetrolTankHealth(Vehicle) <= 600 then
					NetworkExplodeVehicle(Vehicle, true, false, 0)
					SetEntityHealth(Ped, 0)
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
				elseif NetworkIsInSpectatorMode and #LivingPlayer > 1 then
					SpectatingControl()
				end
			end
		end
	end
end)

