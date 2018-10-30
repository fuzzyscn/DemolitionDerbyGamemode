Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Citizen.Wait(0)
	end
	
	local AFKMaxDuration = 510000; PingTimer = GetGameTimer(); AFKTimer = GetGameTimer()
	local InputDetected = false; Halfway = false
	while true do
		Citizen.Wait(200)

		local Ped = PlayerPedId()
		
		if GetGameTimer() - PingTimer >= 2500 then
			TriggerServerEvent('DD:S:PingCheck')
			PingTimer = GetGameTimer()
		end

		if AFKKickEnabled then
			for Control = 0, 345 do
				if Control ~= 0   and Control ~= 1   and Control ~= 2   and Control ~= 3   and	-- V			Mouse LR	Mouse UD	Mouse UP
				   Control ~= 4   and Control ~= 5   and Control ~= 6   and Control ~= 12  and	-- Mouse D		Mouse L		Mouse R		Mouse UD
				   Control ~= 13  and Control ~= 26  and Control ~= 66  and Control ~= 67  and	-- Mouse LR		C			Mouse LR	Mouse UD
				   Control ~= 79  and Control ~= 95  and Control ~= 98  and Control ~= 220 and	-- C			Mouse UD	Mouse LR	Mouse LR
				   Control ~= 221 and Control ~= 236 and Control ~= 239 and Control ~= 240 and	-- Mouse UD		V			Mouse UD	Mouse LR
				   Control ~= 253 and Control ~= 270 and Control ~= 271 and Control ~= 272 and	-- C			Mouse L		Mouse R		Mouse U
				   Control ~= 273 and Control ~= 282 and Control ~= 283 and Control ~= 284 and	-- Mouse D		Mouse L		Mouse R		Mouse U
				   Control ~= 285 and Control ~= 286 and Control ~= 287 and Control ~= 290 and	-- Mouse D		Mouse L		Mouse R		Mouse LR
				   Control ~= 291 and Control ~= 292 and Control ~= 293 and Control ~= 294 and	-- Mouse UD		Mouse U		Mouse D		Mouse L
				   Control ~= 295 and Control ~= 319 and Control ~= 320 and Control ~= 324 and 	-- Mouse R		C			V			C
				   Control ~= 325 and Control ~= 332 and Control ~= 333 then 					-- V			Mouse UD	Mouse LR 
					if IsControlPressed(0, Control) or IsDisabledControlPressed(0, Control) or IsControlJustPressed(0, Control) or IsDisabledControlJustPressed(0, Control) then
						InputDetected = true
						break
					end
				end
			end
			if not InputDetected then
				if GetGameTimer() - AFKTimer >= (AFKMaxDuration) then
					ScreenFadeOut(1500)
					RemoveMyVehicle()
					TeleportMyBodyAway()
					TriggerServerEvent('DD:S:AFKKick')
				elseif not Halfway and GetGameTimer() - AFKTimer > (AFKMaxDuration / 2) then
					Halfway = true
					ShowNotification(GetLabelText('HUD_ILDETIME'):gsub('~a~', tostring(math.floor(AFKMaxDuration / 2)) .. 'm' .. tostring(((AFKMaxDuration / 2) - math.floor(AFKMaxDuration / 2)) * 60):gsub('.0', '') .. 's'))
				end
			else
				Halfway = false
				InputDetected = false
				AFKTimer = GetGameTimer()
			end
		else
			InputDetected = false
			AFKTimer = GetGameTimer()
		end
	end
end)

