function RenderLeaderBoard()
	if Leaderboard and ShowLeaderboard then
		local TopTen = {}; TopTenX = 0.05; TopTenY = 0.1; TopTenW = 0.0; TopTenH = 0.35; 
		local TitleRectH = 0.04; MapNameCreatorRectH = 0.02; ScoreH = 0.03; ScoreRectH = 10 * ScoreH; 
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

		_DrawRect(TopTenX + 0.0775, TopTenY, TopTenX + 0.15, TitleRectH, 127, 127, 127, 127, 1) -- Title Rect
		Draw('Leaderboard', 255, 255, 255, 255, TopTenX + 0.0775, TopTenY - (TitleRectH / 2), 0.1, TitleRectH * 11.6, 2, true, 0) -- Title
		TopTenY = TopTenY + (TitleRectH / 2) + (MapNameCreatorRectH / 2)

		_DrawRect(TopTenX + 0.0775, TopTenY, TopTenX + 0.15, MapNameCreatorRectH, 255, 127, 127, 127, 1) -- Map Name Rect
		Draw(GetActualMapName(MapReceived[2]):sub(1, 30), 255, 255, 255, 255, TopTenX + 0.0775, TopTenY - (MapNameCreatorRectH / 2), 0.0, MapNameCreatorRectH * 11.6, 1, true, 0) -- Map Name
		TopTenY = TopTenY + MapNameCreatorRectH

		_DrawRect(TopTenX + 0.0775, TopTenY, TopTenX + 0.15, MapNameCreatorRectH, 255, 127, 127, 127, 1) -- Map Creator Rect
		Draw(GetLabelText('PM_CREATED') .. ' ' .. GetMapCreator(MapReceived[2]), 255, 255, 255, 255, TopTenX + 0.0775, TopTenY - (MapNameCreatorRectH / 2), 0.0, MapNameCreatorRectH * 11.6, 1, true, 0) -- Map Creator
		TopTenY = TopTenY + (MapNameCreatorRectH / 2) + (ScoreH / 2)

		_DrawRect(TopTenX + 0.0775, TopTenY, TopTenX + 0.15, ScoreH, 255, 255, 255, 127, 1) -- Header (Name - Won - Lost)
		Draw('Name', 255, 153, 0, 255, TopTenX - 0.007, TopTenY - (ScoreH / 2), 0.0, ScoreH * 11.6, 2, false, 0)
		Draw('Won', 0, 127, 0, 255, TopTenX + 0.10, TopTenY - (ScoreH / 2), 0.0, ScoreH * 11.6, 2, true, 0)
		Draw('Lost', 127, 0, 0, 255, TopTenX + 0.15, TopTenY - (ScoreH / 2), 0.0, ScoreH * 11.6, 2, true, 0)
		TopTenY = TopTenY + ScoreH

		_DrawRect(TopTenX + 0.0775, TopTenY + (ScoreRectH / 2) - (ScoreH / 2), TopTenX + 0.15, ScoreRectH, 0, 0, 0, 127, 0) -- Background Rect

		for Index = 1, 10 do
			local Name = TopTen[Index].Name:sub(1, 15); Won = tostring(TopTen[Index].Won); Lost = tostring(TopTen[Index].Lost)
			if Won == '-1' then Won = 'N/A' end; if Lost == '-1' then Lost = 'N/A' end
			Draw(Name, 255, 153, 0, 255, TopTenX - 0.007, TopTenY - (ScoreH / 2), 0.0, 0.35, 2, false, 0)
			Draw(Won, 0, 180, 0, 255, TopTenX + 0.10, TopTenY - (ScoreH / 2), 0.0, 0.35, 2, true, 0)
			Draw(Lost, 180, 0, 0, 255, TopTenX + 0.15, TopTenY - (ScoreH / 2), 0.0, 0.35, 2, true, 0)

			_DrawRect(TopTenX + 0.0775, TopTenY + (ScoreH / 2), TopTenX + 0.15, 0.0015, 255, 255, 255, 127, 1)

			TopTenY = TopTenY + ScoreH
		end
	end
end
		
