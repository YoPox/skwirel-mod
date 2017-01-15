local Skwirel = RegisterMod("Skwirel", 1)
local game = Game()
local MIN_FIRE_DELAY = 5

local itemID = {
  BYDLO = Isaac.GetItemIdByName("Mini Bydl0"),
  RIPTO = Isaac.GetItemIdByName("Mini Riptogamer"),
  SKAMA = Isaac.GetItemIdByName("Mini Skama"),
  SOUCI = Isaac.GetItemIdByName("Mini Soucisse"),
  YOPOX = Isaac.GetItemIdByName("Mini YoPox")
}

local effects = {
  RIPTO_DMG = 0.5,
  RIPTO_TEARS = 0.5,
  SKAMA_TEARS = 0.5,
  SKAMA_SSPEED = 1,
  SOUCI_SPEED = 0.3,
  SOUCI_TEARS = 0.5,
  SOUCI_SSPEED = 0.25
}

local function bit(p)
  return 2 ^ (p - 1)  -- 1-based indexing
end

local function hasbit(x, p)
  return x % (p + p) >= p
end

local function setbit(x, p)
  return hasbit(x, p) and x or x + p
end

local function clearbit(x, p)
  return hasbit(x, p) and x - p or x
end

-- When passive effects should update
function Skwirel:onUpdate(player)
  if game:GetFrameCount() == 1 then
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.BYDLO, Vector(150, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.RIPTO, Vector(230, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.SKAMA, Vector(310, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.SOUCI, Vector(390, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.YOPOX, Vector(470, 280), Vector(0, 0), nil)
  end
end

Skwirel:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Skwirel.onUpdate)

-- When cache is updated
function Skwirel:onCache(player, cacheFlag)

  if cacheFlag == CacheFlag.CACHE_DAMAGE then
    if player:HasCollectible(itemID.RIPTO) then
      player.Damage = player.Damage + effects.RIPTO_DMG
    end
  end

  if cacheFlag == CacheFlag.CACHE_SPEED then
    if player:HasCollectible(itemID.SOUCI) then
      player:SetColor(Color(0.03, 0.83, 0.03, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
      player.MoveSpeed = player.MoveSpeed + effects.SOUCI_SPEED
    end
  end

  if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
    if player:HasCollectible(itemID.SOUCI) then
      player.ShotSpeed = player.ShotSpeed + effects.SOUCI_SSPEED
    end
  end

  if cacheFlag == CacheFlag.CACHE_TEARFLAG then
    if player:HasCollectible(itemID.RIPTO) then
      player:SetColor(Color(0.85, 0.34, 0.0, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
      player.TearFlags = setbit(player.TearFlags, bit(2))
    end
  end

end

Skwirel:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Skwirel.onCache);
