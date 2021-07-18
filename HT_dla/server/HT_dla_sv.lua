ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local hiddenprocess = vector3(-331.7995, -2444.753, 7.358099)
local hiddenlimpiar = vector3(-328.25, -2439.19, 7.358099)
local hiddenempaquetar = vector3(-326.83, -2436.96, 7.358099)


RegisterNetEvent('dla:updateTable')
AddEventHandler('dla:updateTable', function(bool)
    TriggerClientEvent('dla:syncTable', -1, bool)
end)


------------------------------------------------------- STEP 1 ----------------------------------------------------------------

ESX.RegisterServerCallback('dla:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

RegisterServerEvent("dla:processed")
AddEventHandler("dla:processed", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('restoscoca', 2)
    xPlayer.removeInventoryItem('restosamapola', 2)
    xPlayer.removeInventoryItem('queroseno', 1)
    xPlayer.addInventoryItem('pdla', 1)

end)

ESX.RegisterServerCallback('dla:process', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('restoscoca').count >= 2 and xPlayer.getInventoryItem('restosamapola').count >= 2 and xPlayer.getInventoryItem('queroseno').count >= 1 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 2 ----------------------------------------------------------------

ESX.RegisterServerCallback('dla:limpiarcoords', function(source, cb)
    cb(hiddenlimpiar)
end)

RegisterServerEvent("dla:limpiado")
AddEventHandler("dla:limpiado", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('pdla', 1)
    xPlayer.removeInventoryItem('dioxetina', 1)
    xPlayer.addInventoryItem('dlacristalizada', 1)

end)

ESX.RegisterServerCallback('dla:limpiar', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.getInventoryItem('pdla').count >= 1 and xPlayer.getInventoryItem('dioxetina').count >= 1 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 3 ----------------------------------------------------------------

ESX.RegisterServerCallback('dla:cristalizarcoords', function(source, cb)
    cb(hiddencristalizar)
end)

RegisterServerEvent("dla:cristalizado")
AddEventHandler("dla:cristalizado", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('dlacristalizada', 1)
    xPlayer.removeInventoryItem('bolsabasura', 1)
    xPlayer.addInventoryItem('fardodla', 10)
end)

ESX.RegisterServerCallback('dla:cristalizar', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.getInventoryItem('dlacristalizada').count >= 1 and xPlayer.getInventoryItem('bolsabasura').count >= 1 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------
