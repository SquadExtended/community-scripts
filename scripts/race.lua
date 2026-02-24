--- Simple SquadLink Race Lua script that spawns and enters a vehicle when !race is sent in any chats.


local Events = SquadLink.GetEvents()
local WorldManager = SquadLink.GetWorldManager()

-- Define the asset path for the vehicle
local RACE_VEHICLE_PATH = "/Game/Vehicles/Sprut-SDM1/BP_Sprut.BP_Sprut_C"
local vehicleClass = SquadLink.LoadAsset(RACE_VEHICLE_PATH)

if not vehicleClass then
    print("ERROR: Could not load race vehicle asset: " .. RACE_VEHICLE_PATH)
end

function OnChatMessage(player, message)
    -- Only trigger if the player types !race and the asset is loaded
    if message:lower() ~= "!race" or not vehicleClass then
        return
    end

    local soldier = player:GetSoldier()

    if not soldier then
        player:SendMessage("You must be spawned in to start a race!", nil, ESQNotificationTypes.Error)
        return
    end

    -- Calculate spawn position 2 meters in front of the player
    local spawnPos = soldier:GetActorLocation()
    local spawnRot = soldier:GetActorRotation()
    local forward = soldier:GetActorForwardVector()
    
    spawnPos.X = spawnPos.X + (forward.X * 200)
    spawnPos.Y = spawnPos.Y + (forward.Y * 200)

    local vehicle = WorldManager:SpawnActor(vehicleClass, spawnPos, spawnRot)

    if not vehicle then
        player:SendMessage("Failed to spawn the race vehicle.", nil, ESQNotificationTypes.Error)
        return
    end
    
    print("Spawned race vehicle for " .. player:GetName())
    player:SendMessage("Your race vehicle has arrived!", nil, ESQNotificationTypes.Positive)
end

Events:OnChatMessage(OnChatMessage)
print("Race command script loaded.")
