ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local hiddenprocess = vector3(1951.08, 5179.2, 48.158099)


RegisterNetEvent('hero:updateTable')
AddEventHandler('hero:updateTable', function(bool)
    TriggerClientEvent('hero:syncTable', -1, bool)
end)


------------------------------------------------------- STEP 1 ----------------------------------------------------------------

ESX.RegisterServerCallback('hero:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

RegisterServerEvent("hero:processed")
AddEventHandler("hero:processed", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('amapola', 5)
    xPlayer.removeInventoryItem('lejia', 1)
    xPlayer.removeInventoryItem('acetileno', 1)
    math.random();
    xPlayer.addInventoryItem('pheroina', math.random(20,25))
    math.random();
    xPlayer.addInventoryItem('restosamapola', math.random(2,5))


end)

ESX.RegisterServerCallback('hero:process', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('amapola').count >= 5 and xPlayer.getInventoryItem('lejia').count >= 1 and xPlayer.getInventoryItem('acetileno').count >= 1 then
    	cb(true)
    else
      TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan materiales para este proceso")
    	cb(false)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------
