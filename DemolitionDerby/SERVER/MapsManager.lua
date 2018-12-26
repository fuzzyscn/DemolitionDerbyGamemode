Maps = {}; MapCount = 0
local function CreateLeaderboardIfNeeded(Map)
	print('>>> Checking if a Leaderboard for "' .. Map .. '" exists.')
	local MapConverted = io.open(LeaderboardsPath .. Map .. '.json', 'r')
	if not MapConverted then
		print('>>>> The leaderboard for "' .. Map .. '" is not existing, creating it now!\n')
		local MapLeaderboardFile = io.open(LeaderboardsPath .. Map .. '.json', 'w+')
		MapLeaderboardFile:write(json.encode({}))
		MapLeaderboardFile:flush()
		MapLeaderboardFile:close()
	else
		print('>>>> The leaderboard for "' .. Map .. '" is existing!\n')
		MapConverted:close()
	end
end

local function ConvertMapIfNeeded(Map)
	print('>>> Checking if "' .. Map .. '" is already converted.')
	local MapConverted = io.open(ConvertedMapsPath .. Map .. '.json', 'r')
	if not MapConverted then
		print('>>>> The map "' .. Map .. '" is not converted yet, converting it now!')
		local MapFile = io.open(OriginalMapsPath .. Map, 'r')
		local MapFileContent = MapFile:read('*a')
		local MapFileContentToLua = MapToLua(MapFileContent)
		MapFile:close()
		local MapFileContentToLuaToJSON = json.encode(MapFileContentToLua)
		local MapFileContentToLuaToJSONFile = io.open(ConvertedMapsPath .. Map .. '.json', 'w+')
		MapFileContentToLuaToJSONFile:write(MapFileContentToLuaToJSON)
		MapFileContentToLuaToJSONFile:flush()
		MapFileContentToLuaToJSONFile:close()
	else
		print('>>>> The map "' .. Map .. '" is already converted!')
		MapConverted:close()
	end
	CreateLeaderboardIfNeeded(Map)
end

local function GetMapsFromPath()
	print('>>> Getting Maps now!\n\n')
	if os.getenv('HOME') then
		os.execute('ls -a1 ' .. OriginalMapsPath .. ' > TempFile.txt')
	else
		os.execute('dir "' .. OriginalMapsPath .. '" /b > TempFile.txt')
	end
	local TempFile = io.open('TempFile.txt', 'r')
	TempFileContent = TempFile:read('*a')
	TempFile:close()
	os.remove('TempFile.txt')
	local ContentSplitted = StringSplit(TempFileContent, '\n')
	for Index, Value in ipairs(ContentSplitted) do
		if Value and Value ~= '.' and Value ~= '..' and Value ~= '' then
			local XMLStart, XMLFinish = Value:lower():find('xml')
			local TXTStart, TXTFinish = Value:lower():find('txt')
			if XMLStart and XMLFinish then
				MapCount = MapCount + 1
				local Map = Value:sub(1, XMLFinish)
				table.insert(Maps, {Map, GetActualMapName(Map), GetMapCreator(Map)})
				ConvertMapIfNeeded(Map)
			elseif TXTStart and TXTFinish then
				MapCount = MapCount + 1
				local Map = Value:sub(1, TXTFinish)
				table.insert(Maps, {Map, GetActualMapName(Map), GetMapCreator(Map)})
				ConvertMapIfNeeded(Map)
			end
		end
	end
	print('>>> All Maps checked!\n\n')
end

local function CheckForDefaultMap()
	for i = 1, 100 do
		local DefaultFile = io.open(OriginalMapsPath .. 'Default Map ' .. i .. '.xml', 'r')
		if not DefaultFile then
			local BackupMap = LoadResourceFile(GetCurrentResourceName(), 'SERVER' .. GetOSSep() .. 'BackupMaps' .. GetOSSep() .. 'BackupMap' .. i .. '.xml')
			if BackupMap then
				local DefaultFile = io.open(OriginalMapsPath .. 'Default Map ' .. i .. '.xml', 'w+')
				DefaultFile:write(BackupMap)
				DefaultFile:flush()
				DefaultFile:close()
			end
		end
	end
	GetMapsFromPath()
end

local function CreateFolder()
	print('>>> Creating the missing folders!')
	if not os.execute('cd ' .. OriginalMapsPath) then
		os.execute('mkdir ' .. OriginalMapsPath)
	end
	if not os.execute('cd ' .. ConvertedMapsPath) then
		os.execute('mkdir ' .. ConvertedMapsPath)
	end
	if not os.execute('cd ' .. LeaderboardsPath) then
		os.execute('mkdir ' .. LeaderboardsPath)
	end
	print('>>> Created the missing folders!\n\n')
	CheckForDefaultMap()
end

Citizen.CreateThread(function()
	print('\n\n>> Demolition Derby Gamemode:')
	print('>>> Checking for the required folders!')
	if os.execute('cd ' .. OriginalMapsPath) and os.execute('cd ' .. ConvertedMapsPath) and os.execute('cd ' .. LeaderboardsPath) then
		print('>>> All required folders exist!\n\n')
		CheckForDefaultMap()
	else
		print('>>> Not all required folders exist!')
		CreateFolder()
	end
end)
