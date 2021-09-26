ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

ESX.PlayerData = ESX.GetPlayerData()
end)

local inUse = false
local process
local limpiar
local empaquetar
local cristalizar
local blip
local isProcessing = false
local player

Citizen.CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    ESX.TriggerServerCallback('coke:processcoords', function(servercoords)
        process = servercoords
	end)
end)

Citizen.CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    ESX.TriggerServerCallback('coke:limpiarcoords', function(servercoords1)
        limpiar = servercoords1
	end)
end)

Citizen.CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    ESX.TriggerServerCallback('coke:empaquetarcoords', function(servercoords2)
        empaquetar = servercoords2
	end)
end)

Citizen.CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    ESX.TriggerServerCallback('coke:cristalizarcoords', function(servercoords3)
        cristalizar = servercoords3
	end)
end)

RegisterNetEvent('coke:syncTable')
AddEventHandler('coke:syncTable', function(bool)
    inUse = bool
end)

function main()
	TriggerServerEvent('coke:updateTable', true)
end


------------------------------------------------------- STEP 1 ----------------------------------------------------------------

Citizen.CreateThread(function()
	local sleep
	while not process do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = GetPlayerPed(-1)
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x,playercoords.y,playercoords.z)-vector3(process.x,process.y,process.z))
		if dist <= 1.5 and not isProcessing then
			sleep = 5
			DrawText3Ds(process.x, process.y, process.z, _U'break_1')
			if IsControlJustPressed(1, 51) then
				isProcessing = true
				ESX.TriggerServerCallback('coke:process', function(success)
					if success then
						processing()
					else
						isProcessing = false
					end
				end)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)

function processing()
	local player = GetPlayerPed(-1)
	SetEntityCoords(player, process.x,process.y,process.z-1, 0.0, 0.0, 0.0, false)
	SetEntityHeading(player, 232.84)
	FreezeEntityPosition(player, true)
	if Config.progBar then
		exports['progressBars']:startUI(90000, _U'breaking_1')
	end
  playAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 90000)
	Citizen.Wait(90000)
	FreezeEntityPosition(player, false)
	TriggerServerEvent('coke:processed')
	isProcessing = false
end

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 2 ----------------------------------------------------------------
Citizen.CreateThread(function()
	local sleep
	while not limpiar do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = GetPlayerPed(-1)
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x,playercoords.y,playercoords.z)-vector3(limpiar.x,limpiar.y,limpiar.z))
		if dist <= 1.5 and not isProcessing then
			sleep = 5
			DrawText3Ds(limpiar.x, limpiar.y, limpiar.z, _U'break_2')
			if IsControlJustPressed(1, 51) then
				isProcessing = true
				ESX.TriggerServerCallback('coke:limpiar', function(success)
					if success then
						limpiando()
					else
						isProcessing = false
					end
				end)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)

function limpiando()
	local player = GetPlayerPed(-1)
	SetEntityCoords(player, limpiar.x,limpiar.y,limpiar.z-1, 0.0, 0.0, 0.0, false)
	SetEntityHeading(player, 144.46)
	FreezeEntityPosition(player, true)
	if Config.progBar then
		exports['progressBars']:startUI(90000, _U'breaking_2')
	end
	playAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 90000)
	Citizen.Wait(90000)
	FreezeEntityPosition(player, false)
	TriggerServerEvent('coke:limpiado')
	isProcessing = false
end
-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 3 ----------------------------------------------------------------

Citizen.CreateThread(function()
	local sleep
	while not cristalizar do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = GetPlayerPed(-1)
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x,playercoords.y,playercoords.z)-vector3(cristalizar.x,cristalizar.y,cristalizar.z))
		if dist <= 1.5 and not isProcessing then
			sleep = 5
			DrawText3Ds(cristalizar.x, cristalizar.y, cristalizar.z, _U'break_4')
			if IsControlJustPressed(1, 51) then
				isProcessing = true
				ESX.TriggerServerCallback('coke:cristalizar', function(success)
					if success then
						cristalizando()
					else
						isProcessing = false
					end
				end)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)

function cristalizando()
	local player = GetPlayerPed(-1)
	SetEntityCoords(player, cristalizar.x,cristalizar.y,cristalizar.z-1, 0.0, 0.0, 0.0, false)
	SetEntityHeading(player, 232.84)
	FreezeEntityPosition(player, true)
	if Config.progBar then
		exports['progressBars']:startUI(105000, _U'breaking_4')
	end
	playAnim("anim@heists@humane_labs@emp@hack_door", "hack_intro", 105000)
	Citizen.Wait(105000)
	FreezeEntityPosition(player, false)
	TriggerServerEvent('coke:cristalizado')
	isProcessing = false
end

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 4 ----------------------------------------------------------------
Citizen.CreateThread(function()
	local sleep
	while not empaquetar do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = GetPlayerPed(-1)
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x,playercoords.y,playercoords.z)-vector3(empaquetar.x,empaquetar.y,empaquetar.z))
		if dist <= 1.5 and not isProcessing then
			sleep = 5
			DrawText3Ds(empaquetar.x, empaquetar.y, empaquetar.z, _U'break_3')
			if IsControlJustPressed(1, 51) then
				isProcessing = true
				ESX.TriggerServerCallback('coke:empaquetar', function(success)
					if success then
						empaquetando()
					else
						isProcessing = false
					end
				end)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)

function empaquetando()
	local player = GetPlayerPed(-1)
	SetEntityCoords(player, empaquetar.x,empaquetar.y,empaquetar.z-1, 0.0, 0.0, 0.0, false)
	SetEntityHeading(player, 53.97)
	FreezeEntityPosition(player, true)
	if Config.progBar then
		exports['progressBars']:startUI(75000, _U'breaking_3')
	end
	playAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 75000)
	Citizen.Wait(75000)
	FreezeEntityPosition(player, false)
	TriggerServerEvent('coke:empaquetando')
	isProcessing = false
end
-------------------------------------------------------------------------------------------------------------------------------



function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

-- (Optional) Shows your coords, useful if you want to add new locations.

if Config.getCoords then
	RegisterCommand("mycoords", function()
		local player = GetPlayerPed(-1)
	    local x,y,z = table.unpack(GetEntityCoords(player))
	    print("X: "..x.." Y: "..y.." Z: "..z)
	end)
end
