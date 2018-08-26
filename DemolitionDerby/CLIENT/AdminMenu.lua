Pool = MenuPool.New()
MainMenu = UIMenu.New('Admin Menu', '~b~Various options for admins.')
Pool:Add(MainMenu)
SubMenu = Pool:AddSubMenu(MainMenu, 'Time & Weather')

function AddMenuOptionCheckbox(Menu)
    local TwoPlayerNeeded = UIMenuCheckboxItem.New('Testing Mode', AdminTestMode, 'Enables the Testing Mode - Start with one Player & No Auto-Stop.')
    Menu:AddItem(TwoPlayerNeeded)
    Menu.OnCheckboxChange = function(Sender, Item, Checked)
        if Item == TwoPlayerNeeded then
			TriggerServerEvent('DD:Server:TestMode', Checked)
        end
    end
end

function AddMenuOptionList(Menu)
    local SelectMap = UIMenuListItem.New('Select Map', AvailableMaps, 1, 'Select a map to be used with the "Force restart" option.')
    Menu:AddItem(SelectMap)
    Menu.OnListChange = function(Sender, Item, Index)
        if Item == SelectMap then
            CurrentMap = Item:IndexToItem(Index)
		end
    end
end

function AddMenuOptionItem(Menu)
    local ForceRestart = UIMenuItem.New('Force restart', 'Forces the game to restart with the selected map.')
    Menu:AddItem(ForceRestart)
    local StopCurrentGame = UIMenuItem.New('Stop current round', 'Stops the current round and spawns the players back in the apartments.')
    Menu:AddItem(StopCurrentGame)
    Menu.OnItemSelect = function(Sender, Item, Index)
        if Item == ForceRestart then
			if GameStarted then
				TriggerServerEvent('DD:Server:GameFinished', MapReceived[2], AdminTestMode)
			end
			TriggerServerEvent('DD:Server:LoadMap', CurrentMap)
        elseif Item == StopCurrentGame then
			if GameStarted then
				TriggerServerEvent('DD:Server:GameFinished', MapReceived[2], AdminTestMode)
			end
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
			TriggerServerEvent('DD:Server:FreezeTime', Checked, CurrentTime)
        elseif Item == FreezeW then
			TriggerServerEvent('DD:Server:FreezeWeather', Checked, CurrentWeather)
        end
    end
	
    local SelectWeather = UIMenuListItem.New('Select Weather', AvailableWeatherTypes, GetWeatherIndex(), 'Set the weather for every client')
    Menu:AddItem(SelectWeather)
    local SelectHour = UIMenuListItem.New('Select Hour', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}, GetClockHours() + 1, 'Set the hour for every client')
    Menu:AddItem(SelectHour)
    local SelectMinute = UIMenuListItem.New('Select Minute', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 ,28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59}, GetClockMinutes() + 1, 'Set the minute for every client')
    Menu:AddItem(SelectMinute)
    Menu.OnListChange = function(Sender, Item, Index)
        if Item == SelectWeather then
            CurrentWeather = Item:IndexToItem(Index)
			TriggerServerEvent('DD:Server:SyncTimeAndWeather', false, CurrentWeather)
		elseif Item == SelectHour then
            CurrentTime.Hour = Item:IndexToItem(Index)
			TriggerServerEvent('DD:Server:SyncTimeAndWeather', CurrentTime, false)
		elseif Item == SelectMinute then
            CurrentTime.Minute = Item:IndexToItem(Index)
			TriggerServerEvent('DD:Server:SyncTimeAndWeather', CurrentTime, false)
		end
    end
end

RegisterNetEvent('DD:Client:SetUpAdminMenu')
AddEventHandler('DD:Client:SetUpAdminMenu', function()
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
    end
end)
