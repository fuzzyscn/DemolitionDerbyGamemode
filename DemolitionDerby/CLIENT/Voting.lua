MapVoteMaps = {}; MapVoteMapCount = 0; PlayAgainAvailable = false; MapVoteStarted = false; MapSelectionMade = false
VehiclesClasses = {}; VehicleClassVoteStarted = false; VehicleClassSelectionMade = false;

function StartMapVote(Maps, MapCount, IsFirstRound)
	MapVoteMaps = Maps
	MapVoteMapCount = MapCount
	PlayAgainAvailable = not IsFirstRound
	MapVoteStarted = true
end

function StartVehicleClassVote(Classes)
	VehiclesClasses = Classes
	VehicleClassVoteStarted = true
end

Citizen.CreateThread(function()
	local Counter = 0; Selected = 1; Selection = 1
	while true do
		Citizen.Wait(0)

		if MapVoteStarted and MapVoteMapCount ~= 0 and not VehicleClassVoteStarted then
			local MapVoteX = 0.1; MapVoteY = 0.1; MapVoteW = 0.15; MapVoteH = 0.03;
			
			Counter = MapVoteMapCount

			_DrawRect(MapVoteX, MapVoteY, MapVoteW, MapVoteH, 0, 0, 0, 180, 0)
			Draw(GetLabelText('INPUT_MAP'), 255, 100, 100, 255, MapVoteX, MapVoteY - 0.0125, 0.1, 0.35, 2, true, 0)

			MapVoteY = MapVoteY + MapVoteH
			
			_DrawRect(MapVoteX, MapVoteY, MapVoteW, MapVoteH, 0, 0, 0, 180, 0)
			Draw(GetLabelText('collision_zkmfnp'), 255, 180, 180, 255, MapVoteX, MapVoteY - 0.0125, 0.1, 0.3, 2, true, 0)

			for Key, Value in pairs(MapVoteMaps) do
				if Selected == Key and not MapSelectionMade then
					_DrawRect(MapVoteX, MapVoteY + (Key * MapVoteH), MapVoteW, MapVoteH, 127, 127, 127, 180, 0)
				else
					_DrawRect(MapVoteX, MapVoteY + (Key * MapVoteH), MapVoteW, MapVoteH, 0, 0, 0, 180, 0)
				end
				Draw(Key .. '.	' .. Value[2], 255, 255, 255, 255, MapVoteX - (MapVoteW / 2) + (MapVoteW * 0.05), MapVoteY - 0.0125 + (Key * MapVoteH), 0.1, 0.3, 2, false, 0)
			end

			if PlayAgainAvailable then
				Counter = Counter + 1
				if Selected == Counter and not MapSelectionMade then
					_DrawRect(MapVoteX, MapVoteY + (Counter * MapVoteH), MapVoteW, MapVoteH, 127, 127, 127, 180, 0)
				else
					_DrawRect(MapVoteX, MapVoteY + (Counter * MapVoteH), MapVoteW, MapVoteH, 0, 0, 0, 180, 0)
				end
				Draw(Counter .. '.	' .. GetLabelText('collision_480crnh'), 255, 255, 255, 255, MapVoteX - (MapVoteW / 2) + (MapVoteW * 0.05), MapVoteY - 0.0125 + (Counter * MapVoteH), 0.1, 0.3, 2, false, 0)
			end

			if not MapSelectionMade then
				if IsControlJustReleased(0, 172) then -- UP
					Selected = Selected - 1

					if Selected == 0 then
						Selected = Counter
					end
				elseif IsControlJustReleased(0, 173) then -- DOWN
					Selected = Selected + 1

					if Selected > Counter then
						Selected = 1
					end
				elseif IsControlJustReleased(0, 176) then -- SELECT
					Selection = Selected
					TriggerServerEvent('DD:S:MapSelectionMade', Selected, (PlayAgainAvailable and Selected == Counter))
					MapSelectionMade = true
				end
			else
				Counter = 0; Selected = 1
				_DrawRect(MapVoteX, MapVoteY + (Selection * MapVoteH), MapVoteW, MapVoteH, 127, 255, 127, 180, 1)
			end

			local Correction = ((1.0 - round(GetSafeZoneSize(), 2)) * 100) * 0.005
				  X, Y = 0.9345 - Correction, 0.94 - Correction

			_DrawSprite('TimerBars', 'ALL_BLACK_bg', X + 0.0125, Y, 0.075, 0.0305, 0.0, 255, 255, 255, 180, 0)

			local Time = '00:' .. VoteTimer
			if VoteTimer < 10 then
				Time = '00:0' .. VoteTimer
			end

			Draw(GetLabelText('BM_RB'):gsub('~a~', Time), 255, 255, 255, 255, X - 0.01, Y - 0.012, 0.3, 0.3, 3, false, 0)
		elseif VehicleClassVoteStarted then
			local VehicleClassVoteX = 0.1; VehicleClassVoteY = 0.1; VehicleClassVoteW = 0.15; VehicleClassVoteH = 0.03; 

			_DrawRect(VehicleClassVoteX, VehicleClassVoteY, VehicleClassVoteW, VehicleClassVoteH, 0, 0, 0, 180, 0)
			Draw(GetLabelText('FM_MISS_VEH_C'), 255, 100, 100, 255, VehicleClassVoteX, VehicleClassVoteY - 0.0125, 0.1, 0.35, 2, true, 0)

			VehicleClassVoteY = VehicleClassVoteY + VehicleClassVoteH
			
			_DrawRect(VehicleClassVoteX, VehicleClassVoteY, VehicleClassVoteW, VehicleClassVoteH, 0, 0, 0, 180, 0)
			Draw(GetLabelText('collision_zkmfnp'), 255, 180, 180, 255, VehicleClassVoteX, VehicleClassVoteY - 0.0125, 0.1, 0.3, 2, true, 0)

			for Key, Value in pairs(VehiclesClasses) do
				if Selected == Key and not VehicleClassSelectionMade then
					_DrawRect(VehicleClassVoteX, VehicleClassVoteY + (Key * VehicleClassVoteH), VehicleClassVoteW, VehicleClassVoteH, 127, 127, 127, 180, 0)
				else
					_DrawRect(VehicleClassVoteX, VehicleClassVoteY + (Key * VehicleClassVoteH), VehicleClassVoteW, VehicleClassVoteH, 0, 0, 0, 180, 0)
				end
				Draw(Key .. '.	' .. Value, 255, 255, 255, 255, VehicleClassVoteX - (VehicleClassVoteW / 2) + (VehicleClassVoteW * 0.05), VehicleClassVoteY - 0.0125 + (Key * VehicleClassVoteH), 0.1, 0.3, 2, false, 0)
			end

			if not VehicleClassSelectionMade then
				Counter = #VehiclesClasses

				if IsControlJustReleased(0, 172) then -- UP
					Selected = Selected - 1

					if Selected == 0 then
						Selected = Counter
					end
				elseif IsControlJustReleased(0, 173) then -- DOWN
					Selected = Selected + 1

					if Selected > Counter then
						Selected = 1
					end
				elseif IsControlJustReleased(0, 176) then -- SELECT
					Selection = Selected
					TriggerServerEvent('DD:S:VehicleClassSelectionMade', Selected)
					VehicleClassSelectionMade = true
				end
			else
				Counter = 0; Selected = 1
				_DrawRect(VehicleClassVoteX, VehicleClassVoteY + (Selection * VehicleClassVoteH), VehicleClassVoteW, VehicleClassVoteH, 127, 255, 127, 180, 1)
			end

			local Correction = ((1.0 - round(GetSafeZoneSize(), 2)) * 100) * 0.005
				  X, Y = 0.9345 - Correction, 0.94 - Correction

			_DrawSprite('TimerBars', 'ALL_BLACK_bg', X + 0.0125, Y, 0.075, 0.0305, 0.0, 255, 255, 255, 180, 0)

			local Time = '00:' .. VoteTimer
			if VoteTimer < 10 then
				Time = '00:0' .. VoteTimer
			end

			Draw(GetLabelText('BM_RB'):gsub('~a~', Time), 255, 255, 255, 255, X - 0.01, Y - 0.012, 0.3, 0.3, 3, false, 0)
		end
	end
end)

