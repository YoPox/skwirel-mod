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
  PCRGE = Isaac.GetItemIdByName("Pouce Rouge"),
  -- non mod items
  TECHNOLOGY = Isaac.GetItemIdByName("Technology")
}

local possessItem = {
  RIPTO = false,
  SOUCI = false,
  YOPOX = false,
  PCRGE = false
}

local effects = {
  RIPTO_DMG = 0.5,
  RIPTO_TEARS = 1,

  SKAMA_DMG = 1,
  SKAMA_SSPEED = 0.15,

  SOUCI_SPEED = 0.3,
  SOUCI_SSPEED = 0.25,
  SOUCI_TEARS = 1,

  YOPOX_LUCK = 1.5,

  BYDLO_SPEED = 0.2,

  POCEB_TEARS = 0.4,

  PCRGE_DMG = 0.2,
  PCRGE_TEARS = 0.2
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

TearFlags = {
  FLAG_PIERCING = 1<<1,
  FLAG_POISONING = 1<<4,
  FLAG_CHARMING = 1<<13,
  FLAG_FIRE = 1<<22
}

local function resetPossessedItems()
  possessItem.RIPTO = false
  possessItem.SOUCI = false
  possessItem.YOPOX = false
end

-- When passive effects should update
function Skwirel:onUpdate(player)
  if game:GetFrameCount() == 1 then
    resetPossessedItems()
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

  if player:HasCollectible(itemID.YOPOX) and not possessItem.YOPOX then
    possessItem.YOPOX = true
    player:AddCollectible(itemID.TECHNOLOGY, 0, true)
  end

  if player:HasCollectible(itemID.SOUCI) and not possessItem.SOUCI then
    possessItem.SOUCI = true
  end

  if player:HasCollectible(itemID.RIPTO) and not possessItem.RIPTO then
    possessItem.RIPTO = true
  end

end

-- When cache is updated
function Skwirel:onCache(player, cacheFlag)
  if cacheFlag == CacheFlag.CACHE_DAMAGE then
    if player:HasCollectible(itemID.RIPTO) then
      player.Damage = player.Damage + effects.RIPTO_DMG
    end
    if player:HasCollectible(itemID.PCRGE) then
      player.Damage = player.Damage + effects.PCRGE_DMG
    end
    if player:HasCollectible(itemID.SOUCI) and not possessItem.SOUCI then
      player.MaxFireDelay = player.MaxFireDelay - effects.SOUCI_TEARS
    end
    if player:HasCollectible(itemID.RIPTO) and not possessItem.RIPTO then
      player.MaxFireDelay = player.MaxFireDelay - effects.RIPTO_TEARS
    end
  end

  if cacheFlag == CacheFlag.CACHE_SPEED then
    if player:HasCollectible(itemID.SOUCI) then
      player:SetColor(Color(0.03, 0.83, 0.03, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
      player.MoveSpeed = player.MoveSpeed + effects.SOUCI_SPEED
    end
    if player:HasCollectible(itemID.BYDLO) then
      player.MoveSpeed = player.MoveSpeed + effects.BYDLO_SPEED
    end
  end

  if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
    if player:HasCollectible(itemID.SKAMA) then
      player.ShotSpeed = player.ShotSpeed + effects.SKAMA_SSPEED
    end
    if player:HasCollectible(itemID.SOUCI) then
      player.ShotSpeed = player.ShotSpeed + effects.SOUCI_SSPEED
    end
  end

  if cacheFlag == CacheFlag.CACHE_LUCK then
    if player:HasCollectible(itemID.YOPOX) then
      player.Luck = player.Luck + effects.YOPOX_LUCK
    end
  end

  if cacheFlag == CacheFlag.CACHE_FLYING then
    if player:HasCollectible(itemID.SKAMA) then
      player.CanFly = true
    end
  end

  if cacheFlag == CacheFlag.CACHE_TEARFLAG then
    if player:HasCollectible(itemID.RIPTO) then
      player:SetColor(Color(0.85, 0.34, 0.0, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
      player.TearFlags = player.TearFlags | TearFlags.FLAG_PIERCING
    end
    if player:HasCollectible(itemID.BYDLO) then
      player.TearFlags = player.TearFlags | TearFlags.FLAG_CHARMING
    end
    if player:HasCollectible(itemID.PCRGE) then
      player.TearFlags = player.TearFlags | TearFlags.FLAG_FIRE
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
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p1], 0, player.Position, Vector(6, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p2], 0, player.Position, Vector(-6, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p3], 0, player.Position, Vector(0, 6), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, quiplash_possible_spawn[p4], 0, player.Position, Vector(0, -6), nil)
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
