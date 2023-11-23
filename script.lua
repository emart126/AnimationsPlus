local squapi = require("SquAPI")

-- hide vanilla model
vanilla_model.PLAYER:setVisible(false)

-- set players skin to their own skin
models.model.root:setPrimaryTexture("SKIN")

-- global vars

-- Basic Action Animations
AnimSwing1 = animations.model["animation.model.swing1"]
AnimSwing2 = animations.model["animation.model.swing2"]
AnimSwingCombo = animations.model["animation.model.swingCombo"]
AnimIdle = animations.model["animation.model.idle"]
AnimWalk = animations.model["animation.model.walk"]
AnimCrouch = animations.model["animation.model.crouch"]
AnimUnCrouch = animations.model["animation.model.unCrouch"]

-- Wynncraft Spells
-- R1, L2, R3 = s1
-- R1, L2, L3 = s2
-- R1, R2, L3 = s3
-- R1, R2, R3 = Move

AnimMovement = animations.model["animation.model.movement"]
AnimThirdSpell = animations.model["animation.model.ThirdSpell"]
AnimSecondSpell = animations.model["animation.model.SecondSpell"]
AnimFirstSpell = animations.model["animation.model.FirstSpell"]

AnimR1 = animations.model["animation.model.R1"]
AnimR2 = animations.model["animation.model.R2"]
AnimL2 = animations.model["animation.model.L2"]

-- Helper Functions -------------------------------------------------------------------------------------

-- Given what animations that need to play, check which one to play under certain conditions on a left click
function CheckAnimToPlayLeftClick(r1, r2, l2, swing1, swing2, swingCombo, secondSpell, thirdSpell)
    if (l2:isPlaying() and not secondSpell:isPlaying()) then        -- R1, L2, s2
        animations:stopAll()
        secondSpell:play()
    elseif (r2:isPlaying() and not thirdSpell:isPlaying()) then    -- R1, R2, s3
        animations:stopAll()
        thirdSpell:play()
    elseif (r1:isPlaying() and not l2:isPlaying()) then             -- R1, L2
        l2:play()
    elseif (swing2:isPlaying() and not swingCombo:isPlaying()) then
        swingCombo:play()
    elseif (swing1:isPlaying() and not swing2:isPlaying() and not swingCombo:isPlaying()) then
        swing2:play()
    elseif (not swing1:isPlaying() and not swing2:isPlaying() and not swingCombo:isPlaying()) then
        AnimSwing1:play()
    end
end

-- Given what animations that need to play, check which one to play under certain conditions on a right click
function CheckAnimToPlayRightClick(r1, r2, l2, firstSpell, movement)
    if (l2:isPlaying() and not r2:isPlaying()) then                                         -- R1, L2, s1
        animations:stopAll()
        firstSpell:play()
    elseif (r2:isPlaying() and not movement:isPlaying()) then                                -- R1, R2, Movement
        animations:stopAll()
        movement:play()
    elseif (r1:isPlaying() and not r2:isPlaying()) then                                     -- R1, R2
        r2:play()
    elseif (not r1:isPlaying() and not r2:isPlaying() and not movement:isPlaying()) then -- R1
        r1:play()
    end
end

-- Given what animationto play, play it without interference of other animations and with small delay
function PlaySpellWithDelay(spell)
    animations:stopAll()
    spell:setStartDelay(0.3)
    spell:play()
    spell:setStartDelay(0)
end

-- left-clicking detection ------------------------------------------------------------------------------
local hitKey = keybinds:of("Punch",keybinds:getVanillaKey("key.attack"))

function pings.onHitDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    -- Spears --
    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
    end

    -- Wands --
    if (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
    end

    -- Daggers --
    if (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
    end

    -- Reliks --
    if (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
    end

    -- Bows --
    if (string.find(currItemStack, "Archer/Hunter") ~= nil) then
        -- use opposite click for archer
        CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
    end

    -- empty hands --
    if (currItem.id == "minecraft:air") then
        -- print("punch")
    end

end

hitKey.press = pings.onHitDo


-- right-clicking detection -----------------------------------------------------------------------------
local useKey = keybinds:of("Use",keybinds:getVanillaKey("key.use"))

function pings.onRightClickDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    -- Spears --
    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
    end

    -- Wands --
    if (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
    end

    -- Daggers --
    if (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
    end

    -- Reliks --
    if (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
    end

    -- Bows --
    if (string.find(currItemStack, "Archer/Hunter") ~= nil) then
        -- use opposite click for archer
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
    end

end

useKey.press = pings.onRightClickDo

-- Key Bind detection (wynntils macros) -----------------------------------------------------------------

function pings.onZPressDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        PlaySpellWithDelay(AnimFirstSpell)
    elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        PlaySpellWithDelay(AnimFirstSpell)
    elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        PlaySpellWithDelay(AnimFirstSpell)
    elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        PlaySpellWithDelay(AnimFirstSpell)
    end
end

function pings.onXPressDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        PlaySpellWithDelay(AnimMovement)
    elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        PlaySpellWithDelay(AnimMovement)
    elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        PlaySpellWithDelay(AnimMovement)
    elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        PlaySpellWithDelay(AnimMovement)
    end
end

function pings.onCPressDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        PlaySpellWithDelay(AnimSecondSpell)
    elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        PlaySpellWithDelay(AnimSecondSpell)
    elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        PlaySpellWithDelay(AnimSecondSpell)
    elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        PlaySpellWithDelay(AnimSecondSpell)
    end
end

function pings.onVPressDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        PlaySpellWithDelay(AnimThirdSpell)
    elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        PlaySpellWithDelay(AnimThirdSpell)
    elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        PlaySpellWithDelay(AnimThirdSpell)
    elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        PlaySpellWithDelay(AnimThirdSpell)
    end
end

local zKey = keybinds:of("Z","key.keyboard.z")
local xKey = keybinds:of("X","key.keyboard.x")
local cKey = keybinds:of("C","key.keyboard.c")
local vKey = keybinds:of("V","key.keyboard.v")
zKey.press = pings.onZPressDo
xKey.press = pings.onXPressDo
cKey.press = pings.onCPressDo
vKey.press = pings.onVPressDo

-- SquAPI Animation Handling ----------------------------------------------------------------------------

-- squapi.walk(AnimWalk)
squapi.smoothHead(models.model.root.mainBody.mainHead, 0.4)
squapi.smoothTorso(models.model.root.mainBody, 0.5)
squapi.crouch(AnimCrouch, AnimUnCrouch)

-- tick event, called 20 times per second ---------------------------------------------------------------
function events.tick()
  local crouching = player:getPose() == "CROUCHING"
  local swimming = player:isVisuallySwimming()
  local floating = player:isInWater()
  local sprinting = player:isSprinting()
  local walking = player:getVelocity().xz:length() > .001
  local jumping = player:getVelocity().y > .01
  local falling = player:getVelocity().y < -0.4
  local climbing = player:isClimbing()
  local riding 

  -- Attack animation priorities
  AnimSwing1:setPriority(1)
  AnimSwing2:setPriority(2)
  AnimSwingCombo:setPriority(3)
  AnimMovement:setPriority(4)
  AnimFirstSpell:setPriority(4)
  AnimSecondSpell:setPriority(4)
  AnimThirdSpell:setPriority(4)

  -- Basic action animation prioirites
  -- AnimWalk:setPriority(1)
  -- AnimSprinting:setPriority(1)
  -- AnimSprinting:setPriority(1)
  -- AnimFalling:setPriority(2)
  -- AnimJumping:setPriority(2)
  -- AnimSwimming:setPriority(3)
  -- AnimFloating:setPriority(3)
  -- AnimClimbing:setPriority(4)
  -- AnimRidingHorse:setPriority(4)

  -- Play animation under certain conditions

  if player:getVehicle() and player:getVehicle():getType() == "minecraft:horse" then
    print("ridingHorse")
  end

  if (climbing) then
      print("climbing")
  end

  if (floating and not swimming) then
      print("floating")
  elseif (swimming) then
      print("swimming")
  end

  if (jumping and not swimming) then
      print("jumping")
  elseif (falling and not swimming) then
      print("falling")
  end

  if (crouching) then
      print("crouching")
  elseif (walking and not crouching and not sprinting) then
      print("walking")
  elseif (sprinting) then
      print("sprinting")
  elseif (not walking and not crouching) then
      print("idle")
  end


  AnimIdle:setPlaying(not walking and not crouching)
--   AnimWalk:setPlaying(walking and not crouching and not sprinting)
  -- animations.example.sprint:setPlaying(sprinting and not crouching)
  -- animations.example.crouch:setPlaying(crouching)
end


-- render event, called every time your avatar is rendered
-- it have two arguments, "delta" and "context"
-- "delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
-- "context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context) ------------------------------------------------------------------
      
end
