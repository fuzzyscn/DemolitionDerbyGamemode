Leaderboard = {}

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
	local Identifiers = GetPlayerIdentifiers(ID)
	for Key, Value in pairs(Identifiers) do
		if Value:lower():find(Identifier:lower()) then
			return Value:sub(Identifier:len() + 2)
		end
	end
	return nil
end

GetActualMapName = function(Map)
	local MapNameDotPosition = Map:reverse():find('%.')
	return Map:sub(1, Map:len() - MapNameDotPosition)
end

