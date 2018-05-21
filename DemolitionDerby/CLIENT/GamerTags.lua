Citizen.CreateThread(function()
	local PlayerTags = {}
	
	for Player = 0, MaximumPlayer - 1 do
		PlayerTags[Player] = -1
	end
			
	while true do
		Citizen.Wait(0)
		
		for Player = 0, MaximumPlayer - 1 do
			if Player ~= PlayerId() then
				if NetworkIsPlayerConnected(Player) and IsPlayerAbleToPlay(Player) then
					if not PlayerTags[Player] or PlayerTags[Player] == -1 then
						PlayerTags[Player] = CreateMpGamerTag(GetPlayerPed(Player), GetPlayerName(Player), false, false, '', false)
					end
					SetMpGamerTagVisibility(PlayerTags[Player], 0, true)
					SetMpGamerTagVisibility(PlayerTags[Player], 9, NetworkIsPlayerTalking(Player))
				else
					if PlayerTags[Player] and not PlayerTags[Player] == -1 then
						if IsMpGamerTagActive(PlayerTags[Player]) then
							RemoveMpGamerTag(PlayerTags[Player])
						end
						PlayerTags[Player] = -1
					end
				end
			end
		end
	end
end)

