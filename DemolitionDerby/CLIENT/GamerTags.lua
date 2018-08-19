Citizen.CreateThread(function()
	local PlayerTags = {}

	while true do
		Citizen.Wait(0)

		for Player = 0, MaximumPlayer - 1 do
			if Player ~= PlayerId() then
				local IsConnected = NetworkIsPlayerConnected(Player)
				local IsAbleToPlay = IsPlayerAbleToPlay(Player)
				local IsTagActive = IsMpGamerTagActive(PlayerTags[Player])

				if IsConnected and (not PlayerTags[Player] or (PlayerTags[Player] and not IsTagActive)) then
					PlayerTags[Player] = CreateMpGamerTag(GetPlayerPed(Player), GetPlayerName(Player), false, false, '', false)
				elseif IsConnected and PlayerTags[Player] and IsTagActive and IsAbleToPlay then
					SetMpGamerTagVisibility(PlayerTags[Player], 0, true)
					SetMpGamerTagVisibility(PlayerTags[Player], 4, NetworkIsPlayerTalking(Player))
				elseif IsConnected and PlayerTags[Player] and IsTagActive and not IsAbleToPlay then
					SetMpGamerTagVisibility(PlayerTags[Player], 0, false)
					SetMpGamerTagVisibility(PlayerTags[Player], 4, false)
				elseif PlayerTags[Player] then
					if IsTagActive then
						RemoveMpGamerTag(PlayerTags[Player])
					end
					PlayerTags[Player] = nil
				end
			end
		end
	end
end)

