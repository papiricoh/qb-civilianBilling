QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData() -- Setting this for when you restart the resource in game


local function canBill(job)
    for _, aJob in pairs(Config.Jobs) do
        if job == aJob then
            return true
        end
    end
    return false
end

function GetPlayersNearby(cb)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local activePlayers = GetActivePlayers()
    local count = #activePlayers
    if count == 0 then
        cb(players)  -- No hay jugadores cerca, devuelve lista vacía
        return
    end

    for _, playerId in ipairs(activePlayers) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)

        --playerPed ~= targetPed and 
        if playerPed ~= targetPed and distance <= 10.0 then
            QBCore.Functions.TriggerCallback('qb-civilianBilling:Server:getPlayer', function(playerData)
                table.insert(players, {citizenid = playerData.citizenid, distance = distance, first_name = playerData.first_name, last_name = playerData.last_name})
                count = count - 1
                if count == 0 then
                    cb(players) 
                end
            end, GetPlayerServerId(playerId))
        else
            count = count - 1
            if count == 0 then
                cb(players)
            end
        end
    end
end

local function openBilling()
    QBCore.Functions.TriggerCallback('qb-civilianBilling:Server:getBills', function(result)
        PlayerData = QBCore.Functions.GetPlayerData()
        SendNUIMessage({
            action = 'openProgram',
            bills = result,
            canBill = canBill(PlayerData.job.name) and PlayerData.job.onduty
        })
        SetNuiFocus(true, true)
    end)
end


RegisterNUICallback('closeApp', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('getPlayersNearby', function(data, cb)
    local citizenId = data.citizenid
    if(PlayerData.citizenid ~= citizenId) then
        cb(false)
        return
    end
    GetPlayersNearby(function(players)
        cb(players)
    end)
end)


RegisterNUICallback('newBill', function(data, cb)
    local citizenId = data.user_id
    if(PlayerData.citizenid ~= citizenId) then
        cb(false)
        return
    end
    print(json.encode(data))
    QBCore.Functions.TriggerCallback('qb-civilianBilling:Server:addBill', function(allOk)
        if allOk then
            cb(true)
        else
            cb(false)
        end
    end, data)
end)


RegisterNUICallback('pay', function(data, cb)
    local bill = data.bill
    local citizenId = data.citizenid
    if(PlayerData.citizenid == citizenId) then
        QBCore.Functions.TriggerCallback('qb-civilianBilling:Server:checkPay', function(hasFunds)
            if hasFunds then
                cb(true)
            else
                cb(false)
            end
        end, { id = bill.id, quantity = bill.quantity, title = bill.title})
    end
end)

RegisterNetEvent('qb-civilianBilling:client:close', function()
    closeBilling()
end)

RegisterNetEvent('qb-civilianBilling:client:open', function()
    openBilling()
end)
