Citizen.CreateThread(function()
	local Ped = PlayerPedId()
	local PlayerCoords = GetEntityCoords(Ped, false)
	local AFKMaxDuration = 8.5 --[[In Minutes]]; PingTimer = GetGameTimer(); AFKTimer = GetGameTimer()
	while true do
		Citizen.Wait(0)

		if GetGameTimer() - PingTimer >= 2500 then
			TriggerServerEvent('DD:Server:PingCheck')
			PingTimer = GetGameTimer()
		end

		if IsPlayerAbleToPlay(PlayerId()) and AFKKickEnabled then
			if GetEntityCoords(Ped, false) == PlayerCoords then
				if GetGameTimer() - AFKTimer >= (AFKMaxDuration * 60000) then
					TriggerServerEvent('DD:Server:AFKKick')
				elseif GetGameTimer() - AFKTimer == (AFKMaxDuration * 30000) then
					ShowNotification(GetLabelText('HUD_ILDETIME'):gsub('~a~', '4m15s'))
				end				
			else
				AFKTimer = GetGameTimer()
				PlayerCoords = GetEntityCoords(Ped, false)
			end
		end
	end
end)
      
    
