local squapi = require("SquAPI")

-- hide vanilla model
vanilla_model.PLAYER:setVisible(false)

-- set players skin to their own skin
models.model.root:setPrimaryTexture("SKIN")

-- global vars ==========================================================================================

-- Basic Action Animations
AnimSwing1 = animations.model["animation.model.swing1"]
AnimSwing2 = animations.model["animation.model.swing2"]
AnimSwingCombo = animations.model["animation.model.swingCombo"]
AnimIdle = animations.model["animation.model.idle"]
AnimWalk = animations.model["animation.model.walk"]
AnimCrouch = animations.model["animation.model.crouch"]
AnimUnCrouch = animations.model["animation.model.unCrouch"]
AnimHitGround = animations.model["animation.model.hitGround"]

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

-- Helper Functions =====================================================================================

-- Stop playing all animations pertaining to combat
function StopAllSpell()
    AnimSwing1:stop()
    AnimSwing2:stop()
    AnimSwingCombo:stop()
    AnimR1:stop()
    AnimR2:stop()
    AnimL2:stop()
    AnimFirstSpell:stop()
    AnimSecondSpell:stop()
    AnimThirdSpell:stop()
    AnimMovement:stop()
end

-- Given what animations that need to play, check which one to play under certain conditions on a left click
function CheckAnimToPlayLeftClick(r1, r2, l2, swing1, swing2, swingCombo, secondSpell, thirdSpell)
    if (l2:isPlaying() and not secondSpell:isPlaying()) then        -- R1, L2, s2
        StopAllSpell()
        secondSpell:play()
    elseif (r2:isPlaying() and not thirdSpell:isPlaying()) then    -- R1, R2, s3
        StopAllSpell()
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
        StopAllSpell()
        firstSpell:play()
    elseif (r2:isPlaying() and not movement:isPlaying()) then                                -- R1, R2, Movement
        StopAllSpell()
        movement:play()
    elseif (r1:isPlaying() and not r2:isPlaying()) then                                     -- R1, R2
        r2:play()
    elseif (not r1:isPlaying() and not r2:isPlaying() and not movement:isPlaying()) then -- R1
        r1:play()
    end
end

-- Given what animation to play, play it without interference of other animations and with small delay
function PlaySpellWithDelay(spell)
    StopAllSpell()
    spell:setStartDelay(0.3)
    spell:play()
    spell:setStartDelay(0)
end

-- left-clicking detection ==============================================================================
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


-- right-clicking detection =============================================================================
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

-- Key Bind detection (wynntils macros) =================================================================

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

-- SquAPI Animation Handling ============================================================================

-- squapi.walk(AnimWalk)
squapi.smoothHead(models.model.root.mainBody.head, 0.4, 1, false)
squapi.smoothTorso(models.model.root.mainBody, 0.5)
squapi.crouch(AnimCrouch, AnimUnCrouch)

-- tick event, called 20 times per second ===============================================================
function events.tick()
    local crouching = player:getPose() == "CROUCHING"
    local swimming = player:isVisuallySwimming()
    local floating = player:isInWater()
    local sprinting = player:isSprinting()
    local walking = player:getVelocity().xz:length() > .001
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

    if player:getPose()=="CROUCHING" then
        models.model:setPos(0,2,0)
    else
        models.model:setPos(0,0,0)
    end

    -- if player:getVehicle() and player:getVehicle():getType() == "minecraft:horse" then
    --     print("ridingHorse")
    -- end

    -- if (climbing) then
    --     print("climbing")
    -- end

    -- if (floating and not swimming) then
    --     print("floating")
    -- elseif (swimming) then
    --     print("swimming")
    -- end

    -- if (crouching and walking) then
    --     print("crouch walking")
    -- elseif (crouching and not walking) then
    --     print("crouching")
    -- elseif (walking and not crouching and not sprinting) then
    --     print("walking")
    -- elseif (sprinting) then
    --     print("sprinting")
    -- elseif (not walking and not crouching) then

    --     print("idle")
    -- end


    AnimIdle:setPlaying(not walking and not crouching)
    -- AnimWalk:setPlaying(walking and not crouching and not sprinting)
    -- animations.example.sprint:setPlaying(sprinting and not crouching)
    -- animations.example.crouch:setPlaying(crouching)
end

-- Physics variables ====================================================================================
local stiff = 0.025
local bounce = 0.06
local bendability = 2
local rArm = squapi.bounceObject:new()
local lArm = squapi.bounceObject:new()
local head = squapi.bounceObject:new()

local currVel
local oldVel
local acceleration

function events.entity_init()
    currVel = player:getVelocity()
    oldVel = player:getVelocity()
    acceleration = player:getVelocity()
end

-- "delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
-- "context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context) ------------------------------------------------------------------
    local crouching = player:getPose() == "CROUCHING"
    local swimming = player:isVisuallySwimming()
    local floating = player:isInWater()
    local sprinting = player:isSprinting()
    local walking = player:getVelocity().xz:length() > .001
    local climbing = player:isClimbing()
    local riding 

    -- Deal with first person hand model ----------------------------------------
    vanilla_model.RIGHT_ARM:setVisible(context == "FIRST_PERSON")

    -- Physics handling ---------------------------------------------------------
    local vel = squapi.getForwardVel()
	local yvel = squapi.yvel()
    local headRot = (models.model.root.mainBody.head:getOffsetRot()+180)%360-180

    -- Idle Arms affected by gravity --------------------------------------------
    if (not walking and not crouching and (headRot[1] > -20)) then
        models.model.root.mainBody.rightArm:setOffsetRot(-headRot[1],0,0)
        models.model.root.mainBody.leftArm:setOffsetRot(-headRot[1],0,0)
    end

    -- acceleration -------------------------------------------------------------
    if (currVel ~= oldVel) then
        acceleration = currVel - oldVel
    end
    currVel = player:getVelocity()
    -- print(currVel[2], acceleration[2])

    -- Arm physics --------------------------------------------------------------
    -- print(rArm.pos)
	-- if rArm.pos < 90 and rArm.pos >= 0 then
    --     if (rArm.pos < 0.1) then
    --         rArm.pos = rArm.pos*(0.5)
    --     end
	-- 	rArm.vel = rArm.vel - yvel/2 * 10
	-- 	rArm.vel = rArm.vel - vel/3 * 10
	-- end
    -- /////////////////
    local yvel = squapi.yvel()
    if (yvel ~= 0) then
        models.model.root.mainBody.rightArm:setRot(0, 0, rArm.pos*2)
        models.model.root.mainBody.leftArm:setRot(0, 0, -lArm.pos*2)
    end
	local target = -yvel * 110
    print(target)
	if (target > 40) then
        target = 40
    elseif (target < 0) then
        target = 0
    end
	rArm:doBounce(target, 0.01, .2)
    lArm:doBounce(target, 0.01, .2)
    -- /////////////////


    -- Head physics -------------------------------------------------------------
    -- print(yvel)
    if head.pos < 20 and head.pos > -30 then
		head.vel = head.vel - yvel/2 * 3
		head.vel = head.vel - vel/3 * 3
	end

    -- Hitting ground detection -------------------------------------------------
    if (world.getBlockState(player:getPos():add(0,-0.1,0)):isSolidBlock() and (currVel[2] == 0 and acceleration[2] ~= currVel[2])) then
        -- print(acceleration[2])
        if (acceleration[2] < -0.24) then
            AnimHitGround:play()
        end
        acceleration[2] = 0
        
    end

    -- Render given physics onto body parts -------------------------------------
	-- models.model.root.mainBody.rightArm:setOffsetRot(rArm.vel*2,0,rArm:doBounce(0, stiff, bounce))
    -- models.model.root.mainBody.leftArm:setOffsetRot(-rArm.vel*2,0,-rArm:doBounce(0, stiff, bounce))
    models.model.root.mainBody.head:setRot(head:doBounce(0, 0.025, 0.12),0,0)
end