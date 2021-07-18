ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_methcar:start')
AddEventHandler('esx_methcar:start', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('yodo').count >= 1 and xPlayer.getInventoryItem('hsodio').count >= 10 and xPlayer.getInventoryItem('liquidofrenos').count >= 2 and xPlayer.getInventoryItem('methlab').count >= 1 then
		if xPlayer.getInventoryItem('meth').count >= 40 then
				TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Vas hasta arriba de metanfetamina")
		else
			TriggerClientEvent('esx_methcar:startprod', _source)
			xPlayer.removeInventoryItem('liquidofrenos', 2)
			xPlayer.removeInventoryItem('hsodio', 10)
			xPlayer.removeInventoryItem('yodo', 1)
		end



	else
		TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Te faltan productos para empezar a cocinar")

	end

end)
RegisterServerEvent('esx_methcar:stopf')
AddEventHandler('esx_methcar:stopf', function(id)
local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:stopfreeze', xPlayers[i], id)
	end

end)
RegisterServerEvent('esx_methcar:make')
AddEventHandler('esx_methcar:make', function(posx,posy,posz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('methlab').count >= 1 then

		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('esx_methcar:smoke',xPlayers[i],posx,posy,posz, 'a')
		end

	else
		TriggerClientEvent('esx_methcar:stop', _source)
	end

end)
RegisterServerEvent('esx_methcar:finish')
AddEventHandler('esx_methcar:finish', function(qualtiy)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print(qualtiy)
	TriggerEvent('KLevels:addXP', _source, 20)
	xPlayer.addInventoryItem('meth', math.floor(qualtiy / 3))

end)

RegisterServerEvent('esx_methcar:blow')
AddEventHandler('esx_methcar:blow', function(posx, posy, posz)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:blowup', xPlayers[i],posx, posy, posz)
	end
	xPlayer.removeInventoryItem('methlab', 1)
end)
