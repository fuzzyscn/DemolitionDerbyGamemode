resource_type 'gametype' { name = 'Demolition Derby' }

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'Demolition Derby - A gamemode by Scotty & Flatracer'

client_script {
	'@NativeUI/NativeUI.lua',
	'CLIENT/Scaleform.lua',
	'CLIENT/Peds.lua',
	'CLIENT/Vehicles.lua',
	'CLIENT/NetEvents.lua',
	'CLIENT/GlobalVariablesAndFunctions.lua',
	'CLIENT/TimeAndWeatherSync.lua',
	'CLIENT/MapSpawn.lua',
	'CLIENT/PlayerSpawn.lua',
	'CLIENT/DevMenu.lua',
	'CLIENT/MainThread.lua',
	'CLIENT/GamerTags.lua',
	'CLIENT/AFKPingKick.lua',
	'CLIENT/UI.lua',
	'CLIENT/Stats.lua',
}

server_script {
	'SERVER/GeneralStuff.lua',
	'SERVER/GlobalFunctions.lua',
	'SERVER/Commands.lua',
	'SERVER/SlotReserving.lua',
	'SERVER/MapToLUA.lua',
	'SERVER/MapsManager.lua',
	'SERVER/ServerEvents.lua',
	'SERVER/AFKPingKick.lua',
	'SERVER/Stats.lua',
}
