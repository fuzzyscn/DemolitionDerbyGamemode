CurrentVersion = '1.2.0'

print('Stopping "playernames" if started')
ExecuteCommand('stop playernames')

print('Stopping "spawnmanager" if started')
ExecuteCommand('stop spawnmanager')

Citizen.CreateThread(function()
	local Timer = 0; TimerCounter = 15; PerodicalCheck = GetGameTimer(); VoteMaps = {}; VehicleClasses = {};
		  SelectedMap = {}; SelectedClass = {}; WaitingForConnectingPlayer = false
	MapVoteStarted = false
	MapVoteFinished = false
	VehicleClassVoteStarted = false
	VehicleClassVoteFinished = false
	
	while true do
		Citizen.Wait(0)
		local PlayerIndices = GetNumPlayerIndices()
		
		if PlayerIndices == 0 then
			ResetVariables()
			if AdminTestMode then
				AdminTestMode = false
				AdminTestModeAdmin = nil
			end
		elseif PlayerIndices > 0 then
			if AdminTestMode then
				if (GetGameTimer() - PerodicalCheck) >= 2500 then
					if not AdminTestModeAdmin then
						AdminDisconnected()
					else
						for Key, Value in ipairs(GetPlayers()) do
							if GetIdentifier(Value, 'license') == AdminTestModeAdmin then
								return
							end
							
							if Key == #Clients then
								AdminDisconnected()
							end
						end
					end
					PerodicalCheck = GetGameTimer()
				end
			elseif not AdminTestMode then
				if not GameStarted and not GameRunning then
					if not MapVoteStarted then
						if Timer == 0 then
							Timer = GetGameTimer()
						end

						for Index = 1, 10 do
							MapSelections[Index] = {}
						end

						if (PlayerIndices == #SpawnedPlayers) then
							VoteMaps = {}
							Timer = 0
							local Counter = 0

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

							TriggerClientEvent('DD:C:MapVote', -1, VoteMaps, Counter, LastMap == nil)
							WaitingForConnectingPlayer = false
							MapVoteStarted = true
						else
							TriggerClientEvent('DD:C:ClientIsJoiningOrSpawning', -1)
							WaitingForConnectingPlayer = true
						end
					elseif not MapVoteFinished then
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
					elseif not VehicleClassVoteStarted then
						VehicleClasses = {}
						local TempCount = 0
						for Class, Table in pairs(Vehicles) do
							TempCount = TempCount + 1
							VehicleClassSelections[TempCount] = {}
							table.insert(VehicleClasses, Class)
						end
						TriggerClientEvent('DD:C:VehicleClassVote', -1, VehicleClasses)
						VehicleClassVoteStarted = true
					elseif not VehicleClassVoteFinished then
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
						SelectedClass = {}
					end
				elseif GameStarted and not GameRunning then
					MapSelections = {}; MapVoteStarted = false; MapVoteFinished = false; MapVoted = {};
					VehicleClassSelections = {}; VehicleClassVoteStarted = false; VehicleClassVoteFinished = false; VehicleClassVoted = {}

					local Timer = GetGameTimer(); Waiting = true; State = 3
					while Waiting do
						Citizen.Wait(250)
						if (#ReadyPlayers == #LivingPlayers) or ((GetGameTimer() - Timer) >= 10000) or PlayerIndices == 0 then
							Waiting = false
						end
						local Players = GetPlayers()
						if #Players > 0 then
							TriggerClientEvent('DD:C:GetLivingPlayer', Players[1])
						end
						TriggerClientEvent('DD:C:WaitingForPlayer', -1, Waiting)
					end
					TriggerClientEvent('DD:C:WaitingForPlayer', -1, Waiting)

					Timer = GetGameTimer()
					DoCountdown = true
					TriggerClientEvent('DD:C:Countdown', -1, State, false)
					while not GameRunning and DoCountdown do
						Citizen.Wait(0)
						if PlayerIndices == 0 then
							ResetVariables()
						end
						if (State > 1 and ((GetGameTimer() - Timer) >= 1000)) then
							Timer = GetGameTimer()
							State = State - 1
							TriggerClientEvent('DD:C:Countdown', -1, State, false)
						elseif (State == 1 and ((GetGameTimer() - Timer) >= 400)) then
							Timer = GetGameTimer()
							State = State - 1
							TriggerClientEvent('DD:C:Countdown', -1, State, true)
						elseif (State == 0 and ((GetGameTimer() - Timer) >= 600)) then
							Timer = GetGameTimer()
							TriggerClientEvent('DD:C:Countdown', -1, State, false)
							State = State - 1
						end
						
						GameRunning = State == -1 and ((GetGameTimer() - Timer) >= 750)
						if GameRunning then
							TriggerClientEvent('DD:C:GameRunning', -1)
						end
					end
				elseif GameStarted and GameRunning then
					if (PlayerIndices > 1 and #SpawnedPlayers == 1) or (#DiedPlayers == #SpawnedPlayers) or (PlayerIndices > 1 and #SpawnedPlayers - #DiedPlayers == 1) then
						TriggerEvent('DD:S:GameFinished', #SpawnedPlayers)
					end
				end
			end
		end
	end
end)