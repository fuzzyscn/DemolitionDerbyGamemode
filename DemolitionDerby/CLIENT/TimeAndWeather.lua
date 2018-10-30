function SyncTimeAndWeather()
	local WeatherTypes = {
						  [GetHashKey('BLIZZARD')] = 'BLIZZARD',
						  [GetHashKey('CLEAR')] = 'CLEAR',
						  [GetHashKey('CLEARING')] = 'CLEARING',
						  [GetHashKey('CLOUDS')] = 'CLOUDS',
						  [GetHashKey('EXTRASUNNY')] = 'EXTRASUNNY',
						  [GetHashKey('FOGGY')] = 'FOGGY',
						  [GetHashKey('LIGHTSNOW')] = 'LIGHTSNOW',
						  [GetHashKey('NEUTRAL')] = 'NEUTRAL',
						  [GetHashKey('OVERCAST')] = 'OVERCAST',
						  [GetHashKey('RAIN')] = 'RAIN',
						  [GetHashKey('SMOG')] = 'SMOG',
						  [GetHashKey('SNOW')] = 'SNOW',
						  [GetHashKey('THUNDER')] = 'THUNDER',
						  [GetHashKey('XMAS')] = 'XMAS',
						 }

	local Time = {['Hour'] = GetClockHours(), ['Minute'] = GetClockMinutes(), ['Second'] = GetClockSeconds()}
	local Weather = WeatherTypes[GetPrevWeatherTypeHashName()]
	TriggerServerEvent('DD:S:SyncTimeAndWeather', Time, Weather)
end

