local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("qb-clothing:saveSkin", function(model, skin)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if model ~= nil and skin ~= nil then
        MySQL.insert([[
            INSERT INTO playerskins (citizenid, model, skin, active)
            VALUES (?, ?, ?, 1)
            ON DUPLICATE KEY UPDATE model = VALUES(model), skin = VALUES(skin), active = 1
        ]], {
            Player.PlayerData.citizenid,
            model,
            skin,
        })
    end
end)

RegisterServerEvent("qb-clothes:loadPlayerSkin", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
    if result[1] ~= nil then
        TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin)
    else
        TriggerClientEvent("qb-clothes:loadSkin", src, true)
    end
end)

RegisterServerEvent("qb-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if model ~= nil and skinData ~= nil and type(outfitName) == "string" then
        outfitName = outfitName:gsub("^%s*(.-)%s*$", "%1")
        if outfitName == "" then return end
        local outfitId = ("outfit-%s-%s"):format(os.time(), math.random(100000, 999999))
        MySQL.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            outfitName,
            model,
            json.encode(skinData),
            outfitId
        }, function()
            local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
            if result[1] ~= nil then
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end
end)

RegisterServerEvent("qb-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    MySQL.query('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
        Player.PlayerData.citizenid,
        outfitName,
        outfitId
    }, function()
        local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if result[1] ~= nil then
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        cb({})
        return
    end
    local anusVal = {}

    local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            anusVal[k] = v
        end
    end
    cb(anusVal)
end)
