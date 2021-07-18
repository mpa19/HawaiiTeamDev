HT_maria = {}
local HTM = HT_maria
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

Citizen.CreateThread(function(...)
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
    Citizen.Wait(0)
  end
end)

HTM.FoodDrainSpeed      = 0.1000
HTM.WaterDrainSpeed     = 0.2000
HTM.QualityDrainSpeed   = 0.0050

HTM.GrowthGainSpeed     = 0.2500
HTM.QualityGainSpeed    = 0.0750

HTM.SyncDist = 50.0
HTM.InteractDist = 2.5
HTM.PoliceJobLabel = "LSPD"
HTM.WeedPerBag = 5
HTM.JointsPerBag = 10
HTM.BagsPerPapers = 1

HTM.PlantTemplate = {
   ["Gender"] = "Female",
  ["Quality"] = 0.0,
   ["Growth"] = 0.0,
    ["Water"] = 20.0,
     ["Food"] = 20.0,
    ["Stage"] = 1,
}

HTM.ItemTemplate = {
     ["Type"] = "Water",
  ["Quality"] = 0.0,
}

HTM.Objects = {
  [1] = "bkr_prop_weed_01_small_01c",
  [2] = "bkr_prop_weed_01_small_01b",
  [3] = "bkr_prop_weed_01_small_01a",
  [4] = "bkr_prop_weed_med_01a",
  [5] = "bkr_prop_weed_med_01b",
  [6] = "bkr_prop_weed_lrg_01a",
  [7] = "bkr_prop_weed_lrg_01b",
}
