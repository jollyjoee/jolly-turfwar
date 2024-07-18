local Territories = {}
local Captured = {}
local CapturedZones = {}
local Blips = {}
local Peds = {}
local ZonesAdded = {}
local insidePoint = false
local activeZone = nil
local QBCore = exports['qb-core']:GetCoreObject()
for k, v in pairs(Zones['Territories']) do
    Captured[k] = v.captured
end
local capzone = true
isLoggedIn = false
PlayerGang = {}
PlayerJob = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(JobInfo)
    PlayerJob = JobInfo
    isLoggedIn = true
end)

CreateThread(function()
    Wait(1000)
    TriggerEvent('turfwar:client:start')
end)

CreateThread(function()
    Wait(500)
    for k, v in pairs(Zones["Territories"]) do
        local name = "greenzone-"..k
        local zone = CircleZone:Create(v.centre, v.radius, {
            name = name,
            debugPoly = Zones["Config"].debug,
        })
        table.insert(ZonesAdded, name)
        createblip(v.centre.x, v.centre.y, v.centre.z, Zones["Default"][v.winner].color, v.radius, v.blip, Zones["Default"][v.winner].name)
        Territories[k] = {
            zone = zone,
            id = k,
            blip = blip,
        }
    end
end)

function createblip(x, y, z, color, radius, sprite, winner)
    CreateThread(function()
    local blip1 = AddBlipForRadius(x, y, z, radius)
    SetBlipAlpha(blip1, 80)
    SetBlipColour(blip1, color)
    table.insert(Blips, blip1)
    local blip2 = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip2, sprite)
    SetBlipDisplay(blip2, 4)
    SetBlipScale(blip2, 0.8)
    SetBlipAsShortRange(blip2, true)
    SetBlipColour(blip2, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(winner)
    EndTextCommandSetBlipName(blip2)
    table.insert(Blips, blip2)
    end)
end

RegisterNetEvent("turfwar:client:updateblips", function(zone, winner, id)
    Captured[id] = true
    table.insert(CapturedZones, id)
    local bliplabel = "Turf of "..QBCore.Shared.Gangs[winner].label
    local defaultname = Zones['Default']['neutral'].name
    local winningcolor = QBCore.Shared.Gangs[winner].color
    TriggerEvent("turfwar:client:reward", zone, winner)
    for _, v in pairs(Blips) do
        RemoveBlip(v)
    end
    for k, v in pairs(Zones["Territories"]) do
        if table.contains(CapturedZones, k) then
            createblip(v.centre.x, v.centre.y, v.centre.z, winningcolor, v.radius, v.blip, bliplabel)
        else
            createblip(v.centre.x, v.centre.y, v.centre.z, defaultname.color, v.radius, v.blip, defaultname)
            local name = "greenzone-"..k
            local zone = CircleZone:Create(v.centre, v.radius, {
                name = name,
                debugPoly = Zones["Config"].debug,
            })
            table.insert(ZonesAdded, name)
            Territories[k] = {
                zone = zone,
                id = k,
                blip = blip
            }
        end
    end
end)

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end

function isContested(tab)
    local count = 0
    for k, v in pairs(tab) do
        count = count + 1
    end

    if count > 1 then
        return "contested"
    end
    return ""
end

RegisterNetEvent("turfwar:client:start", function()
    CreateThread(function()
        while capzone == true do 
            Wait(500)
            if isLoggedIn then
                local PlayerPed = PlayerPedId()
                local pedCoords = GetEntityCoords(PlayerPed)
                for k, v in pairs(Zones["Territories"]) do
                    while isContested(v.occupants) == "contested" do
                        for i,v in pairs((v.occupants)) do
                            last = #(v.occupants) - 0
                        end
                    end
                end 
                for k, v in pairs(Territories) do  
                    if Territories[k].zone:isPointInside(pedCoords) then
                        insidePoint = true
                        activeZone = Territories[k].id
                        while insidePoint do   
                            if not Captured[activeZone] then
                                if PlayerGang.name ~= "none" then
                                    TriggerServerEvent("turfwar:server:updateterritories", activeZone, true, isCaptured) 
                                end  
                            else
                                --capzone = false
                                insidePoint = false
                            end
                            if not Territories[k].zone:isPointInside(GetEntityCoords(PlayerPed)) then
                                if PlayerGang.name ~= "none" then
                                    TriggerServerEvent("turfwar:server:updateterritories", activeZone, false, isCaptured)
                                end
                                insidePoint = false
                                activeZone = nil
                                QBCore.Functions.Notify(Lang:t("error.leave_gangzone"), "error")
                            end
                            Wait(1000)
                        end
                    else
                        insidePoint = false
                        activeZone = nil
                    end
                end  
                Wait(2000)
            end
        end
    end)
end)

RegisterNetEvent('turfwar:client:openshop', function(zone)
    local winningzone = zone.shop
    TriggerServerEvent("jim-shops:ShopOpen", "shop", "normal", winningzone)
end)

RegisterNetEvent('turfwar:client:reward', function(zone, winner)
    TriggerServerEvent("turfwar:server:addmoney", 2000)  
    TriggerServerEvent('turfwar:server:spawnped', zone, winner)
end)

RegisterNetEvent('turfwar:client:spawnped', function(zone, winner)
    CreateThread(function()
        local model = `g_m_m_chicold_01`
        local animDict = 'anim@mp_player_intcelebrationfemale@slow_clap'
        local anim = 'slow_clap'
        RequestModel(model)
        while not HasModelLoaded(model) do
          Wait(0)
        end
        entity = CreatePed(0, model, zone.pedspawn.x, zone.pedspawn.y, zone.pedspawn.z, zone.pedheading, false, true)
        table.insert(Peds, entity)
        SetPedCanRagdoll(entity, false)
        SetPedCanRagdollFromPlayerImpact(entity, false)
        SetEntityInvincible(entity, true)
        FreezeEntityPosition(entity, true)
        SetBlockingOfNonTemporaryEvents(entity, true)
        RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end
        TaskPlayAnim(entity, animDict, anim, 8.0, 0, -1, 3, 0, 0, 0, 0)

        exports.interact:AddLocalEntityInteraction({
            entity = entity,
            id = zone, -- needed for removing interactions
            distance = 18.0, -- optional
            interactDst = 2.0, -- optional
            ignoreLos = false, -- optional ignores line of sight
            offset = vec3(0.0, 0.0, 0.0), -- optional
            groups = {
                [winner] = 0, -- Jobname | Job grade
            },
            options = {
                {
                    label = 'Black Market',
                    action = function()
                        TriggerEvent('turfwar:client:openshop', zone)
                    end,
                },
            }
        })
        --[[exports['qb-target']:AddTargetEntity(entity, { 
            options = { 
                { 
                num = 1,
                type = "client",
                event = "turfwar:client:openshop",
                args = {var1 = zone},
                icon = 'fa-solid fa-comments-dollar',
                label = "Black Market",
                gang = winner,
                }
            },
          distance = 2.5, 
        })]]
    end)
end)

local function remove()
    for _, v in pairs(Peds) do
        DeletePed(v)
    end
    for _, v in pairs(ZonesAdded) do
        exports['qb-target']:RemoveZone(v)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    remove()
  end)

