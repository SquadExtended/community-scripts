--- Simple SquadLink Lua to send a system message to everyone on the server when somebody joins & two basics admin commands: !pos, !clearvehicles

local Events = SquadLink.GetEvents()
local Server = SquadLink.GetServerManager()

-- Broadcast join messages
Events:OnPlayerJoin(function(player)
    local name = player:GetName()
    local green = FLinearColor(0, 1, 0, 1)
    Server:SendMessageToAll(name .. " has joined.", green, ESQNotificationTypes.Positive)
end)

-- Basic Admin Commands
Events:OnChatMessage(function(player, message)
    if message == "!pos" then
        local soldier = player:GetSoldier()
        if soldier then
            local loc = soldier:GetActorLocation()
            player:SendMessage("Your Pos: " .. tostring(loc), nil, ESQNotificationTypes.Message)
        end
    end
    
    -- Admin only: Kill all vehicles
    if message == "!clearvehicles" and player:IsAdmin() then
        local vehicles = SquadLink.GetWorldManager():GetAllVehicles()
        for _, v in ipairs(vehicles) do
            v:Destroy()
        end
        player:SendMessage("Vehicles cleared.", nil, ESQNotificationTypes.Warning)
    end
end)
