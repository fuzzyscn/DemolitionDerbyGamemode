Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if FreezeTime then
			print(FrozenTime.Hour .. ':' .. FrozenTime.Minute)
			NetworkOverrideClockTime(FrozenTime.Hour, FrozenTime.Minute, 0)
		end
		if FreezeWeather then
			SetOverrideWeather(FrozenWeather)
			SetWeatherTypeNowPersist(FrozenWeather)
		end
			print(tostring(GetPrevWeatherTypeHashName() == GetHashKey(FrozenWeather)))
	end
end)

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
	TriggerServerEvent('DD:Server:SyncTimeAndWeather', Time, Weather)
end

