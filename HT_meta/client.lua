local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local started = false
local displayed = false
local progress = 0
local CurrentVehicle 
local pause = false
local selection = 0
local quality = 100
ESX = nil

local LastCar

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_methcar:stop')
AddEventHandler('esx_methcar:stop', function()
	started = false
	FreezeEntityPosition(LastCar, false)
end)
RegisterNetEvent('esx_methcar:stopfreeze')
AddEventHandler('esx_methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)
RegisterNetEvent('esx_methcar:notify')
AddEventHandler('esx_methcar:notify', function(message)
	ESX.ShowNotification(message)
end)

RegisterNetEvent('esx_methcar:startprod')
AddEventHandler('esx_methcar:startprod', function()
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	displayed = false
	print('Cocinando metanfetamina')
	ESX.ShowNotification("~r~Los fogones estan en marcha")	
	SetPedIntoVehicle(GetPlayerPed(-1), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('esx_methcar:blowup')
AddEventHandler('esx_methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)
	
end)


RegisterNetEvent('esx_methcar:smoke')
AddEventHandler('esx_methcar:smoke', function(posx, posy, posz, bool)

	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", posx, posy, posz + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.8)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end

end)
RegisterNetEvent('esx_methcar:drugged')
AddEventHandler('esx_methcar:drugged', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	ClearTimecycleModifier()
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed) then
			
			
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())

			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)
	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)
			
			if modelName == 'JOURNEY' and car then
				
					if GetPedInVehicleSeat(car, -1) == playerPed then
						if started == false then
							if displayed == false then
								DisplayHelpText("Pulsa ~INPUT_THROW_GRENADE~ para empezar a cocinar")
								displayed = true
							end
						end
						if IsControlJustReleased(0, Keys['G']) then
							if pos.y >= 3500 then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('esx_methcar:start')	
									progress = 0
									pause = false
									selection = 0
									quality = 100
									
								else
									DisplayHelpText('~r~¿Vas a cocinar de pie?')
								end
							else
								ESX.ShowNotification('~r~Aqui vas a llamar mucho la atencion')
							end
							
							
							
							
		
						end
					end
					
				
				
			
			end
			
		else

				
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('Apagando fogones')
					FreezeEntityPosition(LastCar,false)
				end
		end
		
		if started == true then
			
			if progress < 96 then
				Citizen.Wait(6000)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					ESX.ShowNotification('~r~Progreso: ~g~~h~' .. progress .. '%')
					Citizen.Wait(6000) 
				end

				--
				--   EVENT 1
				--
				if progress > 22 and progress < 24 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Has añadido 500ml de Yodo, ¿cuanto sodio añades?')	
						ESX.ShowNotification('~o~1. 50g de Sodio')
						ESX.ShowNotification('~o~2. 100g de Sodio ')
						ESX.ShowNotification('~o~3. 30g de Sodio')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Empezaria a oler a quemado')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Al toque mi rey')
						pause = false
					end
				end
				--
				--   EVENT 5
				--
				if progress > 30 and progress < 32 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Se esta llenando la caravana de humo, ¿que haces?')	
						ESX.ShowNotification('~o~1. Abre la ventana')
						ESX.ShowNotification('~o~2. Ventilas la mezcla con la mano')
						ESX.ShowNotification('~o~3. Te colocas una mascara de gas')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~El humo saldria poco a poco por la ventana')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Te has intoxicado')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Asi mejor')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 2
				--
				if progress > 38 and progress < 40 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~La mezcla se esta poniendo espesa, ¿que haces?')	
						ESX.ShowNotification('~o~1. Le echas gasolina')
						ESX.ShowNotification('~o~2. Le echas liquido de frenos')
						ESX.ShowNotification('~o~3. Le echas agua')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~La mezcla comenzaria a diluir')
						pause = false
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~La mezcla sigue un poco espesa')
						pause = false
						quality = quality - 2
					end
				end
				--
				--   EVENT 8 - 3
				--
				if progress > 41 and progress < 43 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Accidentalmente, has echado mucho liquido de frenos, ¿que haces?')	
						ESX.ShowNotification('~o~1. Nada')
						ESX.ShowNotification('~o~2. Intentas retirarlo con una cuchara')
						ESX.ShowNotification('~o~3. Añades mas sodio')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~La mezcla oleria mucho a liquido de frenos')
						quality = quality - 4
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~No va a hacer mucho, pero parece que funciona')
						pause = false
						quality = quality - 2
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Al toque mi rey')
						pause = false
					end
				end
				--
				--   EVENT 3
				--
				if progress > 46 and progress < 49 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~La mezcla esta cambiando de color, ¿que haces?')	
						ESX.ShowNotification('~o~1. Nada')
						ESX.ShowNotification('~o~2. Removerlo')
						ESX.ShowNotification('~o~3. Beberlo')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~La mezcla ahora es azul')
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~La mezcla se ha destruido un poco')
						quality = quality - 2
						pause = false
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Eso no te ha sentado muy bien')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
				end
				--
				--   EVENT 4
				--
				if progress > 55 and progress < 58 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~La mezcla empieza a burbujear y la temperatura esta a 80 grados, ¿que haces?')	
						ESX.ShowNotification('~o~1. Bajar la temperatura')
						ESX.ShowNotification('~o~2. Nada')
						ESX.ShowNotification('~o~3. Subir la temperatura')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Compressed air sprayed the liquid meth all over you')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Replacing it was probably the best option')
						pause = false
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
				end
				--
				--   EVENT 5
				--
				if progress > 58 and progress < 60 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Se te ha derramado sodio en el suelo, ¿que haces?')	
						ESX.ShowNotification('~o~1. Limpiarlo')
						ESX.ShowNotification('~o~2. Nada')
						ESX.ShowNotification('~o~3. Añadirlo a la mezcla')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Has perdido sodio, pero la mezcla sigue bien')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Has inhalado mucho sodio')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
				end
				--
				--   EVENT 1 - 6
				--
				if progress > 63 and progress < 65 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~La temperatura ha subido a 90 grados, ¿que haces?')	
						ESX.ShowNotification('~o~1. Destapas la mezcla')
						ESX.ShowNotification('~o~2. Nada')
						ESX.ShowNotification('~o~3. Bajas la temperatura')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Parece que ayuda, pero no lo suficiente')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~La temperatura se ha estabilizado')
						pause = false
					end
				end
				--
				--   EVENT 4 - 7
				--
				if progress > 71 and progress < 73 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~La mezcla comienza a ponerse verde, ¿que haces?')	
						ESX.ShowNotification('~o~1. Echarle 100g de sodio')
						ESX.ShowNotification('~o~2. Echarle 70g de sodio')
						ESX.ShowNotification('~o~3. Echarle 50g de sodio')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~La mezcla comenzaria a salirse por fuera')
						quality = quality - 4
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~La mezcla ha vuelto a ponerse azul')
						pause = false
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~La mezcla ha cambiado un poco el color, pero no es suficiente')
						pause = false
						quality = quality - 2
					end
				end
				--
				--   EVENT 8
				--
				if progress > 76 and progress < 78 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Se ha formado una placa solida sobre la mezcla, ¿que haces?')	
						ESX.ShowNotification('~o~1. Le echas agua')
						ESX.ShowNotification('~o~2. La raspas con un tenedor')
						ESX.ShowNotification('~o~3. Nada')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Ahora tienes una placa solida con agua')
						quality = quality - 4
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Has agrietado la mezcla')
						pause = false
						quality = quality - 2
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~La mezcla va teniendo buena pinta')
						pause = false
					end
				end
				--
				--   EVENT 9
				--
				if progress > 82 and progress < 84 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Necesitas ir a cagar, ¿que haces?')	
						ESX.ShowNotification('~o~1. Aguantarte')
						ESX.ShowNotification('~o~2. Ir a fuera y cagar')
						ESX.ShowNotification('~o~3. Cagarte encima')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Ya falta poco')
						pause = false
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Algo huele mal y no es la mezcla')
						pause = false
						quality = quality - 2
					end
				end
				--
				--   EVENT 10
				--
				if progress > 88 and progress < 90 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~La mezcla parece haber llegado a su fin, ¿que haces?')	
						ESX.ShowNotification('~o~1. Le echas gasolina para mejorar la calidad y la recoges')
						ESX.ShowNotification('~o~2. La dejas enfriar y la recoges')
						ESX.ShowNotification('~o~3. Le echas liquido de freno para potenciar su efecto y la recoges')
						ESX.ShowNotification('~c~Presiona el numero de la opcion que elijas')
					end
					if selection == 1 then
						print("Seleccionado 1")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
					if selection == 2 then
						print("Seleccionado 2")
						ESX.ShowNotification('~r~Parece de buena calidad')
						pause = false
					end
					if selection == 3 then
						print("Seleccionado 3")
						ESX.ShowNotification('~r~Empezaria a arder la mezcla')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 100
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('El laboratorio se ha destruido')
					end
				end
				
				
				
				
				
				
				
				if IsPedInAnyVehicle(playerPed) then
					TriggerServerEvent('esx_methcar:make', pos.x,pos.y,pos.z)
					if pause == false then
						selection = 0
						progress = progress +  math.random(1, 2)
						ESX.ShowNotification('~r~Progreso: ~g~~h~' .. progress .. '%')
					end
				else
					TriggerEvent('esx_methcar:stop')
				end

			else
				TriggerEvent('esx_methcar:stop')
				progress = 100
				ESX.ShowNotification('~r~Progreso: ~g~~h~' .. progress .. '%')
				ESX.ShowNotification('~g~~h~Progeso finalizado')
				TriggerServerEvent('esx_methcar:finish', quality)
				FreezeEntityPosition(LastCar, false)
			end	
			
		end
		
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			else
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('Se acabo el Yodo')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)		
		if pause == true then
			if IsControlJustReleased(0, Keys['1']) then
				selection = 1
				ESX.ShowNotification('~g~Secciona la opcion 1')
			end
			if IsControlJustReleased(0, Keys['2']) then
				selection = 2
				ESX.ShowNotification('~g~Selecciona la opcion 2')
			end
			if IsControlJustReleased(0, Keys['3']) then
				selection = 3
				ESX.ShowNotification('~g~Selecciona la opcion 3')
			end
		end

	end
end)




