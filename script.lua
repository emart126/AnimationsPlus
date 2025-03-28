-- ///////////////////////////////////////////////////////////////// --
--                          Wynn Extra Bends
--                              Vance568
--                               v1.2-dev
--
--   Helper Library Authors: Jimmy H., GrandpaScout, Squishy, Katt962
-- ///////////////////////////////////////////////////////////////// --

local squapi = require("SquAPI")
local squassets = require("SquAssets")
local GSBlend = require("GSAnimBlend")

local anims = require("EZAnims")
anims:setOneJump(true)
local animModel = anims:addBBModel(animations.model)
animModel:setBlendTimes(2,2)
animModel:addExcluOverrider(animations.model["freeFall"])
animModel:addIncluOverrider(animations.model["Taunt_2"], animations.model["Taunt_3"])

-- Hide vanilla model
vanilla_model.PLAYER:setVisible(false)

-- Global Variables =====================================================================================

-- Pinged/Synced Values
local oldWeaponClass
local weaponClass
local isActionWheelOpen
local wheelCheck
local oldWheelCheck

-- Settings
local sheathOption = true;
local idleAnimations = true;

-- Animation states/ticks
local idleTick = 0
local randTick = 400
local randAnim

local rightLeg = false
local wasSprintJup = false
local wasSprintJDown = false
local isSprintJup
local isSprintJDown

local fallTimer = 0
local startFallTime = 0
local startedFall = false
local yVel = 0
local oldYVel = 0

local facing
local oldFacing

local blendClimb = true
local blendClimbDone = false
local climbBlendInRot
local climbBlendOutRot

local blendClimbTop = false
local climbTopBlendInRot
local climbTopBlendOutRot

local readyTimer = 0
local readyStartTime = 0
local readyState = false
local readyStarted = false

-- BlockBench model parts
local pModel = models.model.Player
local modelHead = pModel.Upper.head
local modelMainBody = pModel.Upper
local modelRightArm = pModel.Upper.body.Arms.Arm_R
local modelLeftArm = pModel.Upper.body.Arms.Arm_L

-- Get model type
function events.entity_init() --=====================================================================================================================
    if (player:getModelType() == "DEFAULT") then
        modelLeftArm.Bicep_Default_L:setVisible(true)
        modelLeftArm.Bicep_Slim_L:setVisible(false)
        modelLeftArm.Elbow_L.Limb_Default_L:setVisible(true)
        modelLeftArm.Elbow_L.Limb_Slim_L:setVisible(false)

        modelRightArm.Bicep_Default_R:setVisible(true)
        modelRightArm.Bicep_Slim_R:setVisible(false)
        modelRightArm.Elbow_R.Limb_Default_R:setVisible(true)
        modelRightArm.Elbow_R.Limb_Slim_R:setVisible(false)
    else
        modelLeftArm.Bicep_Default_L:setVisible(false)
        modelLeftArm.Bicep_Slim_L:setVisible(true)
        modelLeftArm.Elbow_L.Limb_Default_L:setVisible(false)
        modelLeftArm.Elbow_L.Limb_Slim_L:setVisible(true)

        modelRightArm.Bicep_Default_R:setVisible(false)
        modelRightArm.Bicep_Slim_R:setVisible(true)
        modelRightArm.Elbow_R.Limb_Default_R:setVisible(false)
        modelRightArm.Elbow_R.Limb_Slim_R:setVisible(true)
    end
end

-- Set players skin to their own skin
pModel:setPrimaryTexture("SKIN")

-- Basic Action Animations ==============================================================================
AnimIdle = animations.model["idling"]
AnimReady = animations.model["toggleidling"]
AnimReady:setBlendTime(2, 3.5)
AnimIdling1 = animations.model["Idle_1"]
AnimIdling1:setBlendTime(2, 4)
AnimIdling2 = animations.model["Idle_2"]
AnimIdling2:setBlendTime(2, 4)
AnimIdling3 = animations.model["Idle_3"]
AnimIdling3:setBlendTime(2, 4)

AnimWalk = animations.model["walking"]
AnimCrouching = animations.model["crouching"]
AnimCrouching:setBlendTime(4)
AnimUnCrouchJUp = animations.model["crouchjumpup"]
AnimUnCrouchJUp:setBlendTime(4)
AnimCrouchJDown = animations.model["crouchjumpdown"]
AnimCrouchJDown:setBlendTime(5)
AnimCrouchWalk = animations.model["crouchwalk"]
AnimCrouchWalk:setBlendTime(4)

AnimCrawl = animations.model["crawlstill"]
AnimCrawling = animations.model["crawling"]

AnimFloat = animations.model["water"]
AnimFloat:setBlendTime(4)
AnimSwim = animations.model["swimming"]
AnimSwim:setBlendTime(4)

AnimClimb = animations.model["climbing"]
AnimClimb:setBlendTime(4)
AnimClimbCrouch = animations.model["climbcrouch"]
AnimClimbCrouch:setBlendTime(4)
AnimClimbCrouchWalk = animations.model["climbcrouchwalk"]
AnimClimbCrouchWalk:setBlendTime(4)

AnimJumpingUp = animations.model["jumpingup"]
AnimJumpingUp:setBlendTime(4, 5)
AnimJumpingUp:setBlendCurve("easeOutQuad")
AnimJumpingDown = animations.model["jumpingdown"]
AnimJumpingDown:setBlendTime(4, 5)
AnimJumpingDown:setBlendCurve("easeOutQuad")
AnimSprintJumpUp = animations.model["sprintjumpup"]
AnimSprintJumpUp:setBlendTime(6.5)
AnimSprintJumpDown = animations.model["sprintjumpdown"]
AnimSprintJumpDown:setBlendTime(6.5, 3)

AnimShortFalling = animations.model["Fall_0"]
AnimShortFalling:setBlendTime(2)
AnimFreeFalling = animations.model["freeFall"]
AnimFreeFalling:setBlendTime(4, 3)
AnimLand = animations.model["land"]
AnimLand:setBlendTime(1)

AnimSprint = animations.model["sprinting"]

AnimSit = animations.model["sitpass"]
AnimHorseSit = animations.model["sitting"]
AnimHorseRiding = animations.model["sitmove"]

AnimTaunt1 = animations.model["Taunt_1"]
AnimTaunt2a = animations.model["Taunt_2"]
AnimTaunt2b = animations.model["Taunt_3"]
AnimTaunt3 = animations.model["Taunt_4"]
AnimTaunt4 = animations.model["Taunt_5"]
AnimTaunt1:setBlendTime(3, 4)
AnimTaunt2a:setBlendTime(2, 4)
AnimTaunt2b:setBlendTime(2, 4)
AnimTaunt3:setBlendTime(2, 4)
AnimTaunt4:setBlendTime(2, 4)

-- Attacks ----------------------------------------------------------

AnimPunch = animations.model["attackR"]
AnimPunch:setBlendTime(1, 2.5)
AnimMine = animations.model["mineR"]
AnimMine:setBlendTime(1)
AnimBowShootHold = animations.model["bowR"]
AnimCrossBowLoad = animations.model["loadR"]
AnimCrossBowHold = animations.model["crossbowR"]

-- Warrior ------
WarriorSwing1 = animations.model["Spear_Swing_1"]
WarriorSwing2 = animations.model["Spear_Swing_2"]
WarriorSwing3 = animations.model["Spear_Swing_3"]
WarriorSwing1:setBlendTime(1)
WarriorSwing2:setBlendTime(1)
WarriorSwing3:setBlendTime(1)

-- Mage ---------
MageSwing1 = animations.model["Wand_Wave_1"]
MageSwing2 = animations.model["Wand_Wave_2"]
MageSwing3 = animations.model["Wand_Wave_3"]
MageSwing1:setBlendTime(1)
MageSwing2:setBlendTime(1)
MageSwing3:setBlendTime(1)

-- Assassin -----
AssassinSwing1 = animations.model["Sword_Swing_1"]
AssassinSwing2 = animations.model["Sword_Swing_2"]
AssassinSwing3 = animations.model["Sword_Swing_3"]
AssassinSwing4 = animations.model["Sword_Swing_4"]
AssassinSwing1:setBlendTime(2, 3)
AssassinSwing2:setBlendTime(2, 3)
AssassinSwing3:setBlendTime(2, 3)
-- AssassinSwing4:setBlendTime(2, 3)

-- Shaman -------
ShamanSwing = animations.model["Relik_Strike"]
ShamanSwing:setBlendTime(1)

-- Archer -------
ArcherShoot = animations.model["Bow_Shoot"]
ArcherShoot:setBlendTime(1)

-- Wynncraft Spells -------------------------------------------------
-- R1, L2, R3 = s1
-- R1, L2, L3 = s2
-- R1, R2, L3 = s3
-- R1, R2, R3 = Move

-- AnimR1 = animations.model["R1"]
-- AnimR2 = animations.model["R2"]
-- AnimL2 = animations.model["L2"]

-- AnimMovement = animations.model["animation.model.movement"]
-- AnimThirdSpell = animations.model["spell3"]
-- AnimSecondSpell = animations.model["spell2"]
-- AnimFirstSpell = animations.model["animation.model.FirstSpell"]

-- Katt Armor Handling ==================================================================================
local kattArmor = require("KattArmor")()
kattArmor.Armor.Helmet
-- the `addParts` function is not strict with the number of ModelParts provided. Add or remove parts as desired.
    :addParts(
        pModel.Upper.head.Helmet,
        pModel.Upper.head.HelmetHat
    )
kattArmor.Armor.Chestplate
    :addParts(
      pModel.Upper.body.Chestplate,
      pModel.Upper.body.Arms.Arm_R.RightArmArmor,
      pModel.Upper.body.Arms.Arm_L.LeftArmArmor
    )
kattArmor.Armor.Leggings
    :addParts(
      pModel.Upper.body.Belt,
      pModel.Lower.Leg_R.RightLeggingsArmor,
      pModel.Lower.Leg_R.Knee_R.RightAnkleArmor,
      pModel.Lower.Leg_L.LeftLeggingsArmor,
      pModel.Lower.Leg_L.Knee_L.LeftAnkleArmor
    )
kattArmor.Armor.Boots
    :addParts(
      pModel.Lower.Leg_R.Knee_R.RightBootArmor,
      pModel.Lower.Leg_L.Knee_L.LeftBootArmor
    )

-- Pings ================================================================================================
function pings.syncHeldItemIsWeapon(strClass)
    weaponClass = strClass
end

function pings.syncAcitonWheel(bool)
    isActionWheelOpen = bool
end

-- Helper Functions =====================================================================================

-- Better isGrounded function with small fence fix (curtosy of @Discord User: 4P5)
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

    local blockBelow = world.getBlockState(player:getPos():add(0,-0.51,0)).id
    local i, j
    i, j = string.find(blockBelow, "fence")
    if (i ~= nil and j ~= nil) then
        return true
    end
    i, j = string.find(blockBelow, "wall")
    if (i ~= nil and j ~= nil) then
        return true
    end

    return false
end

-- Is Player Taunting
local function IsTaunting()
    if (AnimTaunt1:isPlaying() or AnimTaunt3:isPlaying() or AnimTaunt4:isPlaying()) then
        return true
    end
    return false
end

-- Check if itemStack has a class identified with it
local function CheckClassItem(item)
    if (item == nil) then
        return(nil)
    end

    if (string.find(item, "Warrior/Knight") ~= nil) then
        return("Warrior/Knight")
    elseif (string.find(item, "Mage/Dark Wizard") ~= nil) then
        return("Mage/Dark Wizard")
    elseif (string.find(item, "Assassin/Ninja") ~= nil) then
        return("Assassin/Ninja")
    elseif (string.find(item, "Shaman/Skyseer") ~= nil) then
        return("Shaman/Skyseer")
    elseif (string.find(item, "Archer/Hunter") ~= nil) then
        return("Archer/Hunter")
    end
    return(nil)
end

-- Given what animations that need to play, check which one to play under certain conditions on a left click
local function CheckAnimToPlayLeftClick(swing1, swing2, swing3, swing4)
    if (swing2 ~= nil and swing3 ~= nil) then
        -- Forth swing
        if (swing4 ~= nil and swing3:isPlaying() and not swing4:isPlaying()) then
            swing3:stop()
            swing4:play()
        -- Three swing combo attack
        elseif (swing2:isPlaying() and not swing3:isPlaying()) then
            swing2:stop()
            swing3:play()
        elseif (swing1:isPlaying() and not swing2:isPlaying() and not swing3:isPlaying()) then
            swing1:stop()
            swing2:play()
        elseif (not swing1:isPlaying() and not swing2:isPlaying() and not swing3:isPlaying()) then
            swing1:play()
        end
    else
        -- One swing attack
        swing1:play()
    end
end

-- Get random number between 400 and 600 that is also divisible by 80
local function GetRandIdleTick()
    local num = math.random(400, 600)
    while (num % 80 ~= 0) do
        num = math.random(400, 600)
    end
    return(num)
end

-- Check if given number is in array
local function NumInArray(num, arr)
    for i=1, #arr do
        if (num == arr[i]) then
            return true
        end
    end
    return false
end

-- Reset Idle tick
local function ResetIdle()
    idleTick = 0
    AnimIdling1:stop()
    AnimIdling2:stop()
    AnimIdling3:stop()
    AnimTaunt1:stop()
    AnimTaunt3:stop()
    AnimTaunt4:stop()
end

-- right-clicking detection =============================================================================
local useKey = keybinds:of("Use",keybinds:getVanillaKey("key.use"))
function pings.onRightClickDo()
    ResetIdle()

    if (not isActionWheelOpen) then
        if (weaponClass == "Archer/Hunter") then
            CheckAnimToPlayLeftClick(ArcherShoot)
        end
    end
end
useKey.press = pings.onRightClickDo

-- Render animation conditions by in game ticks
function events.tick() --============================================================================================================================

    -- Item Use Priority --------------------------------------------------------
    AnimBowShootHold:setPriority(player:isUsingItem() and 1 or 0)
    AnimCrossBowLoad:setPriority(player:isUsingItem() and 1 or 0)
    AnimCrossBowHold:setPriority((player:isUsingItem()) and 1 or 0)

    -- Handle crouch model position ---------------------------------------------
    if (player:getPose() == "CROUCHING") then
        pModel:setPos(0,2,0)
    else
        pModel:setPos(0,0,0)
    end

    -- Handle Helmet/Hat visibility ---------------------------------------------
    if (string.find(player:getItem(6).id, "helmet") ~= nil) then
        vanilla_model.ARMOR:setVisible(false)
    else
        vanilla_model.ARMOR:setVisible(true)
    end

    -- Handle Custom Attacking --------------------------------------------------

    if (player:getSwingTime() == 1 and weaponClass == "Warrior/Knight") then
        AnimPunch:stop()
        AnimMine:stop()
        CheckAnimToPlayLeftClick(WarriorSwing1, WarriorSwing2, WarriorSwing3)
    end

    if (player:getSwingTime() == 1 and weaponClass == "Mage/Dark Wizard") then
        AnimPunch:stop()
        AnimMine:stop()
        CheckAnimToPlayLeftClick(MageSwing1, MageSwing2, MageSwing3)
    end

    if (player:getSwingTime() == 1 and (weaponClass == "Assassin/Ninja" or string.find(player:getHeldItem().id, "sword"))) then
        AnimPunch:stop()
        AnimMine:stop()
        CheckAnimToPlayLeftClick(AssassinSwing1, AssassinSwing2, AssassinSwing3, AssassinSwing4)
    end

    if (player:getSwingTime() == 1 and weaponClass == "Shaman/Skyseer") then
        AnimPunch:stop()
        AnimMine:stop()
        CheckAnimToPlayLeftClick(ShamanSwing)
    end

    if (player:getSwingTime() == 1 and (weaponClass ~= nil or string.find(player:getHeldItem().id, "sword"))) then
        readyStarted = false
        readyState = true
    end

    -- Combat Ready Idle --------------------------------------------------------

    -- if (readyState) then
    --     if (not readyStarted) then
    --         readyStartTime = client:getSystemTime() / 1000
    --         readyStarted = true
    --         -- animModel:setState("toggle")
    --     end
    --     readyTimer = (client:getSystemTime() / 1000 - readyStartTime)

    --     if (readyTimer > 5) then
    --         readyState = false
    --         readyStarted = false
    --         readyTimer = 0
    --         -- animModel:setState()
    --     end
    -- end

    -- Idling -------------------------------------------------------------------
    if (idleAnimations) then
        if (AnimIdle:isPlaying()) then
            idleTick = idleTick + 1
            if (idleTick == randTick) then
                randAnim = math.random(0, 2)
                if (randAnim == 0) then
                    AnimIdling1:play()
                elseif (randAnim == 1) then
                    AnimIdling2:play()
                else
                    AnimIdling3:play()
                end
                idleTick = 0
                randTick = GetRandIdleTick()
            end
        else
            ResetIdle()
        end

        if (player:getSwingTime() ~= 0) then
            ResetIdle()
        end

        if (IsTaunting()) then
            idleTick = 0
        end
    end

    -- Scales walk/run speed animation based on player vel -------------------
    local horizontalVel = player:getVelocity().x_z:length()
    local walkSpeed = horizontalVel*4.65
    local sprintSpeed = horizontalVel*3.575
    local crouchWalkSpeed = horizontalVel*15
    -- Walking
    if (walkSpeed >= 1.5) then
        AnimWalk:setSpeed(1.5)
    elseif (walkSpeed <= 0.5) then
        AnimWalk:setSpeed(0.5)
    else
        AnimWalk:setSpeed(walkSpeed)
    end
    -- Sprinting
    if (sprintSpeed >= 1) then
        AnimSprint:setSpeed(1)
    elseif (sprintSpeed <= 0.5) then
        AnimSprint:setSpeed(0.5)
    else
        AnimSprint:setSpeed(sprintSpeed)
    end
    -- Crouch Walking
    if (crouchWalkSpeed >= 1) then
        AnimCrouchWalk:setSpeed(1)
    else
        AnimCrouchWalk:setSpeed(crouchWalkSpeed)
    end

end

-- Render animation condtions using render function
function events.render(delta, context) --============================================================================================================================

    -- Player Conditions --------------------------------------------------------
    local swimming = player:isVisuallySwimming()
    local floating = player:isInWater()
    local walking = player:getVelocity().xz:length() > .001
    local climbing = player:isClimbing()
    local isGrounded = isOnGround(player)
    local sitting = player:getVehicle()
    local ridingSeat = player:getVehicle() and (player:getVehicle():getType() == "minecraft:minecart" or player:getVehicle():getType() == "minecraft:boat")

    -- Is Action Wheel Open -----------------------------------------------------
    wheelCheck = action_wheel:isEnabled()
    if (wheelCheck ~= oldWheelCheck) then
        pings.syncAcitonWheel(wheelCheck)
    end
    oldWheelCheck = wheelCheck

    -- Held Item Wynncraft Class ------------------------------------------------
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()
    local class = CheckClassItem(currItemStack)
    if (class ~= oldWeaponClass) then
        pings.syncHeldItemIsWeapon(class)
    end
    oldWeaponClass = class

    -- Spirnt Jumping -----------------------------------------------------------
    isSprintJup = AnimSprintJumpUp:isPlaying()
    isSprintJDown = AnimSprintJumpDown:isPlaying()

    if wasSprintJup ~= isSprintJup and isSprintJup then
        rightLeg = not rightLeg
        if (rightLeg) then
            AnimSprintJumpUp:setTime(0.0)
        else
            AnimSprintJumpUp:setTime(0.3)
        end
    end
    if wasSprintJDown ~= isSprintJDown and isSprintJDown then
        AnimSprintJumpDown:setTime(AnimSprintJumpUp:getTime())
    end

    wasSprintJup = isSprintJup
    wasSprintJDown = isSprintJDown

    -- Short Fall condition -----------------------------------------------------
    if (host:isHost()) then
        if (player:getVelocity().y < 0 and AnimWalk:isPlaying()) then
            AnimShortFalling:play()
        else
            AnimShortFalling:stop()
        end
    end

    -- Falling condition --------------------------------------------------------
    local airState = not (floating or (swimming and floating)) and not isGrounded and not ridingSeat and not sitting and not climbing and not (ridingSeat and walking)
    yVel = player:getVelocity().y
    if (yVel > 0 and oldYVel < 0) then
        airState = false
    end

    if (airState) then
        if (not startedFall) then
            startFallTime = client:getSystemTime() / 1000
            startedFall = true
        end
        fallTimer = (client:getSystemTime() / 1000 - startFallTime)

        if (fallTimer > 0.75) then
            AnimFreeFalling:play()
        end
    else
        if (AnimFreeFalling:isPlaying()) then
            AnimFreeFalling:stop()
            AnimLand:play()
        end
        startedFall = false
    end

    oldYVel = yVel

    -- Climbing conditions ------------------------------------------------------
    facing = world.getBlockState(player:getPos()):getProperties()["facing"]

    local blockIsClimbable = string.find(world.getBlockState(player:getPos():add(0,0,0)).id, "vine") ~= nil or facing ~= nil
    local offBlockIsClimbable = string.find(world.getBlockState(player:getPos():add(0,0.33,0)).id, "vine") ~= nil
                            or string.find(world.getBlockState(player:getPos():add(0,0.33,0)).id, "ladder") ~= nil

    if (AnimClimb:isPlaying() or AnimClimbCrouch:isPlaying() or AnimClimbCrouchWalk:isPlaying()) then
        -- rotate player towards ladder
        local desiredRot
        if (facing == "south") then
            desiredRot = player:getBodyYaw(delta)-180
        elseif (facing == "north") then
            desiredRot = player:getBodyYaw(delta)
        elseif (facing == "west") then
            desiredRot = player:getBodyYaw(delta)+90
        elseif (facing == "east") then
            desiredRot = player:getBodyYaw(delta)-90
        else
            desiredRot = 0
        end

        if (blendClimb) then
            climbBlendInRot = 0
            blendClimb = false
        end

        climbBlendInRot = math.lerpAngle(climbBlendInRot, desiredRot, 0.075)
        if (not blendClimbDone) then
            pModel:setRot(0,climbBlendInRot,0)
        else
            pModel:setRot(0,desiredRot,0)
        end

        if (oldFacing ~= facing) then
            blendClimbDone = false
        end
        if (math.round(climbBlendInRot) == math.round(((desiredRot % 360) + 360) % 360)) then
            blendClimbDone = true
        end
        oldFacing = facing

        -- rotate upper body when at top of ladder
        -- local lowerBlock = world.getBlockState(player:getPos():add(0,0,0)).id
        local upperBlock = world.getBlockState(player:getPos():add(0,1,0)).id
        -- local lowerBlockOff = world.getBlockState(player:getPos():add(0,0.33,0)).id
        local upperBlockOff = world.getBlockState(player:getPos():add(0,1.33,0)).id
        local desiredUpperRot = 0
        if (offBlockIsClimbable and upperBlockOff == "minecraft:air") then
            if (player:getPos()[2] < 0) then
                desiredUpperRot = ((math.abs(player:getPos()[2]+0.33) % 1) * 60) - 60
            else
                desiredUpperRot = -((math.abs(player:getPos()[2]+0.33) % 1) * 60)
            end
        elseif (blockIsClimbable and upperBlock == "minecraft:air") then
            desiredUpperRot = 300
        end
        desiredUpperRot = ((desiredUpperRot % 360) + 360) % 360

        if (blendClimbTop) then
            climbTopBlendInRot = 0
            blendClimbTop = false
        end

        if (climbTopBlendInRot == nil) then
            climbTopBlendInRot = 0
        else
            climbTopBlendInRot = math.lerpAngle(climbTopBlendInRot, desiredUpperRot, 0.075)
        end
        pModel.Upper:setRot(climbTopBlendInRot,0,0)

    else
        -- blend out of rotation toward ladder
        blendClimbDone = false
        if (not blendClimb) then
            climbBlendOutRot = climbBlendInRot
            blendClimb = true
        end
        if (blendClimb and climbBlendOutRot ~= nil) then
            climbBlendOutRot = math.lerpAngle(climbBlendOutRot, 0, 0.075)
            pModel:setRot(0,climbBlendOutRot,0)
        else
            pModel:setRot(0,0,0)
        end

        -- blend upper body out of rotation at top of ladder 
        if (not blendClimbTop) then
            climbTopBlendOutRot = climbTopBlendInRot
            blendClimbTop = true
        end
        if (blendClimbTop and climbTopBlendOutRot ~= nil) then
            climbTopBlendOutRot = math.lerpAngle(climbTopBlendOutRot,0,0.075)
            pModel.Upper:setRot(climbTopBlendOutRot,0,0)
        else
            pModel.Upper:setRot(0,0,0)
        end

    end
end

-- SquAPI Animation Handling ============================================================================

squapi.smoothHead:new({modelHead, modelMainBody}, {0.6, 0.25}, 0.1, 1.75, false)

-- Physics variables ====================================================================================
local rArm = squassets.BERP:new()
local lArm = squassets.BERP:new()
local head = squassets.BERP:new()

function events.render(delta, context) --============================================================================================================

    -- First person hand model --------------------------------------------------
    if (player:isLeftHanded()) then
        vanilla_model.LEFT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.RIGHT_ARM:setVisible(false)
    else
        vanilla_model.RIGHT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.LEFT_ARM:setVisible(false)
    end

    -- Physics handling ---------------------------------------------------------
	local yvel = squassets.verticalVel()
    local xvel = squassets.forwardVel()
    local armTarget
    local headTarget

    -- Arm physics --------------------------------------------------------------
    modelRightArm:setRot(0, 0, rArm.pos*2)
    modelLeftArm:setRot(0, 0, -lArm.pos*2)
	armTarget = -yvel * 80
    if (armTarget > 30) then
        armTarget = 30
    elseif (armTarget < -3) then
        armTarget = -3
    end

    if ((xvel >= -0.22 and xvel <= 0.22) or AnimFreeFalling:isPlaying()) then
        rArm:berp(armTarget, 0.25, 0.01, 0.2)
        lArm:berp(armTarget, 0.25, 0.01, 0.2)
    else
        rArm:berp(0, 0.25, 0.01, 0.2)
        lArm:berp(0, 0.25, 0.01, 0.2)
    end

    -- Head physics -------------------------------------------------------------
    modelHead:setRot(head.pos*2, 0, 0)
    headTarget = -yvel * 20
    if (headTarget > 20) then
        headTarget = 20
    elseif (headTarget < -10) then
        headTarget = -10
    end

    -- Ignore stair/slab step
    if (headTarget > -10) then
        head:berp(headTarget, 0.25, 0.01, 0.4)
    end

end

-- Sheathing weapon
local task

local oldItemInFirst
local changedToEmpty = false

local syncedItemID
local oldItemID

local syncedPlayerSlot = 0
local oldSlot

local currWeapon
local oldWeapon

local taskRotation
local taskPosition

function pings.updateItemID(id)
    syncedItemID = id
end

function pings.updateSlot(slot)
    syncedPlayerSlot = slot
end

function pings.updateSlotKey()
    syncedPlayerSlot = 0
end

function pings.updateSlotNonZeroKey()
    syncedPlayerSlot = 1
end

function pings.updateWeaponClass(class)
    currWeapon = class
end

function pings.updateWeaponTask(vectRotX, vectRotY, vectRotZ, vecPosX, vecPosY, vecPosZ)
    taskRotation = vectors.vec3(vectRotX, vectRotY, vectRotZ)
    taskPosition = vectors.vec3(vecPosX, vecPosY, vecPosZ)
end

function events.entity_init() --=====================================================================================================================
    task = pModel.Upper.body.SheathedWeapon:newItem("weapon")
    task:setDisplayMode("THIRD_PERSON_RIGHT_HAND")
end

if (host:isHost()) then
    function events.render()

        if (sheathOption) then
            -- Sync item id and damage value
            local itemInFirst = host:getSlot(0)
            local itemInFirstStack = itemInFirst:toStackString()

            local itemID = itemInFirst.id
            local customModelData = itemInFirst["tag"]["CustomModelData"]

            if (customModelData ~= nil and customModelData.floats ~= nil) then
                customModelData = customModelData.floats[1]
                itemID = itemInFirst.id.."[custom_model_data={floats:["..customModelData.."]}]"
                local classItem = CheckClassItem(itemInFirstStack)

                -- Edit scale and rotation depending on its customModelData value
                if (classItem == "Warrior/Knight") then  -- (data = 445->507)
                    if (NumInArray(customModelData, {448, 449, 470, 473, 476})) then
                        -- Scythe
                        task:setPos(0, 15, 4)
                        task:setRot(0, 270, 50)
                        if (customModelData == 449) then -- Air Scythe
                            task:setPos(5, 15, 4)
                        end
                    elseif (NumInArray(customModelData, {475, 482, 488, 494, 497, 498, 502, 505})) then
                        -- Sword
                        task:setPos(5, 25, 4)
                        task:setRot(0, 90, 135)
                    else
                        -- Spear
                        task:setPos(0, 20, 4)
                        task:setRot(0, 90, 125)
                        if (customModelData == 503) then
                            task:setPos(0, 20, 5)
                        end
                    end
                elseif (classItem == "Mage/Dark Wizard") then  -- (data = 312->378)
                    if (NumInArray(customModelData, {323, 326, 335, 344, 349, 350, 357, 363, 366, 374})) then
                        -- Short Wand
                        task:setPos(5, 25, 4)
                        task:setRot(0, 90, 135)
                        if (customModelData == 366) then -- Lantern Wand
                            task:setPos(-3, 18, 4)
                            task:setRot(0, 270, 57)
                        end
                    else
                        -- Wand
                        task:setPos(0, 20, 4)
                        task:setRot(0, 90, 125)
                    end
                elseif (classItem == "Assassin/Ninja") then  -- (data = 246->311)
                    if (NumInArray(customModelData, {246, 247, 254, 267, 270, 285, 289, 298, 305})) then
                        -- Short Dagger
                        task:setPos(4.9, 12, -2)
                        task:setRot(120, 0, 0)
                        if (customModelData == 267) then -- Enchanted Dagger
                            task:setPos(3, 25, 4)
                            task:setRot(90, 80, 233)
                        elseif (customModelData == 270) then -- Nunchucks
                            task:setPos(4.5, 8, -2)
                            task:setRot(30, 0, 0)
                        elseif (customModelData == 289) then -- Pan
                            task:setPos(5, 25, 5)
                            task:setRot(0, 0, 130)
                        elseif (customModelData == 298) then -- Saxaphone
                            task:setPos(0, 20, 6)
                            task:setRot(45, 88, 0)
                        elseif (customModelData == 305) then -- Enchanted Sword
                            task:setPos(5, 25, 5)
                        task:setRot(0, 80, 135)
                        end
                    elseif (NumInArray(customModelData, {251, 252, 253, 257, 258, 259, 268, 279, 301, 311})) then
                        -- Front Claw
                        task:setPos(0, 20, 5.5)
                        task:setRot(90, 0, 320)
                    elseif (NumInArray(customModelData, {291, 297, 308})) then
                        -- Side Claw
                        task:setPos(0, 18, 5.5)
                        task:setRot(90, 90, 320)
                        if (customModelData == 308) then -- Tesla Claw
                            task:setPos(3, 18, 4.8)
                            task:setRot(90, 80, 320)
                        end
                    else
                        -- Dagger
                        task:setPos(5, 25, 4)
                        task:setRot(0, 90, 130)
                    end
                elseif (classItem == "Archer/Hunter") then  -- (data = 182->245)
                    if (NumInArray(customModelData, {187, 188, 189, 204, 206, 213, 234, 240, 243})) then
                        -- Crossbows
                        task:setPos(3, 20, 4)
                        task:setRot(90, 0, 315)
                        if (customModelData == 206) then -- Boltslinger Repeater
                            task:setPos(1, 23, 4)
                            task:setRot(110, 0, 315)
                        elseif (customModelData == 213) then -- Crimson Crossbow
                            task:setRot(100, 0, 315)
                        elseif (customModelData == 240) then -- Spectral Crossbow
                            task:setRot(80, 0, 315)
                        elseif (customModelData == 243) then -- Slingshot
                            task:setPos(6.5, 10, 0)
                            task:setRot(0, 90, 0)
                        end
                    elseif (NumInArray(customModelData, {209, 211, 232, 236, 239})) then
                        -- Hand Cannon
                        task:setPos(3, 23, 4)
                        task:setRot(90, 0, 315)
                        if (customModelData == 209) then -- Brawler Blunderbuss
                            task:setPos(2, 22, 4)
                            task:setRot(110, 0, 325)
                        elseif (customModelData == 232) then -- Flamethrower
                            task:setPos(-1, 18, 4)
                            task:setRot(-90, 0, 135)
                        elseif (customModelData == 211) then -- Flame Cannon
                            task:setRot(-90, 0, 135)
                        end
                    elseif (NumInArray(customModelData, {203, 215, 216, 219, 220, 228, 230, 233, 237, 238, 245})) then
                        -- Long Bow
                        task:setPos(3, 18, 4)
                        task:setRot(25, 90, 340)
                        if (customModelData == 219 or customModelData == 220 or customModelData == 228) then -- Dusack/Banana/Spiral
                            task:setPos(3, 16, 4)
                        elseif (customModelData == 233) then -- Harp
                            task:setPos(6, 14, 4)
                        elseif (customModelData == 237 or customModelData == 245) then -- Futuristic/Tropical
                            task:setPos(1, 16, 4)
                            task:setRot(25, 90, 330)
                        end
                    else
                        -- Bows
                        task:setPos(6, 17.5, 4)
                        task:setRot(25, 90, 340)
                    end
                elseif (classItem == "Shaman/Skyseer") then -- (data = 379->444)
                    if (NumInArray(customModelData, {403, 415, 433, 435, 438, 440, 442, 444})) then
                        -- Lantern
                        task:setPos(5, 16, 0)
                        task:setRot(0, 90, -30)
                        if (customModelData == 415) then -- Dynasty Fan 
                            task:setPos(4, 23, 4)
                            task:setRot(0, 65, 140)
                        elseif (customModelData == 433) then -- Pan Pipes
                            task:setPos(5, 14, -1)
                            task:setRot(0, 0, 0)
                        elseif (customModelData == 435) then -- Ritualist Focus
                            task:setPos(-3, 15, 4)
                            task:setRot(0, 270, 60)
                        elseif (customModelData == 440) then -- Summoner's Marionette
                            task:setPos(2, 19, 5)
                            task:setRot(0, 280, 65)
                        elseif (customModelData == 442 or customModelData == 444) then -- Voodoo Dolls
                            task:setPos(3, 15, 5)
                            task:setRot(10, 280, 0)
                        end
                    else
                        -- Relik
                        task:setPos(4, 20, 4)
                        task:setRot(0, 270, 135)
                        if (NumInArray(customModelData, {421, 422, 424, 427, 428})) then -- Hand Offset Models
                            task:setPos(4, 20, 2)
                            task:setRot(0, 270, 135)
                        end
                    end
                end

                -- Hand Offset Models
                if (NumInArray(customModelData, {202, 221, 224, 225, 227, 230, 231, 274, 282, 286, 290, 293, 296, 333, 352, 355, 356, 358, 361, 362, 465, 483, 486, 487, 489, 492, 493, 505})) then
                    task:setPos(task:getPos().x, task:getPos().y, 6)
                end
            end

            -- ping only when item has changed
            if (oldItemInFirst ~= itemInFirst or (changedToEmpty == false and itemInFirst.id == 'minecraft:air')) then
                changedToEmpty = true
                if (oldItemInFirst ~= itemInFirst) then
                    changedToEmpty = false
                end

                oldItemInFirst = itemInFirst

                -- Sync item identifier
                pings.updateItemID(itemID)

                -- Sync bool check if itemstack is weapon
                local hasClassStr = CheckClassItem(itemInFirstStack)
                pings.updateWeaponClass(hasClassStr)

                -- Sync item task vectors
                pings.updateWeaponTask(task:getRot()[1], task:getRot()[2], task:getRot()[3], task:getPos()[1], task:getPos()[2], task:getPos()[3])
            end

        end
    end

    -- Sync selected slot
    function events.MOUSE_SCROLL(delta)
        if (not player:isLoaded() or host:getScreen() ~= nil or isActionWheelOpen) then
            return
        end

        local eventCurrSlot = player:getNbt().SelectedItemSlot
        if (delta < 0) then
            if (eventCurrSlot == 8) then
                eventCurrSlot = 0
            else
                eventCurrSlot = eventCurrSlot + 1
            end
        else
            if (eventCurrSlot == 0) then
                eventCurrSlot = 8
            else
                eventCurrSlot = eventCurrSlot - 1
            end
        end

        -- ping only when mouse scrolled over 0
        if (eventCurrSlot == 0 or eventCurrSlot == 1 or eventCurrSlot == 8) then
            pings.updateSlot(eventCurrSlot)
        end
    end

    -- Handle changing slot on keypress
    local slotOneKey = keybinds:newKeybind("hotbar1", keybinds:getVanillaKey("key.hotbar.1"))
    slotOneKey.press = pings.updateSlotKey
    local slotTwoKey = keybinds:newKeybind("hotbar2", keybinds:getVanillaKey("key.hotbar.2"))
    local slotThreeKey = keybinds:newKeybind("hotbar3", keybinds:getVanillaKey("key.hotbar.3"))
    local slotFourKey = keybinds:newKeybind("hotbar4", keybinds:getVanillaKey("key.hotbar.4"))
    local slotFiveKey = keybinds:newKeybind("hotbar5", keybinds:getVanillaKey("key.hotbar.5"))
    local slotSixKey = keybinds:newKeybind("hotbar6", keybinds:getVanillaKey("key.hotbar.6"))
    local slotSevenKey = keybinds:newKeybind("hotbar7", keybinds:getVanillaKey("key.hotbar.7"))
    local slotEightKey = keybinds:newKeybind("hotbar8", keybinds:getVanillaKey("key.hotbar.8"))
    local slotNineKey = keybinds:newKeybind("hotbar9", keybinds:getVanillaKey("key.hotbar.9"))
    slotTwoKey.press = pings.updateSlotNonZeroKey
    slotThreeKey.press = pings.updateSlotNonZeroKey
    slotFourKey.press = pings.updateSlotNonZeroKey
    slotFiveKey.press = pings.updateSlotNonZeroKey
    slotSixKey.press = pings.updateSlotNonZeroKey
    slotSevenKey.press = pings.updateSlotNonZeroKey
    slotEightKey.press = pings.updateSlotNonZeroKey
    slotNineKey.press = pings.updateSlotNonZeroKey
end

function events.tick()
    if (sheathOption) then
        if ((syncedPlayerSlot ~= oldSlot and (syncedPlayerSlot == 0 or oldSlot == 0)) or (currWeapon ~= oldWeapon) or (syncedItemID ~= oldItemID)) then
            if (currWeapon ~= nil) then
                task:setItem(syncedItemID)
                task:setRot(taskRotation)
                task:setPos(taskPosition)
            else
                task:setItem("minecraft:air")
            end
        end

        -- holding/not holding weapon
        if (syncedPlayerSlot == 0) then
            task:setVisible(false)
        else
            task:setVisible(true)
        end

        oldItemID = syncedItemID
        oldSlot = syncedPlayerSlot
        oldWeapon = currWeapon
    else
        task:setVisible(false)
    end
end

-- Action Wheel =========================================================================================

function SheathWeapon(bool)
    sheathOption = bool
end
pings.actionSheath = SheathWeapon

function IdleAnimation(bool)
    idleAnimations = bool
end
pings.actionIdleAnims = IdleAnimation

function pings.taunt1Dance()
    if (not AnimTaunt1:isPlaying()) then
        ResetIdle()
        AnimTaunt1:play()
    end
end

function pings.taunt2Nod()
    Rand = math.random(0,1)
    if (Rand == 0) then
        AnimTaunt2b:stop()
        AnimTaunt2a:restart()
    else
        AnimTaunt2a:stop()
        AnimTaunt2b:restart()
    end
end

function pings.taunt3JumpingJacks()
    if (not AnimTaunt3:isPlaying()) then
        ResetIdle()
        AnimTaunt3:play()
    end
end

function pings.taunt4Inspect()
    if (not AnimTaunt4:isPlaying()) then
        ResetIdle()
        AnimTaunt4:play()
    end
end

function pings.taunt5KickDirt()
    if (not AnimIdling1:isPlaying()) then
        ResetIdle()
        AnimIdling1:play()
    end
end

function pings.taunt6Look()
    if (not AnimIdling2:isPlaying()) then
        ResetIdle()
        AnimIdling2:play()
    end
end

function pings.taunt7Wait()
    if (not AnimIdling3:isPlaying()) then
        ResetIdle()
        AnimIdling3:play()
    end
end

local mainPage = action_wheel:newPage("Taunts")
local settingPage = action_wheel:newPage("Settings")
action_wheel:setPage(mainPage)

local toSettings = mainPage:newAction()
    :title("Go to Settings")
    :item("minecraft:writable_book")
    :onLeftClick(function()
    action_wheel:setPage(settingPage)
end)

local toTaunts = settingPage:newAction()
    :title("Go to Taunts")
    :item("minecraft:writable_book")
    :onLeftClick(function()
    action_wheel:setPage(mainPage)
end)

local taunt1 = mainPage:newAction()
    :title("Dance")
    :item("minecraft:music_disc_chirp")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt1Dance)

local taunt2 = mainPage:newAction()
    :title("Nod")
    :item("minecraft:player_head")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt2Nod)

local taunt3 = mainPage:newAction()
    :title("Jumping Jacks")
    :item("minecraft:feather")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt3JumpingJacks)

local taunt4 = mainPage:newAction()
    :title("Inspect Item")
    :item("minecraft:experience_bottle")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt4Inspect)

local taunt5 = mainPage:newAction()
    :title("Boredom")
    :item("minecraft:enchanted_book")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt5KickDirt)

local taunt6 = mainPage:newAction()
    :title("Look Around")
    :item("minecraft:ender_eye")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt6Look)

local taunt7 = mainPage:newAction()
    :title("Wait")
    :item("minecraft:clock")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt7Wait)

local setting1 = settingPage:newAction()
    :title("Enable Sheath")
    :toggleTitle("Disable Sheath")
    :item("minecraft:diamond_sword")
    :hoverColor(1, 1, 1)
    :onToggle(pings.actionSheath)
    :toggled(sheathOption)

local setting2 = settingPage:newAction()
    :title("Enable Idle Animations")
    :toggleTitle("Disable Idle Animations")
    :item("minecraft:armor_stand")
    :hoverColor(1, 1, 1)
    :onToggle(pings.actionIdleAnims)
    :toggled(idleAnimations)

local setting3 = settingPage:newAction()
local setting4 = settingPage:newAction()
local setting5 = settingPage:newAction()
local setting6 = settingPage:newAction()
local setting7 = settingPage:newAction()