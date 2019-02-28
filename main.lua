local Skwirel = RegisterMod("Skwirel", 1)
local game = Game()

local itemID = {
  BYDLO = Isaac.GetItemIdByName("Mini Bydl0"),
  RIPTO = Isaac.GetItemIdByName("Mini Riptaud"),
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

-- External item descriptions
if not __eidItemDescriptions then         
  __eidItemDescriptions = {};
end

__eidItemDescriptions[itemID.BYDLO] = "\1 +0.2 Speed #5% Charm tears #White skin"
__eidItemDescriptions[itemID.SKAMA] = "\1 +0.04 Damage (flat) per room explored #Red and yellow tears"
__eidItemDescriptions[itemID.RIPTO] = "\1 +0.25 Damage #Yellow piercing tears #Orange skin"
__eidItemDescriptions[itemID.SOUCI] = "\1 +0.25 Speed #\1 +0.25 Shot speed  #1% Corrupted tears (black tears with a random effect)"
__eidItemDescriptions[itemID.POCEB] = "\1 +3 Soul hearts #\1 +1 Tears  #Blue tears"
__eidItemDescriptions[itemID.PCRGE] = "\2 -1 Health down #\1 +0.55 Damage  #Red tears"
__eidItemDescriptions[itemID.QPLSH] = "70% Probability to spawn a pickup until it fails. #Pickups can be : #- coin (38%) #- bomb (19%) #- key (19%) #- heart (14,25%) #- bag (4,75%) #- chest (3,75%) #- locked chest (1%) #- collectible (0,25%)"

local possessItem = {
  RIPTO = false,
  SOUCI = false,
  YOPOX = false,
  BYDLO = false,
  SKAMA = false,
  PCRGE = false,
  POCEB = false
}

local effects = {
  BYDLO_SPEED = 0.2,
  BYDLO_CHARM_PROBA = 0.05,

  RIPTO_DMG = 0.25,

  SKAMA_SSPEED = 0.15,
  SKAMA_ROOM_BONUS = 0.04,
  
  PCRGE_DMG = 0.55,

  SOUCI_SPEED = 0.25,
  SOUCI_SSPEED = 0.25,

  YOPOX_LUCK = 1.5,

  POCEB_TEARS = 1,

  PCRGE_TEARS = 0.2
}

local lastCount = 0
local roomCount = 0

TearFlags = {
  FLAG_PIERCING = 1<<1,
  FLAG_POISONING = 1<<4,
  FLAG_CHARMING = 1<<13,
  FLAG_FIRE = 1<<22
}

local function reset()
  for k,v in pairs(possessItem) do
    possessItem[k] = false
  end
  roomCount = 0
  lastCount = 0
  stats:RemoveCache("BASE DMG")
  stats:RemoveCache("FLAT DMG")
  stats:RemoveCache("BASE TEARS")
  stats:RemoveCache("BASE SPD")
  stats:RemoveCache("BASE SSPD")
  stats:RemoveCache("BASE LUCK")
end

function Skwirel:onUpdate(player)
  if game:GetFrameCount() == 0 then
    reset()
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.SOUCI, Vector(150, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.RIPTO, Vector(230, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.SKAMA, Vector(310, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.BYDLO, Vector(390, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.YOPOX, Vector(470, 280), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.POCEB, Vector(470, 350), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.QPLSH, Vector(390, 350), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.ARTHR, Vector(310, 350), Vector(0, 0), nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID.PCRGE, Vector(230, 350), Vector(0, 0), nil)
    stats:AddCache(Skwirel.CacheBaseDmg, CacheFlag.CACHE_DAMAGE, StatStage.BASE, "BASE DMG")
    stats:AddCache(Skwirel.CacheFlatDmg, CacheFlag.CACHE_DAMAGE, StatStage.FLAT, "FLAT DMG")
    stats:AddCache(Skwirel.CacheBaseTears, CacheFlag.CACHE_FIREDELAY, StatStage.BASE, "BASE TEARS")
    stats:AddCache(Skwirel.CacheBaseSpd, CacheFlag.CACHE_SPEED, StatStage.BASE, "BASE SPD")
    stats:AddCache(Skwirel.CacheBaseSSpd, CacheFlag.CACHE_SHOTSPEED, StatStage.BASE, "BASE SSPD")
    stats:AddCache(Skwirel.CacheBaseLuck, CacheFlag.CACHE_LUCK, StatStage.BASE, "BASE LUCK")
  end

  if player:HasCollectible(itemID.YOPOX) and not possessItem.YOPOX then
    possessItem.YOPOX = true
    player:AddCollectible(itemID.TECHNOLOGY, 0, true)
  end

  if player:HasCollectible(itemID.SOUCI) and not possessItem.SOUCI then
    player:SetColor(Color(0.03, 0.83, 0.03, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
    possessItem.SOUCI = true
  end

  if player:HasCollectible(itemID.BYDLO) and not possessItem.BYDLO then
    player:SetColor(Color(1, 1, 1, 1.0, 50, 50, 50), 0, 0, false, false)
    possessItem.BYDLO = true
  end

  if player:HasCollectible(itemID.RIPTO) and not possessItem.RIPTO then
    player:SetColor(Color(0.85, 0.34, 0.0, 1.0, 0.0, 0.0, 0.0), 0, 0, false, false)
    player.TearColor = Color(1, 1, 0.1, 1, 0, 0, 0)
    player.TearFlags = player.TearFlags | TearFlags.FLAG_PIERCING
    possessItem.RIPTO = true
  end

  if player:HasCollectible(itemID.PCRGE) and not possessItem.PCRGE then
    player:AddMaxHearts(-2, false)
    player.TearColor = Color(1, 0.1, 0.1, 1, 0, 0, 0)
    possessItem.PCRGE = true
  end
  
  if player:HasCollectible(itemID.SKAMA) and not possessItem.SKAMA then
    possessItem.SKAMA = true
  end

  if player:HasCollectible(itemID.POCEB) and not possessItem.POCEB then
    player:AddSoulHearts(6)
    player.TearColor = Color(0.6, 0.6, 1, 1, 0, 0, 0)
    possessItem.POCEB = true
  end

end

function Skwirel:CacheBaseDmg(player)
  if player:HasCollectible(itemID.RIPTO) then
    player.Damage = player.Damage + effects.RIPTO_DMG
  end
  if player:HasCollectible(itemID.PCRGE) then
    player.Damage = player.Damage + effects.PCRGE_DMG
  end
end

function Skwirel:CacheFlatDmg(player)
  if player:HasCollectible(itemID.SKAMA) then
  player.Damage = player.Damage + effects.SKAMA_ROOM_BONUS * roomCount
  end
end

function Skwirel:CacheBaseTears(player)
  if player:HasCollectible(itemID.POCEB) then
    player.MaxFireDelay = player.MaxFireDelay + 0.7*1000
  end
end

function Skwirel:CacheBaseSpd(player, cacheFlag)
  if player:HasCollectible(itemID.SOUCI) then
    player.MoveSpeed = player.MoveSpeed + effects.SOUCI_SPEED
  end
  if player:HasCollectible(itemID.BYDLO) then
    player.MoveSpeed = player.MoveSpeed + effects.BYDLO_SPEED
  end
end

function Skwirel:CacheBaseSSpd(player, cacheFlag)
  if player:HasCollectible(itemID.SOUCI) then
    player.ShotSpeed = player.ShotSpeed + effects.SOUCI_SSPEED
  end
end

function Skwirel:CacheBaseLuck(player, cacheFlag)
  if player:HasCollectible(itemID.YOPOX) then
    player.Luck = player.Luck + effects.YOPOX_LUCK
  end
end

local function RandomCollectible()
  if math.random() <= 0.95 then
    -- Pickup
    local nb = math.random()
    if nb <= 0.4 then
      return PickupVariant.PICKUP_COIN
    elseif nb <= 0.6 then
      return PickupVariant.PICKUP_BOMB
    elseif nb <= 0.8 then
      return PickupVariant.PICKUP_KEY
    elseif nb <= 0.95 then
      return PickupVariant.PICKUP_HEART
    else
      return PickupVariant.PICKUP_GRAB_BAG
    end
    
  else
    local nb = math.random()
    if nb <= 0.05 then
      -- Collectible
      return PickupVariant.PICKUP_COLLECTIBLE
    elseif nb <= 0.25 then
      -- Golden chest
      return PickupVariant.PICKUP_LOCKEDCHEST
    else
      return PickupVariant.PICKUP_CHEST
    end
  end

end

function Skwirel:ActivateQuiplash(_Type, RNG)
  local player = Isaac.GetPlayer(0)
  local happy = false
  while math.random() > 0.3 do
    local angle = math.random() * 3.14159
    Isaac.Spawn(EntityType.ENTITY_PICKUP, RandomCollectible(), 0, player.Position, Vector(math.cos(angle) * 6, math.sin(angle) * 6), nil)
    happy = true
  end
  if happy then
    player:AnimateHappy()
  else
    player:AnimateSad()
  end
end

function Skwirel:onFire(tear)
  local player = Isaac.GetPlayer(0)

  if player:HasCollectible(itemID.RIPTO) then
    tear:ChangeVariant(11)
  end

  if player:HasCollectible(itemID.BYDLO) then
    if math.random() < effects.BYDLO_CHARM_PROBA then
      tear:SetColor(Color(1, 0.2, 0.8, 1, 25, 25, 25), 10000, 0, true, false)
      tear.TearFlags = tear.TearFlags | TearFlags.FLAG_CHARMING
    end
  end

  if player:HasCollectible(itemID.SKAMA) then
    if math.random() < 0.5 then
      tear:SetColor(Color(1, 0.2, 0.2, 1, 0, 0, 0), 10000, 0, true, false)
    else
      tear:SetColor(Color(0.8, 0.8, 0.2, 1, 0, 0, 0), 10000, 0, true, false)
    end
  end

  if player:HasCollectible(itemID.SOUCI) then
    if math.random() < 0.01 then
      tear:SetColor(Color(0, 0, 0, 1, 15, 15, 15), 10000, 0, true, false)
      tear.TearFlags = tear.TearFlags | (1 << math.floor(math.random() * 55))
    end
  end

end

function Skwirel:onRoom()
  local player = Game():GetPlayer(0)
  if Game():GetRoom():IsFirstVisit() and player:HasCollectible(itemID.SKAMA) then
    roomCount = roomCount + 1
  end
end

-- CALLBACKS

-- items
Skwirel:AddCallback(ModCallbacks.MC_USE_ITEM, Skwirel.ActivateQuiplash, itemID.QPLSH)

-- flags
Skwirel:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Skwirel.onUpdate)
Skwirel:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Skwirel.onFire)
Skwirel:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Skwirel.onRoom)
