ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local hiddenprocess = vector3(-331.7995, -2444.753, 7.358099)
local hiddenlimpiar = vector3(-328.25, -2439.19, 7.358099)
local hiddenempaquetar = vector3(-326.83, -2436.96, 7.358099)
local hiddencristalizar = vector3(-324.62, -2442.83, 7.358099)


RegisterNetEvent('coke:updateTable')
AddEventHandler('coke:updateTable', function(bool)
    TriggerClientEvent('coke:syncTable', -1, bool)
end)


------------------------------------------------------- STEP 1 ----------------------------------------------------------------

ESX.RegisterServerCallback('coke:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

RegisterServerEvent("coke:processed")
AddEventHandler("coke:processed", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('hojacoca', 5)
    xPlayer.removeInventoryItem('acidosulfurico', 2)
    xPlayer.removeInventoryItem('acidocloridico', 2)
    xPlayer.addInventoryItem('cocasucia', 1)

end)

ESX.RegisterServerCallback('coke:process', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('hojacoca').count >= 5 and xPlayer.getInventoryItem('acidocloridico').count >= 2 and xPlayer.getInventoryItem('acidosulfurico').count >= 2 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 2 ----------------------------------------------------------------

ESX.RegisterServerCallback('coke:limpiarcoords', function(source, cb)
    cb(hiddenlimpiar)
end)

RegisterServerEvent("coke:limpiado")
AddEventHandler("coke:limpiado", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('cocasucia', 1)
    xPlayer.removeInventoryItem('dicromatopotasio', 2)
    xPlayer.addInventoryItem('cocalimpia', 1)
    math.random();
    xPlayer.addInventoryItem('restoscoca', math.random(2,5))
end)

ESX.RegisterServerCallback('coke:limpiar', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.getInventoryItem('cocasucia').count >= 1 and xPlayer.getInventoryItem('dicromatopotasio').count >= 2 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 3 ----------------------------------------------------------------

ESX.RegisterServerCallback('coke:cristalizarcoords', function(source, cb)
    cb(hiddencristalizar)
end)

RegisterServerEvent("coke:cristalizado")
AddEventHandler("coke:cristalizado", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('permanganato', 1)
    xPlayer.removeInventoryItem('cocalimpia', 1)
    xPlayer.addInventoryItem('cocacristalizada', 1)
end)

ESX.RegisterServerCallback('coke:cristalizar', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.getInventoryItem('permanganato').count >= 1 and xPlayer.getInventoryItem('cocalimpia').count >= 1 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- STEP 4 ----------------------------------------------------------------

ESX.RegisterServerCallback('coke:empaquetarcoords', function(source, cb)
    cb(hiddenempaquetar)
end)

RegisterServerEvent("coke:empaquetado")
AddEventHandler("coke:empaquetado", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('cocacristalizada', 1)
    xPlayer.removeInventoryItem('dopebag', 1)
    math.random();
    xPlayer.addInventoryItem('chivatoscoca', math.random(25,32))
end)

ESX.RegisterServerCallback('coke:empaquetar', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.getInventoryItem('cocacristalizada').count >= 1 and xPlayer.getInventoryItem('dopebag').count >= 1 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------
