CurrentVersion = '1.2.0'

print('Stopping "playernames" if started')
ExecuteCommand('stop playernames')

print('Stopping "spawnmanager" if started')
ExecuteCommand('stop spawnmanager')

Citizen.CreateThread(function()
	local Timer = 0; TimerCounter = 15; PerodicalCheck = GetGameTimer(); SelectedMap = {}
	MapVoteStarted = false
	MapVoteFinished = false
	VehicleClassVoteStarted = false
	VehicleClassVoteFinished = false
	while true do
		Citizen.Wait(0)
		
		if AdminTestMode then
			if (GetGameTimer() - PerodicalCheck) >= 2500 then
				if not AdminTestModeAdmin then
					TriggerClientEvent('DD:C:AdminDisconnected', -1)
				else
					for Key, Value in ipairs(GetPlayers()) do
						if GetIdentifier(Value, 'license') == AdminTestModeAdmin then
							return
						end
						
						if Key == #Clients then
							TriggerClientEvent('DD:C:AdminDisconnected', -1)
						end
					end
				end
				PerodicalCheck = GetGameTimer()
			end
		end

		if not GameStarted and not GameRunning then
			if GetNumPlayerIndices() >= 1 and not MapVoteStarted then
				if GetNumPlayerIndices() == #SpawnedPlayers then
					local Counter = 0

					if Counter == 0 then
						if MapCount > 9 then
							Counter = 9
							
							local TempTable = Maps
							local TempCount = MapCount
							
							for Index = 1, 9 do
								math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
								local RandomNumber = math.random(1, TempCount)
								table.insert(VoteMaps, TempTable[RandomNumber])
								table.remove(TempTable, RandomNumber)
								TempCount = TempCount - 1
							end
						else
							VoteMaps = Maps
							for Key, Value in pairs(VoteMaps) do
								Counter = Counter + 1
							end
						end
					end

					TriggerClientEvent('DD:C:MapVote', -1, VoteMaps, Counter, LastMap == nil)
					MapVoteStarted = true
				end
			elseif GetNumPlayerIndices() >= 1 and not MapVoteFinished then
				if Timer == 0 or GetGameTimer() - Timer > 1000 then
					TriggerClientEvent('DD:C:VoteCountdown', -1, TimerCounter)
					Timer = GetGameTimer()
					TimerCounter = TimerCounter - 1
				end
				if TimerCounter == -1 or #MapVoted == #SpawnedPlayers then
					local Selection = 0; MostVotes = 0; GotMultiple = false; Multiples = {}
					
					for Key, Value in pairs(MapSelections) do
						if #Value > MostVotes then
							MostVotes = #Value
							Multiples = {}
							GotMultiple = false
							Selection = Key
						elseif #Value == MostVotes then
							table.insert(Multiples, Key)
							GotMultiple = true
						end
					end

					if MostVotes == 0 and Selection == 0 then
						math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
						SelectedMap = VoteMaps[math.random(1, #VoteMaps)]
					else
						if GotMultiple then
							table.insert(Multiples, Selection)
							math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
							local MultiplesRandom = Multiples[math.random(1, #Multiples)]

							SelectedMap = VoteMaps[MultiplesRandom] or LastMap
						else
							SelectedMap = VoteMaps[Selection] or LastMap
						end
					end

					Timer = 0
					TimerCounter = 15
					MapVoteFinished = true
				end
			elseif GetNumPlayerIndices() >= 1 and not VehicleClassVoteStarted then
				VehicleClasses = {}
				local TempCount = 0
				for Class, Table in pairs(Vehicles) do
					TempCount = TempCount + 1
					VehicleClassSelections[TempCount] = {}
					table.insert(VehicleClasses, Class)
				end
				TriggerClientEvent('DD:C:VehicleClassVote', -1, VehicleClasses)
				VehicleClassVoteStarted = true
			elseif GetNumPlayerIndices() >= 1 and not VehicleClassVoteFinished then
				if Timer == 0 or GetGameTimer() - Timer > 1000 then
					TriggerClientEvent('DD:C:VoteCountdown', -1, TimerCounter)
					Timer = GetGameTimer()
					TimerCounter = TimerCounter - 1
				end
				if TimerCounter == -1 or #VehicleClassVoted == #SpawnedPlayers then
					local Selection = 0; MostVotes = 0; GotMultiple = false; Multiples = {}
					
					for Key, Value in pairs(VehicleClassSelections) do
						if #Value > MostVotes then
							MostVotes = #Value
							Multiples = {}
							GotMultiple = false
							Selection = Key
						elseif #Value == MostVotes then
							table.insert(Multiples, Key)
							GotMultiple = true
						end
					end

					if MostVotes == 0 and Selection == 0 then
						math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
						SelectedClass = VehicleClasses[math.random(1, #VehicleClasses)]
					else
						if GotMultiple then
							table.insert(Multiples, Selection)
							math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
							local MultiplesRandom = Multiples[math.random(1, #Multiples)]
							
							SelectedClass = VehicleClasses[MultiplesRandom]
						else
							SelectedClass = VehicleClasses[Selection]
						end
					end

					TriggerEvent('DD:S:LoadMap', SelectedMap, SelectedClass)
					VehicleClassVoteFinished = true
				end
			else
				Timer = 0
				TimerCounter = 15
				SelectedMap = {}
			end
		elseif GameStarted and not GameRunning then
			local Timer = GetGameTimer(); Waiting = true; State = 3
			while Waiting do
				Citizen.Wait(250)
				if (#ReadyPlayers == #LivingPlayers) or ((GetGameTimer() - Timer) >= 10000) then
					Waiting = false
				end
				TriggerClientEvent('DD:C:GetLivingPlayer', GetPlayers()[1])
				TriggerClientEvent('DD:C:WaitingForPlayer', -1, Waiting)
			end
			TriggerClientEvent('DD:C:WaitingForPlayer', -1, Waiting)

			Timer = GetGameTimer()
			DoCountdown = true
			while not GameRunning and DoCountdown do
				Citizen.Wait(0)
				if ((GetGameTimer() - Timer) >= (1000 * State)) then
					Timer = GetGameTimer()
					State = State - 1
					GameRunning = State == 0
				end
				TriggerClientEvent('DD:C:Countdown', -1, State)
			end
		elseif GameStarted and GameRunning then
			if #SpawnedPlayers > GetNumPlayerIndices() or (#DiedPlayers == #SpawnedPlayers and #DiedPlayers > 0 and #SpawnedPlayers > 0) or (GetNumPlayerIndices() > 1 and #SpawnedPlayers - #DiedPlayers == 1) then
				TriggerEvent('DD:S:GameFinished', LastMap[1], AdminTestMode)
			end
		end
	end
end)