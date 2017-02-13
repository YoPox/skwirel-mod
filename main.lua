local Skwirel = RegisterMod("Skwirel", 1)
local game = Game()

local itemID = {
  BYDLO = Isaac.GetItemIdByName("Mini Bydl0"),
  RIPTO = Isaac.GetItemIdByName("Mini Riptogamer"),
  SKAMA = Isaac.GetItemIdByName("Mini Skama"),
  SOUCI = Isaac.GetItemIdByName("Mini Soucisse"),
  YOPOX = Isaac.GetItemIdByName("Mini YoPox"),
  QPLSH = Isaac.GetItemIdByName("Quiplash"),
  ARTHR = Isaac.GetItemIdByName("Arthurr"),
  POCEB = Isaac.GetItemIdByName("Poce Bleu"),
  PCRGE = Isaac.GetItemIdByName("Pouce Rouge")
}

local effects = {
  RIPTO_DMG = 0.5,
  RIPTO_TEARS = 0.5,
  SKAMA_TEARS = 0.5,
  SKAMA_SSPEED = 0.15,
  SOUCI_SPEED = 0.3,
  SOUCI_TEARS = 0.5,
  SOUCI_SSPEED = 0.25
}

local quiplash_possible_nb = 9
local quiplash_possible_spawn = {
  PickupVariant.PICKUP_HEART,
  PickupVariant.PICKUP_COIN,
  PickupVariant.PICKUP_BOMB,
  PickupVariant.PICKUP_KEY,
  PickupVariant.PICKUP_CHEST,
  PickupVariant.PICKUP_LOCKEDCHEST,
  PickupVariant.PICKUP_GRAB_BAG,
  PickupVariant.PICKUP_TAROTCARD,
  PickupVariant.PICKUP_TRINKET
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
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.SOUCI, Vector(150, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.RIPTO, Vector(230, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.SKAMA, Vector(310, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.BYDLO, Vector(390, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.YOPOX, Vector(470, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.POCEB, Vector(470, 350), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.QPLSH, Vector(390, 350), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.ARTHR, Vector(310, 350), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.PCRGE, Vector(230, 350), Vector(0, 0), nil)
  end
end

-- When cache is updated
function Skwirel:onCache(player, cacheFlag)

  if cacheFlag == CacheFlag.CACHE_DAMAGE then
    if player:HasCollectible(itemID.RIPTO) then
      player.Damage = player.Damage + effects.RIPTO_DMG
    end
    if player:HasCollectible(itemID.SOUCI) then
      player.MaxFireDelay = player.MaxFireDelay - effects.SOUCI_TEARS
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
    if player:HasCollectible(itemID.SKAMA) then
      player.ShotSpeed = player.ShotSpeed + effects.SKAMA_SSPEED
    end
  end

  if cacheFlag == CacheFlag.CACHE_TEARFLAG then
    if player:HasCollectible(itemID.RIPTO) then
      player:SetColor(Color(0.85, 0.34, 0.0, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
      player.TearFlags = setbit(player.TearFlags, bit(2))
    end
  end
end


function Skwirel:ActivateQuiplash(_Type, RNG)
  local player = Isaac.GetPlayer(0)
  if math.random() >= 0.5 then
    player:AnimateHappy()
    -- On choisit 4 pickups au hasard parmi quiplash_possible_spawn
    local p1 = math.random(1, quiplash_possible_nb)
    local p2 = math.random(1, quiplash_possible_nb)
    local p3 = math.random(1, quiplash_possible_nb)
    local p4 = math.random(1, quiplash_possible_nb)
    -- On spawne les pickups
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p1], 0, player.Position, Vector(4, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p2], 0, player.Position, Vector(-4, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p3], 0, player.Position, Vector(0, 4), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p4], 0, player.Position, Vector(0, -4), nil)
  else
    player:AnimateSad()
  end
end

-- CALLBACKS

-- items
Skwirel:AddCallback(ModCallbacks.MC_USE_ITEM, Skwirel.ActivateQuiplash, itemID.QPLSH)

-- flags
Skwirel:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Skwirel.onUpdate)
Skwirel:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Skwirel.onCache)
