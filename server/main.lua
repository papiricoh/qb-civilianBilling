local QBCore = exports['qb-core']:GetCoreObject()

local function canBill(job)
    for _, aJob in pairs(Config.Jobs) do
        if job == aJob then
            return true
        end
    end
    return false
end

QBCore.Functions.CreateCallback('qb-civilianBilling:Server:getBills', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid

        MySQL.Async.fetchAll('SELECT * FROM player_bills WHERE citizenid = \'' .. citizenid .. '\';', {}, function(result)

            cb(result);
        end)
    end
end)

QBCore.Functions.CreateCallback('qb-civilianBilling:Server:checkPay', function(source, cb, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end
    local billAmount = data.quantity

    if Player.PlayerData.money.bank >= billAmount then
        MySQL.Async.execute('UPDATE player_bills SET paid = 1 WHERE id = @id', {
            ['@id'] = data.id
        }, function(affectedRows)
            Player.Functions.RemoveMoney('bank', billAmount, "Bill: " .. data.title)
            cb(true)
        end)
    else
        cb(false)
    end
end)


QBCore.Functions.CreateCallback('qb-civilianBilling:Server:addBill', function(source, cb, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end

    MySQL.Async.execute('INSERT INTO player_bills (citizenid, title, quantity) VALUES (@citizenid, @title, @quantity)', {
        ['@citizenid'] = data.citizenid,
        ['@title'] = data.title,
        ['@quantity'] = data.quantity
    }, function(affectedRows)
        cb(true)
    end)
end)
