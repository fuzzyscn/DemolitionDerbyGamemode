Pool = MenuPool.New()
MainMenu = UIMenu.New('Admin Menu', '~b~Various options for admins.')
Pool:Add(MainMenu)
SubMenu = Pool:AddSubMenu(MainMenu, 'Time & Weather')

function AddMenuOptionCheckbox(Menu)
    local TwoPlayerNeeded = UIMenuCheckboxItem.New('Testing Mode', AdminTestMode, 'Enables the Testing Mode - Start with one Player & No Auto-Stop.')
    Menu:AddItem(TwoPlayerNeeded)
    Menu.OnCheckboxChange = function(Sender, Item, Checked)
        if Item == TwoPlayerNeeded then
			TriggerServerEvent('DD:S:TestMode', Checked)
        end
    end
end

function AddMenuOptionList(Menu)
	local Maps = {}
	for Key, Value in pairs(AvailableMaps) do
		table.insert(Maps, Value[2])
	end
    local SelectMap = UIMenuListItem.New('Select Map', Maps, 1, 'Select a map to be used with the "Force restart" option.')
    Menu:AddItem(SelectMap)
    Menu.OnListChange = function(Sender, Item, Index)
        if Item == SelectMap then
            CurrentMap = AvailableMaps[Index]
		end
    end
end

function AddMenuOptionItem(Menu)
	local ForceRestart = UIMenuItem.New('Force restart', 'Forces the game to restart with the selected map.')
	Menu:AddItem(ForceRestart)
--	local StopCurrentGame = UIMenuItem.New('Stop current round', 'Stops the current round and spawns the players back in the apartments.')
--	Menu:AddItem(StopCurrentGame)
	Menu.OnItemSelect = function(Sender, Item, Index)
		if Item == ForceRestart then
			if GameStarted then
--				TriggerServerEvent('DD:S:GameFinished', MapReceived[2], AdminTestMode)
				while GameStarted do
					Citizen.Wait(0)
				end
			end
			TriggerServerEvent('DD:S:LoadMap', CurrentMap)
--		elseif Item == StopCurrentGame then
--			if GameStarted then
--				TriggerServerEvent('DD:S:GameFinished', MapReceived[2], AdminTestMode)
--			end
		end
	end
end

function AddMenuTimeWeatherOptions(Menu)
    local FreezeT = UIMenuCheckboxItem.New('Freeze Time', FreezeTime, 'Freezes the time to your current time.')
    Menu:AddItem(FreezeT)
    local FreezeW = UIMenuCheckboxItem.New('Freeze Weather', FreezeWeather, 'Freezes the weather to your selected one.')
    Menu:AddItem(FreezeW)
    Menu.OnCheckboxChange = function(Sender, Item, Checked)
        if Item == FreezeT then
			TriggerServerEvent('DD:S:FreezeTime', Checked, CurrentTime)
        elseif Item == FreezeW then
			TriggerServerEvent('DD:S:FreezeWeather', Checked, CurrentWeather)
        end
    end
	
    local SelectWeather = UIMenuListItem.New('Select Weather', AvailableWeatherTypes, GetWeatherIndex(), 'Set the weather for every client')
    Menu:AddItem(SelectWeather)
	local Hours = {}
	for Hour = 0, 23 do
		table.insert(Hours, Hour)
	end
    local SelectHour = UIMenuListItem.New('Select Hour', Hours, GetClockHours() + 1, 'Set the hour for every client')
    Menu:AddItem(SelectHour)
	
 	local Minutes = {}
	for Minute = 0, 59 do
		table.insert(Minutes, Minute)
	end
   local SelectMinute = UIMenuListItem.New('Select Minute', Minutes, GetClockMinutes() + 1, 'Set the minute for every client')
    Menu:AddItem(SelectMinute)
    Menu.OnListChange = function(Sender, Item, Index)
        if Item == SelectWeather then
            CurrentWeather = Item:IndexToItem(Index)
			TriggerServerEvent('DD:S:SyncTimeAndWeather', false, CurrentWeather)
		elseif Item == SelectHour then
            CurrentTime.Hour = Item:IndexToItem(Index)
			TriggerServerEvent('DD:S:SyncTimeAndWeather', CurrentTime, false)
		elseif Item == SelectMinute then
            CurrentTime.Minute = Item:IndexToItem(Index)
			TriggerServerEvent('DD:S:SyncTimeAndWeather', CurrentTime, false)
		end
    end
end

RegisterNetEvent('DD:C:SetUpAdminMenu')
AddEventHandler('DD:C:SetUpAdminMenu', function()
	CurrentMap = AvailableMaps[1]
	AddMenuOptionCheckbox(MainMenu)
	AddMenuOptionList(MainMenu)
	AddMenuOptionItem(MainMenu)
	AddMenuTimeWeatherOptions(SubMenu)
	Pool:RefreshIndex()
end)

Citizen.CreateThread(function()
	local SetVars = false
    while true do
        Citizen.Wait(0)
        Pool:ProcessMenus()
		
		if not SetVars and NetworkIsSessionStarted() then
			CurrentWeather = AvailableWeatherTypes[GetWeatherIndex()]
			CurrentTime = FrozenTime
			SetVars = true
		end
		
		CurrentTime.Hour = GetClockHours()
		CurrentTime.Minute = GetClockMinutes()

--[[		
        if (IsControlJustPressed(1, 57) or IsDisabledControlJustPressed(1, 57)) and IsAdmin then
            if MainMenu:Visible() or SubMenu:Visible() then
				MainMenu:Visible(false)
				SubMenu:Visible(false)
				ScaleformCheckValue = -1
			elseif not MainMenu:Visible() and not SubMenu:Visible() then
				MainMenu:Visible(true)
			end
        elseif (IsControlJustReleased(1, 177) or IsDisabledControlJustReleased(1, 177)) then
			ScaleformCheckValue = -1
		end
]]
    end
end)
