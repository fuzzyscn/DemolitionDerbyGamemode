IsDev = false; AvailableMaps = {}; CurrentMap = ''
Pool = MenuPool.New()
MainMenu = UIMenu.New('Dev Menu', '~b~Various options for development/testing.')
Pool:Add(MainMenu)

function AddMenuOptionCheckbox(Menu)
    local TwoPlayerNeeded = UIMenuCheckboxItem.New('Dev-Testing Mode', DevTestMode, 'Enables the Dev-Testing Mode - Start with one Player & No Auto-Stop.')
    Menu:AddItem(TwoPlayerNeeded)
    Menu.OnCheckboxChange = function(Sender, Item, Checked)
        if Item == TwoPlayerNeeded then
			DevTestMode = Checked
			TriggerServerEvent('DD:Server:DevMode', DevTestMode)
        end
    end
end

function AddMenuOptionList(Menu)
    local SelectMap = UIMenuListItem.New('Select Map', AvailableMaps, 1)
    Menu:AddItem(SelectMap)
    Menu.OnListChange = function(Sender, Item, Index)
        if Item == SelectMap then
            CurrentMap = Item:IndexToItem(Index)
        end
    end
end

function AddMenuOptionItem(Menu)
    local ForceRestart = UIMenuItem.New('Force Restart', 'Forces the game to restart with the selected map.')
    Menu:AddItem(ForceRestart)
    local StopCurrentGame = UIMenuItem.New('Stop Current Game', 'Stops the current game and spawns the player back in the apartment.')
    Menu:AddItem(StopCurrentGame)
    Menu.OnItemSelect = function(Sender, Item, Index)
        if Item == ForceRestart then
			TriggerServerEvent('DD:Server:LoadMap', CurrentMap)
        elseif Item == StopCurrentGame then
			TriggerServerEvent('DD:Server:GameFinished')
        end
    end
end

RegisterNetEvent('DD:Client:SetUpDevMenu')
AddEventHandler('DD:Client:SetUpDevMenu', function()
	CurrentMap = AvailableMaps[1]
	AddMenuOptionCheckbox(MainMenu)
	AddMenuOptionList(MainMenu)
	AddMenuOptionItem(MainMenu)
	Pool:RefreshIndex()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        Pool:ProcessMenus()
        if IsControlJustPressed(1, 57) or IsDisabledControlJustPressed(1, 57) then
            MainMenu:Visible(not MainMenu:Visible())
            if MainMenu:Visible() then
				ScaleformCheckValue = -1
			end
        end
    end
end)
