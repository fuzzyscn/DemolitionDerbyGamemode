function RenderPlayerList(Players)
	local x = 0.825
	local y = 0.1
	DrawTxt('~y~Players Demolished: ' .. '0' .. '/' .. #Players, x, y)
	y = y + 0.03
	DrawTxt('~y~Players left: ', x, y)
	y = y + 0.03
	DrawTxt('~b~Player', x, y)
	y = y + 0.03
	for Key, Player in pairs(Players) do
		if not IsPlayerAbleToPlay(Player.id) then
			DrawTxt('~r~' .. Player.name, x, y)
		else
			DrawTxt('~g~' .. Player.name, x, y)
		end
		y = y + 0.03
	end
	DrawRect(x + 0.075, (0.1 + (y - 0.1) / 2), 0.16, 0.03 + (y - 0.1), 0, 0, 0, 50)
end

