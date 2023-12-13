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
