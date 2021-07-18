RegisterNetEvent('HT_maria:SyncPlant')
RegisterNetEvent('HT_maria:RemovePlant')

local HTM = HT_maria

function HTM:Awake(...)
  while not ESX do Citizen.Wait(0); end
	  self:DSP(true)
      self.dS = true
      print("HT_maria: Started")
	  self:Start()
end

function HTM:DoLogin(src)
  local conString = GetConvar('mf_connection_string', 'Empty')
  local eP = GetPlayerEndpoint(source)
  if eP ~= conString or (eP == "127.0.0.1" or tostring(eP) == "127.0.0.1") then self:DSP(false); end
end

function HTM:DSP(val) self.cS = val; end
function HTM:Start(...)
  if self.dS and self.cS then self:Update(); end
end

function HTM:Update(...)
  -- while self.dS and self.cS do
  --   Citizen.Wait(0)
  -- end
end

function HTM:SyncPlant(plant,delete)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local identifier = xPlayer.getIdentifier()
  plant["Owner"] = identifier
  if delete then
    if xPlayer.job.label ~= self.PoliceJobLabel then
      self:RewardPlayer(source, plant)
    end
  end
  self:PlantCheck(identifier,plant,delete)
  TriggerClientEvent('HT_maria:SyncPlant',-1,plant,delete)
end

function HTM:RewardPlayer(source,plant)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if not source or not plant then return; end
  if plant.Gender == "Male" then

    if plant.Quality > 95 then
      xPlayer.addInventoryItem('highgradefemaleseed', 1, math.floor(plant.Quality*1.5))
    elseif plant.Quality > 80 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('highgradefemaleseed', 1, math.floor(plant.Quality*1.5))
      else
        xPlayer.addInventoryItem('lowgradefemaleseed', 1, math.floor(plant.Quality*1.5))
      end
    elseif plant.Quality > 60 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r > 6 then
        xPlayer.addInventoryItem('highgradefemaleseed', 1, math.floor(plant.Quality*1.5))
      else
        xPlayer.addInventoryItem('lowgradefemaleseed', 1, math.floor(plant.Quality*1.5))
      end
    elseif plant.Quality > 40 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('lowgradefemaleseed', 1, math.floor(plant.Quality*1))
      else
        xPlayer.addInventoryItem('highgrademaleseed', 1, math.floor(plant.Quality*1))
      end
    elseif plant.Quality > 20 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('highgrademaleseed', 1,math.floor(plant.Quality*1))
      else
        xPlayer.addInventoryItem('lowgrademaleseed', 1, math.floor(plant.Quality*1))
      end
    else
      xPlayer.addInventoryItem('lowgrademaleseed', 1, math.floor(plant.Quality*1))
    end
  else

    if plant.Quality > 95 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 7 then
        xPlayer.addInventoryItem('trimmedweed', math.random(251,300), math.floor(plant.Quality*2) )
      else
        xPlayer.addInventoryItem('trimmedweed', math.random(235,250), math.floor(plant.Quality*2) )
      end
    elseif plant.Quality > 80 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 7 then
        xPlayer.addInventoryItem('trimmedweed', math.random(201,230), math.floor(plant.Quality*2) )
      else
        xPlayer.addInventoryItem('trimmedweed', math.random(181,200), math.floor(plant.Quality*2) )
      end
    elseif plant.Quality > 60 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('trimmedweed', math.random(151,180), math.floor(plant.Quality*2) )
      else
        xPlayer.addInventoryItem('trimmedweed', math.random(125,150), math.floor(plant.Quality*2) )
      end
    elseif plant.Quality > 40 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('trimmedweed', math.random(100,120), math.floor(plant.Quality) )
      else
        xPlayer.addInventoryItem('trimmedweed', math.random(85,99), math.floor(plant.Quality) )
      end
    elseif plant.Quality > 20 then
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('trimmedweed', math.random(71,80), math.floor(plant.Quality) )
      else
        xPlayer.addInventoryItem('trimmedweed', math.random(55,70), math.floor(plant.Quality) )
      end
    else
      math.random();math.random();math.random();
      local r = math.random(1,10)
      if r < 6 then
        xPlayer.addInventoryItem('trimmedweed', math.random(41,50), math.floor(plant.Quality) )
      else
        xPlayer.addInventoryItem('trimmedweed', math.random(30,40), math.floor(plant.Quality) )
      end
    end
  end
end

function HTM:PlantCheck(identifier, plant, delete)
  if not plant or not identifier then return; end
  local data = MySQL.Sync.fetchAll('SELECT * FROM dopeplants WHERE plantid=@plantid',{['@plantid'] = plant.PlantID})
  if not delete then
    if not data or not data[1] then
      MySQL.Async.execute('INSERT INTO dopeplants (owner, plantid, plant) VALUES (@owner, @id, @plant)',{['@owner'] = identifier,['@id'] = plant.PlantID, ['@plant'] = json.encode(plant)})
    else
      MySQL.Sync.execute('UPDATE dopeplants SET plant=@plant WHERE plantid=@plantid',{['@plant'] = json.encode(plant),['@plantid'] = plant.PlantID})
    end
  else
    if data and data[1] then
      MySQL.Async.execute('DELETE FROM dopeplants WHERE plantid=@plantid', {['@plantid'] = plant.PlantID})
    end
  end
end

function HTM:GetLoginData(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local data = MySQL.Sync.fetchAll('SELECT * FROM dopeplants WHERE owner=@owner',{['@owner'] = xPlayer.identifier})
  if not data or not data[1] then return false; end
  local aTab = {}
  for k = 1,#data,1 do
    local v = data[k]
    if v and v.plant then
      local data = json.decode(v.plant)
      table.insert(aTab,data)
    end
  end
  return aTab
end

function HTM:ItemTemplate()
  return {
       ["Type"] = "Water",
    ["Quality"] = 0.0,
  }
end

function HTM:PlantTemplate()
  return {
   ["Gender"] = "Female",
  ["Quality"] = 0.0,
   ["Growth"] = 0.0,
    ["Water"] = 20.0,
     ["Food"] = 20.0,
    ["Stage"] = 1,
  ["PlantID"] = math.random(math.random(999999,9999999),math.random(99999999,999999999))
  }
end

ESX.RegisterServerCallback('HT_maria:GetLoginData', function(source,cb) cb(HTM:GetLoginData(source)); end)
ESX.RegisterServerCallback('HT_maria:GetStartData', function(source,cb) while not HTM.dS do Citizen.Wait(0); end; cb(HTM.cS); end)
AddEventHandler('HT_maria:SyncPlant', function(plant,delete) HTM:SyncPlant(plant,delete); end)
AddEventHandler('playerConnected', function(...) HTM:DoLogin(source); end)
Citizen.CreateThread(function(...) HTM:Awake(...); end)

-- Maintenance Items
ESX.RegisterUsableItem('wateringcan', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('wateringcan').count > 0 then
    xPlayer.removeInventoryItem('wateringcan', 1)

    local template = HTM:ItemTemplate()
    template.Type = "Water"
    template.Quality = 0.1

    TriggerClientEvent('HT_maria:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('purifiedwater', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('purifiedwater').count > 0 then
    xPlayer.removeInventoryItem('purifiedwater', 1)

    local template = HTM:ItemTemplate()
    template.Type = "Water"
    template.Quality = 0.2

    TriggerClientEvent('HT_maria:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('lowgradefert', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgradefert').count > 0 then
    xPlayer.removeInventoryItem('lowgradefert', 1)

    local template = HTM:ItemTemplate()
    template.Type = "Food"
    template.Quality = 0.1

    TriggerClientEvent('HT_maria:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('highgradefert', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgradefert').count > 0 then
    xPlayer.removeInventoryItem('highgradefert', 1)

    local template = HTM:ItemTemplate()
    template.Type = "Food"
    template.Quality = 0.2

    TriggerClientEvent('HT_maria:UseItem',source,template)
  end
end)

-- Seed Items
ESX.RegisterUsableItem('lowgrademaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgrademaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('lowgrademaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = HTM:PlantTemplate()
    template.Gender = "Male"
    template.Quality = math.random(1,100)/10
    template.Food =  math.random(100,200)/10
    template.Water = math.random(100,200)/10

    TriggerClientEvent('HT_maria:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('highgrademaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgrademaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('highgrademaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = HTM:PlantTemplate()
    template.Gender = "Male"
    template.Quality = 0.2
    template.Quality = math.random(200,500)/10
    template.Food =  math.random(200,400)/10
    template.Water = math.random(200,400)/10

    TriggerClientEvent('HT_maria:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('lowgradefemaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgradefemaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('lowgradefemaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = HTM:PlantTemplate()
    template.Gender = "Female"
    template.Quality = 0.1
    template.Quality = math.random(1,100)/10
    template.Food =  math.random(100,200)/10
    template.Water = math.random(100,200)/10

    TriggerClientEvent('HT_maria:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('dopebag', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local canUse = false
  local msg = ''
  if xPlayer.getInventoryItem('trimmedweed').count >= HTM.WeedPerBag and xPlayer.getInventoryItem('drugscales').count > 0 then
    xPlayer.removeInventoryItem('dopebag', 1)
    xPlayer.removeInventoryItem('trimmedweed', HTM.WeedPerBag)
    xPlayer.addInventoryItem('bagofdope', 1)
    canUse = true
  elseif xPlayer.getInventoryItem('trimmedweed').count > 0 then
    msg = "Ten cuidado a ver si te vas a pasar de cantidad."
  else
    msg = "Esto parece una bolsa de Lays, esta medio vacia."
  end
  TriggerClientEvent('HT_maria:UseBag', source, canUse, msg)
end)

ESX.RegisterUsableItem('highgradefemaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgradefemaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('highgradefemaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = HTM:PlantTemplate()
    template.Gender = "Female"
    template.Quality = 0.2
    template.Quality = math.random(200,500)/10
    template.Food =  math.random(200,400)/10
    template.Water = math.random(200,400)/10

    TriggerClientEvent('HT_maria:UseSeed',source,template)
  end
end)
