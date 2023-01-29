ESX = nil
local grupo = nil
local invisible = false
local noclip = false
local godmode = false
local arder = false
local soygm = false
local gamerTags = {}

local PlayerLoaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerLoaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)


Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(1, 57) then
            ESX.TriggerServerCallback('admin:grupo', function(grup)  grupo = grup end)
            while grupo == nil do
                Citizen.Wait(500)
            end
            if grupo == 'admin' then
                ESX.UI.Menu.CloseAll()
                OpenMenuAdministrasion()
            end
        end
        Citizen.Wait(10)
    end
end)


function Text(text)
	SetTextColour(255, 255, 255, 255)
	SetTextFont(0)
	SetTextScale(0.478, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(0.007, 0.077)
end

function OpenMenuAdministrasion(source)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_actions',
    {
        title    = 'Panel admin',
        align    = 'bottom-right',
        elements = {
            {label = 'GodMode',    value = '1'},
            {label = 'Invisible',    value = '2'},
            {label = 'Teleport',    value = '3'},
            {label = 'Mostrar Coordenadas',    value = '4'},
            {label = 'Mostrar Nombres',    value = '10'},
			{label = 'Abrir coche',    value = '5'},
			{label = 'Noclip',    value = '51'},
			{label = 'Reparar',    value = '6'},
        }
    }, function(data, menu)
        if data.current.value == '1' then
            TriggerEvent("inv:godmode", src)
            menu.close()
       	elseif data.current.value == '2' then
            TriggerEvent("inv:invisible", src)
            menu.close()
            
        elseif data.current.value == '3' then
            TriggerEvent("inv:teleport", src)
            menu.close()

        elseif data.current.value == '4' then
            modo_showcoord()
            menu.close()

        elseif data.current.value == '10' then
            modo_showname()
            menu.close()

		elseif data.current.value == 'jail' then
			menu.close()
            TriggerEvent("esx-qalle-jail:openJailMenu")

        elseif data.current.value == '5' then
            TriggerEvent("inv:abrircoche", src)
            menu.close()
        elseif data.current.value == '51' then
            admin_no_clip()
            menu.close()
        elseif data.current.value == '6' then
            TriggerEvent("inv:fixcar", src)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('inv:godmode')
AddEventHandler('inv:godmode',function()
	if godmode then
		SetEntityInvincible(GetPlayerPed(-1),false)
		SetNotificationTextEntry("STRING")
		AddTextComponentString("GodMode desactivado :(" )
		DrawNotification(false, true)
		godmode = false
	else
		SetEntityInvincible(GetPlayerPed(-1),true)
		SetNotificationTextEntry("STRING")
		AddTextComponentString("GodMode activado" )
		DrawNotification(false, true)
		godmode = true
	end
end)

RegisterNetEvent('inv:invisible')
AddEventHandler('inv:invisible',function()
	if invisible == false then
		SetEntityVisible(GetPlayerPed(-1),false)
		invisible = true
		SetNotificationTextEntry("STRING")
		AddTextComponentString("Eres invisible." )
		DrawNotification(false, true)
	else
		SetEntityVisible(GetPlayerPed(-1),true)
		invisible = false
		SetNotificationTextEntry("STRING")
		AddTextComponentString("Ya no eres invisible" )
		DrawNotification(false, true)
	end

end)

RegisterNetEvent('inv:teleport')
AddEventHandler('inv:teleport',function()
local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)

                break
            end
            Citizen.Wait(10)
        end
    else
    end
end)
-- by isaragon
RegisterNetEvent('inv:adelante')
AddEventHandler('inv:adelante',function()
	local player = GetPlayerPed(-1)
	local blip = GetFirstBlipInfoId(8)
	local coord = GetEntityCoords(GetPlayerPed(-1))
	local player = GetPlayerPed(-1)
	local coche = nil
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
		 coche =  GetVehiclePedIsIn(GetPlayerPed(-1),false)
	end
		SetEntityCoords(player,coord.x+5,coord.y,coord.z)
		if coche then
			SetEntityCoords(coche,coord.x+5,coord.y,coord.z)
			SetPedIntoVehicle(GetPlayerPed(-1), coche, - 1)
		end


end)

RegisterNetEvent('inv:abrircoche')
AddEventHandler('inv:abrircoche',function()
  local coords = GetEntityCoords(GetPlayerPed(-1))

  local vehicle, distance = ESX.Game.GetClosestVehicle({
    x = coords.x,
    y = coords.y,
    z = coords.z
  })


  	if distance ~= -1 and distance <= 2.0 then

		SetVehicleDoorsLocked(vehicle, 1)
		SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
	end
end)

RegisterNetEvent('inv:fixcar')
AddEventHandler('inv:fixcar',function()
	local coche = nil
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
		 coche =  GetVehiclePedIsIn(GetPlayerPed(-1),false)
	end
	if coche then
	    SetVehicleFixed(coche)
	    SetVehicleDeformationFixed(coche)
	    end
end)


function modo_showcoord()
	showcoord = not showcoord
end

-- Afficher Nom
function modo_showname()
	showname = not showname
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

function admin_no_clip()
	noclip = not noclip
	if noclip then
		plyPed = PlayerPedId()
		FreezeEntityPosition(plyPed, true)
		SetEntityInvincible(plyPed, true)
		SetEntityCollision(plyPed, false, false)

		SetEntityVisible(plyPed, false, false)

		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		SetNotificationTextEntry("STRING")
		AddTextComponentString("Noclip activado" )
		DrawNotification(false, true)
	else
		plyPed = PlayerPedId()
		FreezeEntityPosition(plyPed, false)
		SetEntityInvincible(plyPed, false)
		SetEntityCollision(plyPed, true, true)

		SetEntityVisible(plyPed, true, false)

		SetNotificationTextEntry("STRING")
		AddTextComponentString("Noclip desactivado" )
		DrawNotification(false, true)
	end
end

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()
		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			Text('~r~X~s~: ' .. playerPos.x .. ' ~b~Y~s~: ' .. playerPos.y .. ' ~g~Z~s~: ' .. playerPos.z .. ' ~y~Angle~s~: ' .. GetEntityHeading(plyPed))
		end
		if showname then
			for k, v in ipairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
				if otherPed ~= plyPed then
					if GetDistanceBetweenCoords(GetEntityCoords(plyPed), GetEntityCoords(otherPed)) < 500.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('%s [%s]'):format(GetPlayerName(v), GetPlayerServerId(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		end
		if noclip then
			local coords = GetEntityCoords(plyPed)
			local camCoords = getCamDirection()
			local velocidad = 1.0

			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				coords = coords + (velocidad * camCoords)
			end

			if IsControlPressed(0, 269) then
				coords = coords - (velocidad * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, coords, true, true, true)
		end
		Citizen.Wait(0)
	end
end)