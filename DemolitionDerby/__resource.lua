resource_type 'gametype' { name = 'Demolition Derby' }

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'Demolition Derby - A gamemode by Scotty & Flatracer'

dependencies {
    'NativeUI',
}

client_script {
	'@NativeUI/NativeUI.lua',
	'Configuration.lua',
	'Peds.lua',
	'Vehicles.lua',
	'CLIENT/NetEvents.lua',
	'CLIENT/Global.lua',
	'CLIENT/AdminMenu.lua',
	'CLIENT/TimeAndWeather.lua',
	'CLIENT/MapSpawn.lua',
	'CLIENT/PlayerSpawn.lua',
	'CLIENT/MainThread.lua',
	'CLIENT/GamerTags.lua',
	'CLIENT/AFKandPingKick.lua',
	'CLIENT/PlayerList.lua',
	'CLIENT/Leaderboard.lua',
	'CLIENT/Voting.lua',
}

server_script {
	'Configuration.lua',
	'Vehicles.lua',
	'SERVER/General.lua',
	'SERVER/Global.lua',
	'SERVER/Commands.lua',
	'SERVER/SlotReserving.lua',
	'SERVER/MapToLua.lua',
	'SERVER/MapsManager.lua',
	'SERVER/ServerEvents.lua',
	'SERVER/AFKandPingKick.lua',
	'SERVER/Leaderboard.lua',
}

