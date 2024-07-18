local minGangMemberConnected = 4
local QBCore = exports['qb-core']:GetCoreObject()

function checkGroup(table, val)
    for k, v in pairs(table) do
        if val == v.label then
            return true
        end
    end
    return false
end

function removeGroup(tab, val)
    for k, v in pairs(tab) do
        if v.label == val then
            tab[k] = nil
        end
    end
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


RegisterNetEvent("turfwar:server:updateterritories")
AddEventHandler("turfwar:server:updateterritories", function(zone, inside)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local isdead = Player.PlayerData.metadata['isdead']
    local isinlaststand = Player.PlayerData.metadata['inlaststand']
    local Gang = Player.PlayerData.gang
    local gangMemberConnected = 0
    Territory = Zones["Territories"][zone]
    if Territory ~= nil then
        -- If they're not in a gang or they're not a cop just ignore them
        if Gang.name ~= "none" then
            if inside and not isdead and not isinlaststand then
                if not checkGroup(Territory.occupants, Gang.name) then
                    Territory.occupants[Gang.name] = {
                        label = Gang.name,
                        score = 0
                    }
                else
                    for k, v in pairs(QBCore.Functions.GetPlayers()) do
                        local Player = QBCore.Functions.GetPlayer(v)
                        if Player ~= nil then
                            if (Player.PlayerData.gang.name == Territory.occupants[Gang.label]) then
                                gangMemberConnected = gangMemberConnected + 1
                            end
                        end
                    end
                    --if gangMemberConnected >= minGangMemberConnected then
                        local score = Territory.occupants[Gang.name].score
                        if score < Zones["Config"].minScore and Territory.winner ~= Gang.name then
                            if isContested(Territory.occupants) == "" then
                                Territory.occupants[Gang.name].score = Territory.occupants[Gang.name].score + 1
                                TriggerClientEvent('QBCore:Notify', source, "Capturing Turf. Progress "..Territory.occupants[Gang.name].score.."/"..Zones["Config"].minScore, "primary", 50)
                                if Territory.occupants[Gang.name].score == 20 then
                                    TriggerEvent('template:server:sendchatmessage', "A Turf is being captured in "..Territory.name..". Gang members, hurry up and intercept!", "fa-solid fa-skull", "Turf War", "#cccccc") --message, icon, category, color(hex)
                                elseif Territory.occupants[Gang.name].score == 100 then
                                    exports['JD_logsV3']:createLog({EmbedMessage = "Turf war start attempt", player_id = source, channel = "https://discord.com/api/webhooks/1100234812461174906/NCjRJCWFcVtmKuXbEEVLTC8s1yvJOLNp24EYHXqoRLGTkiE_iiJTm4VTWFb_G7qrpa3S", title = 'Turf War', color = '#cccccc', icon = '❗❗' })
                                end
                            else
                                TriggerClientEvent('QBCore:Notify', source, "You are being contested by another gang! Kill them all!", "error", 50)
                            end
                        else
                            Territory.winner = Gang.name
                            TriggerEvent('template:server:sendchatmessage', Gang.label.." succesfully captured "..Territory.name.." Turf. A special item seller has visited them.", "fa-solid fa-skull", "Turf War", "#cccccc") --message, icon, category, color(hex)
                            TriggerClientEvent("turfwar:client:updateblips", source, Territory, Gang.name, zone)                
                            Wait(1000)
                        end
                    --end
                   
                end
            else
                removeGroup(Territory.occupants, Gang.name)
            end
        end
    end
end)

RegisterNetEvent("turfwar:server:addmoney", function(amount)
    for k, t in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(t)
        local Gang = Player.PlayerData.gang
        if Gang.label == Territory.winner then
            Player.Functions.AddMoney('cash', amount)
        end
    end
end)

RegisterNetEvent('turfwar:server:spawnped', function(zone, winner)
    TriggerClientEvent('turfwar:client:spawnped', -1, zone, winner)
end)
