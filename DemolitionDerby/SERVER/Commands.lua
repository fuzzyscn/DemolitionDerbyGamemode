local HelpMessage = [[
Available Commands:
	--> Help - Shows this help message.
	--> Disconnect - Lets you disconnect, when the pausemenu is inactive.
	--> Bugreport - Report a bug you experienced.
]]

RegisterCommand('Bugreport', function(Source, Arguments, RawCommand)
	local date = os.date('*t')
	for Key, Value in pairs(date) do
		if type(Value) ~= 'boolean' and Value < 10 then
			date[Key] = '0' .. tostring(date[Key])
		end
	end

	local Content = ''
	local LatestBugReport = LoadResourceFile(GetCurrentResourceName(), 'BugReports' .. GetOSSep() .. 'BugReport_v' .. CurrentVersion .. '_d' .. date.day .. '.' .. date.month .. '.' .. date.year .. '.txt')
	if LatestBugReport then
		Content = LatestBugReport
	end

	local Report = table.concat(Arguments, ' ')
	local Identifiers = GetPlayerIdentifiers(Source)
	local IdentifiersString = table.concat(Identifiers, ' / '):gsub('steam:', 'Steam: '):gsub('license:', 'License: '):gsub('ip:', 'IP: ')

	Content = Content .. '	' .. GetPlayerName(Source) .. ' (' .. IdentifiersString .. ')\n			>> ' .. Report .. '\n'
	
	SaveResourceFile(GetCurrentResourceName(), 'BugReports' .. GetOSSep() .. 'BugReport_v' .. CurrentVersion .. '_' .. date.day .. '.' .. date.month .. '.' .. date.year .. '.txt', Content, -1)

	print(GetPlayerName(Source) .. ' reported a bug!\n>> ' .. Report)
end, false)

RegisterCommand('Disconnect', function(Source, Arguments, RawCommand)
	DropPlayer(Source, 'Disconnected.')
end, false)

RegisterCommand('Help', function(Source, Arguments, RawCommand)
	TriggerClientEvent('chatMessage', Source, '', {0, 153, 255}, HelpMessage)
	TriggerClientEvent('DD:C:ToConsole', Source, HelpMessage)
end, false)

