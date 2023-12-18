-- Hide vanilla model
vanilla_model.PLAYER:setVisible(false)

-- Set players skin to their own skin
models.model.root:setPrimaryTexture("SKIN")

-- Get model type
local pModel
function events.entity_init() --=====================================================================================================================
    if (player:getModelType() == "DEFAULT") then
        print("default type")
        -- models.model.rootDefault:setVisible(true)
        -- models.model.rootSlim:setVisible(false)
        -- pModel = models.model.rootDefault
    else
        print("slim type")
        -- models.model.rootDefault:setVisible(false)
        -- models.model.rootSlim:setVisible(true)
        -- pModel = models.model.rootSlim
    end
end

-- global vars ==========================================================================================

-- Animation states
local state
local oldState
local fallTick = 0
local idleTick = 0
local jump = 1

-- BlockBench model parts
local modelHead = models.model.root.mainBody.head
local modelMainBody = models.model.root.mainBody
local modelRightArm = models.model.root.mainBody.rightArm
local modelLeftArm = models.model.root.mainBody.leftArm

-- Basic Action Animations
AnimIdle = animations.model["animation.model.idle"]
-- AnimIdling1 = animations.model[""]
-- AnimIdling2 = animations.model[""]
AnimWalk = animations.model["animation.model.walk"]
AnimCrouch = animations.model["animation.model.crouch"]
AnimUnCrouch = animations.model["animation.model.unCrouch"]
AnimHitGround = animations.model["animation.model.hitGround"]
AnimJumpMove1 = animations.model["jumpMoving1"]
AnimJumpMoveStop1 = animations.model["jumpMovingStoping1"]
AnimJumpMove2 = animations.model["jumpMoving2"]
AnimJumpMoveStop2 = animations.model["jumpMovingStoping2"]

-- Attacks
AnimSwing1 = animations.model["animation.model.swing1"]
AnimSwing2 = animations.model["animation.model.swing2"]
AnimSwingCombo = animations.model["animation.model.swingCombo"]

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

-- Better isGrounded function (curtosy of @Discord User: 4P5)
local CLEARANCE = 0.1 -- How many blocks you can hover above the ground and still be considered touching it
local function isOnGround(entity)
    local pos = entity:getPos()
    local hitbox = entity:getBoundingBox().x_z / 2
    local min = pos - hitbox - vec(0, CLEARANCE, 0)
    local max = pos + hitbox
    local search_min = min:copy():floor()
    local search_max = max:copy():floor()
    for x = search_min.x, search_max.x do
        for y = search_min.y, search_max.y do
            for z = search_min.z, search_max.z do
                local block_pos = vec(x,y,z)
                local block = world.getBlockState(block_pos)
                local boxes = block:getCollisionShape()
                for i = 1, #boxes do
                    local box = boxes[i]
                    local box1_min = box[1] + block_pos
                    local box1_max = box[2] + block_pos
                    if not (box1_max.x <= min.x or max.x <= box1_min.x or
                            box1_max.y <= min.y or max.y <= box1_min.y or
                            box1_max.z <= min.z or max.z <= box1_min.z) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Given which jump to play, play that particular jump. returns next jump value
function WhichJump(j, j1Anim, j2Anim)
    if (j == 1) then
        j1Anim:play()
        return 2
    end
    j2Anim:play()
    return 1
end

-- left-clicking detection ==============================================================================
local hitKey = keybinds:of("Punch",keybinds:getVanillaKey("key.attack"))

function pings.onHitDo()
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()

    -- Spears --
    if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
        return
    end

    -- Wands --
    if (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
        return
    end

    -- Daggers --
    if (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
        return
    end

    -- Reliks --
    if (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
        CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AnimSwing1, AnimSwing2, AnimSwingCombo, AnimSecondSpell, AnimThirdSpell)
        return
    end

    -- Bows --
    if (string.find(currItemStack, "Archer/Hunter") ~= nil) then
        -- use opposite click for archer
        CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
        return
    end

    -- Holding none weapon --
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
    end -- hold down button to attack?

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

local squapi = require("SquAPI")
squapi.smoothHead(modelHead, 0.4, 1, false)
squapi.smoothTorso(modelMainBody, 0.5)
squapi.crouch(AnimCrouch, AnimUnCrouch)

-- tick event, called 20 times per second
function events.tick() --============================================================================================================================
    local crouching = player:getPose() == "CROUCHING"
    local swimming = player:isVisuallySwimming()
    local floating = player:isInWater()
    local sprinting = player:isSprinting()
    local walking = player:getVelocity().xz:length() > .001
    local climbing = player:isClimbing()
    local isGrounded = isOnGround(player)
    local sitting = player:getVehicle()
    local ridingMount = player:getVehicle() and (player:getVehicle():getType() == "minecraft:horse"
                                            or player:getVehicle():getType() == "minecraft:pig")
    local ridingSeat = player:getVehicle() and (player:getVehicle():getType() == "minecraft:minecart"
                                            or player:getVehicle():getType() == "minecraft:boat")

    -- Attack animation priorities ----------------------------------------------
    AnimSwing1:setPriority(1)
    AnimSwing2:setPriority(2)
    AnimSwingCombo:setPriority(3)
    AnimMovement:setPriority(4)
    AnimFirstSpell:setPriority(4)
    AnimSecondSpell:setPriority(4)
    AnimThirdSpell:setPriority(4)

    -- Basic action animation prioirites ----------------------------------------
    -- AnimIdling1:setPriority(1)
    -- AnimIdling2:setPriority(1)

    -- AnimWalk:setPriority(1)
    -- AnimSprinting:setPriority(1)
    -- AnimSprinting:setPriority(1)
    -- AnimFalling:setPriority(2)
    -- AnimJumping:setPriority(2)
    -- AnimSwimming:setPriority(3)
    -- AnimFloating:setPriority(3)
    -- AnimClimbing:setPriority(4)
    -- AnimRidingHorse:setPriority(4)

    -- Play animation under certain conditions ----------------------------------

    -- Handle crouch model position
    if (crouching) then
        models.model:setPos(0,2,0)
    else
        models.model:setPos(0,0,0)
    end

    -- Interacting with water
    if (floating or swimming) then
        if (floating and not swimming and isGrounded) then
            state = "floatIdle"
        elseif (floating and not swimming and not isGrounded) then
            state = "floatingAir"
        elseif (swimming) then
            state = "swimming"
        end
    else
        -- Outside of water
        if (isGrounded) then
            -- On the ground
            if (crouching and not walking) then
                state = "crouching"
            elseif (crouching and walking) then
                state = "crouch walking"
            elseif (walking and not crouching and not sprinting and not climbing) then
                state = "walking"
            elseif (sprinting) then
                state = "sprinting"
            elseif (not walking and not crouching) then
                state = "idle"
                AnimIdle:play()
            end
        else
            -- Not on the ground
            if (climbing) then
                -- Interacting with ladder
                if (player:getVelocity()[2] ~= 0) then
                    state = "climbing"
                else
                    state = "holdingLadder"
                end
            elseif (sitting ~= nil) then
                -- Sitting/Riding
                if (ridingMount and walking) then
                    state = "ridingMount"
                elseif (ridingSeat and walking) then
                    state = "ridingCartOrBoat"
                elseif (not walking and (ridingMount or ridingSeat)) then
                    state = "sitting"
                end
            else
                state = "inAir"
            end
        end
    end

    -- Jumping conditions
    if (state ~= oldState) then
        if (oldState == "sprinting" and state == "inAir") then
            -- Jump sprinting
            jump = WhichJump(jump, AnimJumpMove1, AnimJumpMove2)
        -- elseif (oldState == "walking" and state == "inAir") then
        --     -- Jump walking
        --     jump = WhichJump(jump, AnimJumpMove1, AnimJumpMove2)
        -- elseif (oldState == "crouching" and state == "inAir") then
        --     -- Jump crouching
        --     jump = WhichJump(jump, AnimJumpMove1, AnimJumpMove2)
        -- elseif (oldState == "crouch walking" and state == "inAir") then
        --     -- Jump crouch walking
        --     jump = WhichJump(jump, AnimJumpMove1, AnimJumpMove2)
        -- elseif (oldState == "idle" and state == "inAir") then
        --     -- Jump idle
        --     jump = WhichJump(jump, AnimJumpMove1, AnimJumpMove2)
        elseif (AnimJumpMove1:isPlaying()) then
            AnimJumpMove1:stop()
            AnimJumpMoveStop1:play()
        elseif (AnimJumpMove2:isPlaying()) then
            AnimJumpMove2:stop()
            AnimJumpMoveStop2:play()
        end
    end

    -- Falling conditions
    if (state == "inAir" or state == "falling") then
        fallTick = fallTick + 1
        if (fallTick > 16) then
            state = "falling"
            fallTick = 16
        end
    else
        fallTick = 0
    end

    -- Idling
    local rand
    if (state == "idle") then
        idleTick = idleTick + 1
        if (idleTick == 100) then
            rand = math.floor(math.random() + 0.5)
            if (rand == 0) then
                print("play1")
            else
                print("play2")
            end
            idleTick = 0
        end
    else
        idleTick = 0
    end

    -- print("---")
    -- print(state)

    oldState = state

    -- AnimIdle:setPlaying(not walking and not crouching)
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

-- initial phys calculations
function events.entity_init() --=====================================================================================================================
    -- Get initial velocity
    currVel = player:getVelocity()
    oldVel = player:getVelocity()
    acceleration = player:getVelocity()
end

-- "delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
-- "context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context) --============================================================================================================
    local crouching = player:getPose() == "CROUCHING"
    local walking = player:getVelocity().xz:length() > .001

    -- Deal with first person hand model ----------------------------------------
    vanilla_model.RIGHT_ARM:setVisible(context == "FIRST_PERSON")

    -- Physics handling ---------------------------------------------------------
    local vel = squapi.getForwardVel()
	local yvel = squapi.yvel()
    local headRot = (modelHead:getOffsetRot()+180)%360-180
    local armTarget
    local headTarget

    -- acceleration -------------------------------------------------------------
    if (currVel ~= oldVel) then
        acceleration = currVel - oldVel
    end
    currVel = player:getVelocity()

    -- Arm physics --------------------------------------------------------------
    modelRightArm:setRot(0, 0, rArm.pos*2)
    modelLeftArm:setRot(0, 0, -lArm.pos*2)
	armTarget = -yvel * 80
    if (armTarget > 40) then
        armTarget = 40
    elseif (armTarget < -5) then
        armTarget = -5
    end
	rArm:doBounce(armTarget, 0.01, .2)
    lArm:doBounce(armTarget, 0.01, .2)

    -- Idle Arms affected by gravity --------------------------------------------
    if (not walking and not crouching and (headRot[1] > -20) and isOnGround(player)) then
        modelRightArm:setOffsetRot(-headRot[1],0,0)
        modelLeftArm:setOffsetRot(-headRot[1],0,0)
    else
        modelRightArm:setOffsetRot(0,0,0)
        modelLeftArm:setOffsetRot(0,0,0)
    end -- Known Bug: reverting back to normal arms not smooth 

    -- Head physics -------------------------------------------------------------
    modelHead:setRot(head.pos*1.5, 0, 0)
	headTarget = -yvel * 20
    if (headTarget > 20) then
        headTarget = 20
    elseif (headTarget < -10) then
        headTarget = -10
    end
	head:doBounce(headTarget, 0.01, .2)


    -- Hitting ground detection -------------------------------------------------
    if (isOnGround(player) and (currVel[2] == 0 and acceleration[2] ~= currVel[2])) then
        if (acceleration[2] < -0.24) then
            AnimHitGround:play()
        end
        acceleration[2] = 0
        
    end

    -- Render given physics onto body parts -------------------------------------
	-- modelRightArm:setOffsetRot(rArm.vel*2,0,rArm:doBounce(0, stiff, bounce))
    -- modelLeftArm:setOffsetRot(-rArm.vel*2,0,-rArm:doBounce(0, stiff, bounce))
    -- modelHead:setRot(head:doBounce(0, 0.025, 0.12),0,0)
end