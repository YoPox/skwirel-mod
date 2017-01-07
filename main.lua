local skwirel = RegisterMod("Skwirel")
local acorn_item = Isaac.GetItemIdByName("Acorn")

function skwirel:use_acorn()
  local player = Isaac.GetPlayer(0)
	-- random number
	local effect = math.random(0, 4)
	if effect == 0 then -- damage
		--body...
	end
end

skwirel:AddCallback(ModCallbacks.MC_USE_ITEM, skwirel.use_acorn, acorn_item);
