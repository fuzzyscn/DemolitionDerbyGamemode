resource_type 'gametype' { name = 'Demolition Derby' }

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'Demolition Derby - A gamemode by Scotty & Flatracer'

dependencies {
    'NativeUI',
}

client_script {
	'@NativeUI/NativeUI.lua',
	'Configuration.lua',
	'CLIENT/Scaleform.lua',
	'CLIENT/Peds.lua',
	'CLIENT/Vehicles.lua',
	'CLIENT/NetEvents.lua',
	'CLIENT/Global.lua',
	'CLIENT/AdminMenu.lua',
	'CLIENT/TimeAndWeather.lua',
	'CLIENT/MapSpawn.lua',
	'CLIENT/PlayerSpawn.lua',
	'CLIENT/MainThread.lua',
	'CLIENT/GamerTags.lua',
	'CLIENT/AFKandPingKick.lua',
	'CLIENT/UI.lua',
	'CLIENT/Stats.lua',
	'CLIENT/Leaderboard.lua',
}

server_script {
	'Configuration.lua',
	'SERVER/General.lua',
	'SERVER/Global.lua',
	'SERVER/Commands.lua',
	'SERVER/SlotReserving.lua',
	'SERVER/MapToLUA.lua',
	'SERVER/MapsManager.lua',
	'SERVER/ServerEvents.lua',
	'SERVER/AFKandPingKick.lua',
	'SERVER/Leaderboard.lua',
}

--[[

		Big thanks to throwarray for writing the piece of code to check for game events

]]