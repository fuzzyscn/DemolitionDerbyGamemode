RegisterCommand("bugreport", function(Source, Arguments, RawCommand)
	local date = os.date('*t')
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

	local Content = ''
	local LatestBugReport = LoadResourceFile(GetCurrentResourceName(), 'BugReports' .. GetOSSep() .. 'BugReport_v' .. CurrentVersion .. '_d' .. date.day .. '.' .. date.month .. '.' .. date.year .. '.txt')
	if LatestBugReport then
		Content = LatestBugReport
	end
	
	local Report = ''
	for Key, Value in pairs(Arguments) do
		local Seperator = ' '
		if Key == #Arguments then
			Seperator = ''
		end
		Report = Report .. Value .. Seperator
	end
	local Identifiers = GetPlayerIdentifiers(Source)
	local IdentifiersString = ''
	for Key, Value in ipairs(Identifiers) do
		local Seperator = ' / '
		if Key == #Identifiers then
			Seperator = ''
		end
		IdentifiersString = IdentifiersString .. Value:gsub('steam:', 'Steam: '):gsub('license:', 'License: '):gsub('ip:', 'IP: ') .. Seperator
	end
	
	Content = Content .. '	' .. GetPlayerName(Source) .. ' (' .. IdentifiersString .. ')\n			>> ' .. Report .. '\n'
	
	SaveResourceFile(GetCurrentResourceName(), 'BugReports' .. GetOSSep() .. 'BugReport_v' .. CurrentVersion .. '_d' .. date.day .. '.' .. date.month .. '.' .. date.year .. '.txt', Content, -1)

	print(GetPlayerName(Source) .. ' reported a bug!\n>> ' .. Report)
end, false)

RegisterCommand("disconnect", function(Source, Arguments, RawCommand)
	DropPlayer(Source, 'Disconnected.')
end, false)

RegisterCommand("help", function(Source, Arguments, RawCommand)
	TriggerClientEvent('chatMessage', Source, '', {0, 153, 255}, '\nThe host has to start the game.\nThe current host is ' .. GetPlayerName(GetHostId()) .. '\nAvailable Commands:\n--> Disconnect - Lets you disconnect, when the pausemenu is inactive.\n--> Bugreport - Report a bug you experienced.\n')
	TriggerClientEvent('DD:Client:ToConsole', Source, '\nThe host has to start the game.\nThe current host is ' .. GetPlayerName(GetHostId()) .. '\nAvailable Commands:\n--> Disconnect - Lets you disconnect, when the pausemenu is inactive.\n--> Bugreport - Report a bug you experienced.\n')
end, false)

