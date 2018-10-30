local MaxPing = 300; MaxPingPoints = 10
PingPoints = {}

RegisterServerEvent('DD:S:AFKKick')
AddEventHandler('DD:S:AFKKick', function()
	DropPlayer(source, 'AFK for too long!')
end)

RegisterServerEvent('DD:S:PingCheck')
AddEventHandler('DD:S:PingCheck', function()
	if not PingPoints[source] then PingPoints[source] = 0 end
	local CurrentPing = GetPlayerPing(source)
	if CurrentPing > MaxPing then
		PingPoints[source] = PingPoints[source] + 1
	end
	if PingPoints[source] > MaxPingPoints then
		PingPoints[source] = 0
		DropPlayer(source, 'Ping too high. (' .. CurrentPing .. '/' .. MaxPing .. ')')
	end
end)

