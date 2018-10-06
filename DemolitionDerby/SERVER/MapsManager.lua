Maps = {}; MapCount = 0

local function GetMapsFromPath()
	print('>>> Getting Maps now!\n')
	Content = ''
	local TempFile = 'DemolitionDerbyMaps' .. GetOSSep() .. 'TempFile.txt'
	if os.getenv('HOME') then
		local Result = os.execute('ls -a1 DemolitionDerbyMaps >' .. TempFile)
	else
		local Result = os.execute('dir "DemolitionDerbyMaps" /b >' .. TempFile)
	end
	local File = io.open(TempFile, 'r')
	Content = File:read('*a')
	File:close()
	os.remove(TempFile)
	local ContentSplitted = StringSplit(Content, '\n')
	for Index, Value in ipairs(ContentSplitted) do
		if Value and Value ~= '.' and Value ~= '..' and Value ~= '' and not Value:find('TempFile.txt') then
			local XMLStart, XMLFinish = Value:lower():find('xml')
			local TXTStart, TXTFinish = Value:lower():find('txt')
			if XMLStart and XMLFinish then
				MapCount = MapCount + 1
				table.insert(Maps, {Value:sub(1, XMLFinish), GetActualMapName(Value:sub(1, XMLFinish))})
			elseif TXTStart and TXTFinish then
				MapCount = MapCount + 1
				table.insert(Maps, {Value:sub(1, TXTFinish), GetActualMapName(Value:sub(1, TXTFinish))})
			end
		end
	end
end

local function CheckForDefaultMap()
	for i = 1, 100 do
		local DefaultFile = io.open('DemolitionDerbyMaps' .. GetOSSep() .. 'Default Map ' .. i .. '.xml', 'r')
		if not DefaultFile then
			local BackupMap = LoadResourceFile(GetCurrentResourceName(), 'SERVER' .. GetOSSep() .. 'BackupMaps' .. GetOSSep() .. 'BackupMap' .. i .. '.xml')
			if BackupMap then
				DefaultFile = io.open('DemolitionDerbyMaps' .. GetOSSep() .. 'Default Map ' .. i .. '.xml', 'w+')
				DefaultFile:write(BackupMap)
				DefaultFile:flush()
				DefaultFile:close()
			end
		end
	end
	GetMapsFromPath()
end

local function CreateFolder()
	print('>>> Creating it!')
	os.execute('mkdir DemolitionDerbyMaps')
	CheckForDefaultMap()
	print('>>> Created the folder "DemolitionDerbyMaps"!\n\n')
end

local function CheckForMapsFolder()
	print('\n\n>> Demolition Derby Gamemode:')
	print('>>> Checking for the folder "DemolitionDerbyMaps"!')
	local Result = os.execute('cd DemolitionDerbyMaps')
	if not Result then
		print('>>> The folder "DemolitionDerbyMaps" does not exist!')
		CreateFolder()
	else
		print('>>> The folder "DemolitionDerbyMaps" does exist!\n\n')
		CheckForDefaultMap()
	end
end

Citizen.CreateThread(function()
	CheckForMapsFolder()
end)
