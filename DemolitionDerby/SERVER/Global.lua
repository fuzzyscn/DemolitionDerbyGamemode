Leaderboard = {}; SpawnedPlayers = {}; ReadyPlayers = {}; DiedPlayers = {}; 
VoteMaps = {}; MapSelections = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}; MapVoteStarted = false; MapVoteFinished = false; MapVoted = {};
VehicleClasses = {}; VehicleClassSelections = {}; VehicleClassVoteStarted = false; VehicleClassVoteFinished = false; VehicleClassVoted = {}
LastMap = nil; GameStarted = false; GameRunning = false; LivingPlayers = {}; DoCountdown = true; AdminTestMode = false; AdminTestModeAdmin = '';

ResetVariables = function()
	Leaderboard = {}; SpawnedPlayers = {}; ReadyPlayers = {}; DiedPlayers = {}; 
	VoteMaps = {}; MapSelections = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}; MapVoteStarted = false; MapVoteFinished = false; MapVoted = {};
	VehicleClasses = {}; VehicleClassSelections = {}; VehicleClassVoteStarted = false; VehicleClassVoteFinished = false; VehicleClassVoted = {}
	GameStarted = false; GameRunning = false; LivingPlayers = {}; DoCountdown = true;
end

IsTableContainingKey = function(Table, SearchedFor)
	if type(Table) == 'table' then
		for Key, Value in pairs(Table) do
			if Key == SearchedFor then
				return true
			end
		end
	end
    return false
end

IsTableContainingValue = function(Table, SearchedFor, ValueInSubTable)
	if type(Table) == 'table' then
		for Key, Value in pairs(Table) do
			if not ValueInSubTable and Value == SearchedFor then
				return true
			elseif ValueInSubTable then
				for SubKey, SubValue in pairs(Value) do
					if SubValue == SearchedFor then
						return true
					end
				end
			end
		end
	end
    return false
end

RemoveValueFromTable = function(Table, SearchedFor)
	for Key, Value in pairs(Table) do
		if Value == SearchedFor then
			table.remove(Table, Key)
			break
		end
	end
	return Table
end

StringSplit = function(Input, Seperator)
	Result = {}
	for match in (Input .. Seperator):gmatch('(.-)' .. Seperator) do
		table.insert(Result, match)
	end
	return Result
end

GetOSSep = function()
	if os.getenv('HOME') then
		return '/'
	end
	return '\\\\'
end

GetIdentifier = function(ID, Identifier)
	Identifier = Identifier:lower()
	if Identifier == 'license' or Identifier == 'steam' or Identifier == 'ip' or Identifier == 'xbl' or Identifier == 'live' then 
		local IdentifierCount = GetNumPlayerIdentifiers(ID)
		for Index = 0, IdentifierCount - 1 do
			local CurrentIdentifier = GetPlayerIdentifier(ID, Index)
			if CurrentIdentifier:lower():find(Identifier) then
				return CurrentIdentifier:sub(Identifier:len() + 2)
			end
		end
	end
	return nil
end

GetActualMapName = function(Map)
	local MapNameDotPosition = Map:reverse():find('%.')
	return Map:sub(1, Map:len() - MapNameDotPosition)
end

