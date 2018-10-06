Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Citizen.Wait(0)
	end
	
	local PlayerCoords = GetEntityCoords(PlayerPedId(), false)
	local AFKMaxDuration = 8.5 --[[In Minutes]]; PingTimer = GetGameTimer(); AFKTimer = GetGameTimer()
	while true do
		Citizen.Wait(0)

		local Ped = PlayerPedId()
		
		if GetGameTimer() - PingTimer >= 2500 then
			TriggerServerEvent('DD:Server:PingCheck')
			PingTimer = GetGameTimer()
		end

		if AFKKickEnabled then
			if Vdist2(GetEntityCoords(Ped, false), PlayerCoords) <= 0.5 then
				if GetGameTimer() - AFKTimer >= (AFKMaxDuration * 60000) then
					TriggerServerEvent('DD:Server:AFKKick')
				elseif GetGameTimer() - AFKTimer == (AFKMaxDuration * 30000) then
					ShowNotification(GetLabelText('HUD_ILDETIME'):gsub('~a~', '4m15s'))
				end
			else
				AFKTimer = GetGameTimer()
				PlayerCoords = GetEntityCoords(Ped, false)
			end
		else
			AFKTimer = GetGameTimer()
			PlayerCoords = GetEntityCoords(Ped, false)
		end
	end
end)

