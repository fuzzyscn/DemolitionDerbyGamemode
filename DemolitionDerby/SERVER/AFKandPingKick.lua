PingPoints = {}

RegisterServerEvent('DD:S:AFKKick')
AddEventHandler('DD:S:AFKKick', function()
	DropPlayer(source, 'AFK for too long!')
end)

RegisterServerEvent('DD:S:PingCheck')
AddEventHandler('DD:S:PingCheck', function()
	local Source = source
	if not PingPoints[Source] then PingPoints[Source] = 0 end
	local CurrentPing = GetPlayerPing(Source)
	if CurrentPing > MaxPing then
		PingPoints[Source] = PingPoints[Source] + 1
	end
	if PingPoints[Source] > MaxPingPoints then
		PingPoints[Source] = 0
		DropPlayer(Source, 'Ping too high. (' .. CurrentPing .. '/' .. MaxPing .. ')')
	end
end)

