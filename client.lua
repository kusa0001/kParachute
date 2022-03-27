ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

Menu = {}

Menu.Main = RageUI.CreateMenu('', 'Menu Intéractions', 10, 80, 'kparachute', 'interaction_bgd')

isMenuOpen = false

CreateThread(function()
    for k,v in pairs(Config.Position) do
        local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)

        SetBlipSprite(blip, 94)
        SetBlipColour(blip, 2)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Saut en Parachute')
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Position) do
        local MODEL = GetHashKey('cs_dom')
        
        RequestModel(MODEL)
        while not HasModelLoaded(MODEL) do
            Citizen.Wait(1)
        end
        
        local ped = CreatePed(4, MODEL, v.position.x, v.position.y, v.position.z-1.0, v.angle)

        SetPedDropsWeaponsWhenDead(ped, false)
	    SetPedDiesWhenInjured(ped, false)
	    SetEntityInvincible(ped , true)
	    FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        Citizen.Wait(1)
    end
end)

CreateThread(function()
    while true do
        local timer = 800
        for k,v in pairs(Config.Position) do
            local playerPos = GetEntityCoords(GetPlayerPed(-1), false)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, v.position.x, v.position.y, v.position.z)
            if distance < 2.0 then
                timer = 0
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour intéragir !')
                if IsControlJustPressed(0, 38) then
                    OpenMenu()
                end
            elseif distance < 5.0 then
                RageUI.CloseAll()
            end
        end
    Wait(timer)
    end
end)


OpenMenu = function()

    if isMenuOpen then
        isMenuOpen = false
        RageUI.Visible(Menu.Main, false)
    else
        isMenuOpen = true
        RageUI.Visible(Menu.Main, true)
        Citizen.CreateThread(function()
        
            while isMenuOpen do
                Wait(1)
                RageUI.IsVisible(Menu.Main, function()

                    RageUI.Separator('~b~Bienvenue~s~, Que voulez-vous ~s~?')

                    RageUI.Button('Acheter un Parachute', 'Prix d\'achat ~s~: ~g~'..Config.Price..' $ ~s~!', {RightLabel = '→→'}, true, {
                        onSelected = function()
                            if Config.ArmesItem then
                                TriggerServerEvent('kParachute:GiveItemParachute', Config.Item)
                            else
                                TriggerServerEvent('kParachute:GiveWeaponsParachute', 'gadget_parachute')
                            end
                        end
                    }, Menu.Main)

                end)

            end

        end)
    end

end