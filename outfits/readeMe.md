
You **MUST** ensure to modify any instance calling the "qb-clothing:client:loadPlayerClothing" function. Make sure to provide a **CID** (Client ID) and **character model** to load. Use this to load the given CID clothing !

Example : 

    local PlayerData = QBCore.Functions.GetPlayerData()
    local cid = PlayerData.cid
    local charPed = PlayerPedId()

    TriggerEvent('qb-clothing:client:loadPlayerClothing', cid, charPed)


# Please add this to your server/resource.cfg
ensure exter-polyzone
ensure exter-clothing
ensure Sobing-outfits

