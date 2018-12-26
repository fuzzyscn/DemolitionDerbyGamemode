LogMode = false;

Leaderboard = {}; 
SpawnedPlayers = {}; ReadyPlayers = {}; DiedPlayers = {}; 
MapSelections = {}; MapVoteStarted = false; MapVoteFinished = false; MapVoted = {};
VehicleClassSelections = {}; VehicleClassVoteStarted = false; VehicleClassVoteFinished = false; VehicleClassVoted = {}
GameStarted = false; GameRunning = false; LivingPlayers = {}; DoCountdown = true;

FreezeT = false; FrozenTime = {['Hour'] = 12, ['Minute'] = 30}; FreezeW = false; FrozenWeather = 'EXTRASUNNY';

LastMap = nil; AdminTestMode = false; AdminTestModeAdmin = '';

ResetVariables = function()
	if LogMode then
		print('Function \'ResetVariables\' called')
	end
	
	SetMapName('Lobby')
	SetConvarServerInfo('Map Creator', 'Rockstar Games')
	
	SpawnedPlayers = {}; ReadyPlayers = {}; DiedPlayers = {}
	MapSelections = {}; MapVoteStarted = false; MapVoteFinished = false; MapVoted = {}
	VehicleClassSelections = {}; VehicleClassVoteStarted = false; VehicleClassVoteFinished = false; VehicleClassVoted = {}
	GameStarted = false; GameRunning = false; LivingPlayers = {}; DoCountdown = true
end

GetOSSep = function()
	if LogMode then
		print('Function \'GetOSSep\' called')
	end

	if os.getenv('HOME') then
		return '/'
	end
	return '\\\\'
end

OriginalMapsPath = 'DemolitionDerby' .. GetOSSep() .. 'OriginalMaps' .. GetOSSep()
ConvertedMapsPath = 'DemolitionDerby' .. GetOSSep() .. 'ConvertedMaps' .. GetOSSep()
LeaderboardsPath = 'DemolitionDerby' .. GetOSSep() .. 'Leaderboards' .. GetOSSep()

IsTableContainingKey = function(Table, SearchedFor)
	if LogMode then
		print('Function \'IsTableContainingKey\' called')
	end

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
	if LogMode then
		print('Function \'IsTableContainingValue\' called')
	end

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
	if LogMode then
		print('Function \'RemoveValueFromTable\' called')
	end

	for Key, Value in pairs(Table) do
		if Value == SearchedFor then
			table.remove(Table, Key)
			break
		end
	end
	return Table
end

StringSplit = function(Input, Seperator)
	if LogMode then
		print('Function \'StringSplit\' called')
	end

	Result = {}
	for match in (Input .. Seperator):gmatch('(.-)' .. Seperator) do
		table.insert(Result, match)
	end
	return Result
end

GetIdentifier = function(ID, Identifier)
	if LogMode then
		print('Function \'GetIdentifier\' called')
	end

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
	if LogMode then
		print('Function \'GetActualMapName\' called')
	end

	local MapNameDotPosition = Map:reverse():find('%.')

	local CreatorBegin = Map:lower():find(' by ')
	if CreatorBegin then
		return Map:sub(1, CreatorBegin - 1)
	end

	return Map:sub(1, Map:len() - MapNameDotPosition)
end

GetMapCreator = function(Map)
	if LogMode then
		print('Function \'GetMapCreator\' called')
	end

	local MapNameDotPosition = Map:reverse():find('%.')

	local CreatorBegin = Map:lower():find(' by ')
	if CreatorBegin then
		return Map:sub(CreatorBegin + 4, Map:len() - MapNameDotPosition)
	end

	return 'Someone unknown'
end

AdminDisconnected = function()
	AdminTestMode = false
	AdminTestModeAdmin = nil
	TriggerClientEvent('DD:C:AdminDisconnected', -1)
end

