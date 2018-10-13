Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local x = 0.825
		local y = 0.1
		DrawTxt('~y~Players Demolished: ' .. '0' .. '/' .. GetNumberOfPlayers(), x, y)
		y = y + 0.03
		DrawTxt('~y~Players left: ', x, y)
		y = y + 0.03
		DrawTxt('~b~Player', x, y)
		y = y + 0.03
		for Key, Player in pairs(GetPlayers()) do
            if not IsPlayerAbleToPlay(Player.id) then
                DrawTxt('~r~' .. Player.name, x, y)
            else
                DrawTxt('~g~' .. Player.name, x, y)
            end
            y = y + 0.03
        end
		DrawRect(x + 0.075, (0.1 + (y - 0.1) / 2), 0.16, 0.03 + (y - 0.1), 0, 0, 0, 50)
	end
	while true do
		Citizen.Wait(5000)
		TriggerServerEvent('DD:Server:UpdateWins')
	end
end)

