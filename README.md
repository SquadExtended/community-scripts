# SquadLink Community Scripts

This repository is a central library for server-side Lua scripts built for SquadLink. It contains administrative tools, community-made gamemodes, and utility scripts that extend the base Squad experience.

### Using these scripts
To use any of the scripts found here, download the `.lua` file and place it into your server's SquadLink `scripts` directory. The runtime environment will automatically detect new files and load them. If you are updating an existing script, the changes will be applied instantly via live-reloading.

### Contributing
We encourage users to share their own creations. To contribute, please submit a pull request with your script. We ask that you keep your code readable and include a brief comment at the top of the file explaining its purpose and any specific requirements.

---

### Script Collection
* **[scripts](scripts/)**
  Contains all official scripts developed by SquadLink

### Featured Script: Spawn Race Vehicle
This script allows any player to spawn a vehicle by typing `!race` in the chat. It demonstrates how to load game assets and spawn actors relative to a player's current position.

**Code**
```lua
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
```
