local Skwirel = RegisterMod("Skwirel", 1)
local game = Game()

local itemID = {
    RIPTO = Isaac.GetItemIdByName("Riptogamer")
}

local hasItem = {
    Ripto = false
}

local effects = {
    RIPTO_DMG = 0.5,
    RIPTO_TEARS = 0.5
}

-- Update the inventory
local function UpdateItems(player)
    hasItem.Ripto = player:hasCollectible(itemID.RIPTO)
end

-- When the run starts or continues
function Skwirel:onPlayerInit(player)
    UpdateItems(player)
end

Skwirel:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Skwirel.onPlayerInit)

-- When passive effects should update
function Skwirel:onUpdate(player)
    if game:GetFrameCount() == 1 then
        Isaac.spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.RIPTO, Vector(320, 300), Vector(0, 0), nil)
    end
    UpdateItems(player)
end

Skwirel:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Skwirel.onUpdate)

-- When cache is updated
function Skwirel:onCache(player, cacheFlag)
    if cacheFlag == cacheFlag.CACHE_DAMAGE then
        if player:hasCollectible(itemID.RIPTO) and not hasItem.Ripto then
            player.Damage = player.Damage + effects.RIPTO_DMG
        end
    end
    UpdateItems(player)
end

Skwirel:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Skwirel.onCache);
