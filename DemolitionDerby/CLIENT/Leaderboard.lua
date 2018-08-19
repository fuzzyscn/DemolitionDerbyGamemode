Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if GameStarted and Leaderboard and ShowLeaderboard then
			local TopTen = {}; TopTenX = 0.05; TopTenY = 0.1; TopTenW = 0.0; TopTenH = 0.35; 
			for Index = 1, 10 do
				TopTen[Index] = {['Name'] = 'N/A', ['Won'] = -1, ['Lost'] = -1}

				for Key, Value in pairs(Leaderboard) do
					if not IsTableContainingValue(TopTen, Value) then
						if TopTen[Index].Won < Value.Won or (TopTen[Index].Won == Value.Won and TopTen[Index].Lost > Value.Lost) then
							TopTen[Index] = Value
						end
					end
				end
			end

			_DrawRect(TopTenX + 0.0775, TopTenY + 0.2025, TopTenX + 0.15, TopTenY + 0.36, 0, 0, 0, 127, 0)
			_DrawRect(TopTenX + 0.0775, TopTenY - 0.0075, TopTenX + 0.15, 0.04, 127, 127, 127, 127, 1)
			_DrawRect(TopTenX + 0.0775, TopTenY + 0.0225, TopTenX + 0.15, 0.02, 255, 127, 127, 127, 1)

			Draw('Leaderboard', 255, 255, 255, 255, TopTenX + 0.0775, TopTenY - 0.025, 0.1, 0.45, 2, true, 0)
			TopTenY = TopTenY + (TopTenH / 10.0)

			Draw(GetActualMapName():sub(1, 30), 255, 255, 255, 255, TopTenX + 0.0775, TopTenY - 0.022, 0.0, 0.2, 1, true, 0)

			Draw('Name', 255, 153, 0, 255, TopTenX - 0.007, TopTenY, 0.0, 0.35, 2, false, 0)
			Draw('Won', 0, 127, 0, 255, TopTenX + 0.10, TopTenY, 0.0, 0.35, 2, true, 0)
			Draw('Lost', 127, 0, 0, 255, TopTenX + 0.15, TopTenY, 0.0, 0.35, 2, true, 0)
			_DrawRect(TopTenX + 0.0775, TopTenY + 0.03, TopTenX + 0.15, 0.0025, 255, 255, 255, 127, 1)
			TopTenY = TopTenY + (TopTenH / 10.0)

			for Index = 1, 10 do
				local Name = TopTen[Index].Name:sub(1, 15); Won = tostring(TopTen[Index].Won); Lost = tostring(TopTen[Index].Lost)
				if Won == '-1' then Won = 'N/A' end; if Lost == '-1' then Lost = 'N/A' end
				Draw(Name, 255, 153, 0, 255, TopTenX - 0.007, TopTenY, 0.0, 0.35, 2, false, 0)
				Draw(Won, 0, 180, 0, 255, TopTenX + 0.10, TopTenY, 0.0, 0.35, 2, true, 0)
				Draw(Lost, 180, 0, 0, 255, TopTenX + 0.15, TopTenY, 0.0, 0.35, 2, true, 0)

				_DrawRect(TopTenX + 0.0775, TopTenY + 0.03, TopTenX + 0.15, 0.0015, 255, 255, 255, 127, 1)

				TopTenY = TopTenY + (TopTenH / 10.0)
			end
		end
	end
end)
		
