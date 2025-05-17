-- ///////////////////////////////////////////////////////////////// --
--                          Wynn Extra Bends
--                              Vance568
--                              v1.3-dev
--
--   Helper Library Authors: Jimmy H., GrandpaScout, Squishy, Katt962
-- ///////////////////////////////////////////////////////////////// --

-- local squapi = require("libraries/SquAPI")
-- local squassets = require("libraries/SquAssets")
-- local anims = require("libraries/EZAnims")
-- anims:setOneJump(true)
-- local animModel = anims:addBBModel(animations.model)
-- animModel:setBlendTimes(2,2)

require("scripts/animationParts")
require("scripts/blockbenchParts")
require("scripts/customArmorModule")
require("scripts/customSwingModule")
require("scripts/customIdleModule")
require("scripts/customMovementModule")
require("scripts/customPhysicsModule")
require("scripts/customHolsterModule")
require("scripts/actionWheel")

-- Global Variables =====================================================================================

-- Pinged/Synced Values
-- local oldWeaponClass
-- local weaponClass
-- local oldToolItem
-- local toolItem
isActionWheelOpen = nil
local wheelCheck
local oldWheelCheck

-- Settings
-- local sheathOption = true;
-- local idleAnimations = true;

-- -- Animation states/ticks
-- local idleTick = 0
-- local randTick = 400
-- local randAnim

-- local rightLeg = false
-- local wasSprintJup = false
-- local wasSprintJDown = false
-- local isSprintJup
-- local isSprintJDown

-- local fallTimer = 0
-- local startFallTime = 0
-- local startedFall = false
-- local yVel = 0
-- local oldYVel = 0

-- local facing
-- local oldFacing

-- local blendClimb = true
-- local blendClimbDone = false
-- local climbBlendInRot
-- local climbBlendOutRot

-- local blendClimbTop = false
-- local climbTopBlendInRot
-- local climbTopBlendOutRot

local isBoating
local oldIsBoating

function events.entity_init() --=====================================================================================================================
    -- Hide vanilla model
    vanilla_model.PLAYER:setVisible(false)
    vanilla_model.CAPE:setVisible(false)

    -- Set player textures
    pModel:setPrimaryTexture("SKIN")
    modelCape:setPrimaryTexture("CAPE")

    -- Set arm type
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

-- Pings ================================================================================================
function pings.syncHeldItemIsWeapon(strClass)
    weaponClass = strClass
    currSwing = 1
end

function pings.syncHeldItemIsTool(strClass)
    toolItem = strClass
    currSwing = 1
end

function pings.syncAcitonWheel(bool)
    isActionWheelOpen = bool
end

-- Helper Functions =====================================================================================

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

-- Check if itemStack has tool identified with it
local function CheckToolItem(item)
    if (item == nil) then
        return(nil)
    end

    if (string.find(item, "Mining") ~= nil) then
        return("Mining")
    elseif (string.find(item, "Woodcutting") ~= nil) then
        return("Woodcutting")
    elseif (string.find(item, "Farming") ~= nil) then
        return("Farming")
    elseif (string.find(item, "Fishing") ~= nil) then
        return("Fishing")
    end
    return(nil)
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
            ArcherShoot:play()
        end
    end
end
useKey.press = pings.onRightClickDo

-- Render animation conditions by in game ticks
function events.tick() --============================================================================================================================

    -- Item Use Priority --------------------------------------------------------
    AnimBowShootHold:setPriority(player:isUsingItem() and 1 or 0)
    AnimCrossBowLoad:setPriority(player:isUsingItem() and 2 or 1)
    AnimShieldL:setPriority((player:isUsingItem()) and 1 or 0)
    AnimShieldR:setPriority((player:isUsingItem()) and 1 or 0)

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

end

-- Render animation condtions using render function
function events.render(delta, context) --============================================================================================================================

    -- Player Conditions --------------------------------------------------------
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()
    -- local swimming = player:isVisuallySwimming()
    -- local floating = player:isInWater()
    -- local walking = player:getVelocity().xz:length() > .001
    -- local climbing = player:isClimbing()
    local sitting = player:getVehicle()
    -- local ridingSeat = sitting and (sitting:getType() == "minecraft:minecart" or string.find(sitting:getType(), "boat"))

    -- First person hand model --------------------------------------------------
    if (player:isLeftHanded()) then
        vanilla_model.LEFT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.RIGHT_ARM:setVisible(false)
    else
        vanilla_model.RIGHT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.LEFT_ARM:setVisible(false)
    end

    -- Is Action Wheel Open -----------------------------------------------------
    wheelCheck = action_wheel:isEnabled()
    if (wheelCheck ~= oldWheelCheck) then
        pings.syncAcitonWheel(wheelCheck)
    end
    oldWheelCheck = wheelCheck

    -- Held Item Wynncraft Class ------------------------------------------------
    local class = CheckClassItem(currItemStack)
    if (class ~= oldWeaponClass) then
        pings.syncHeldItemIsWeapon(class)
    end
    oldWeaponClass = class

    -- Held Item Wynncraft Tool -------------------------------------------------
    local tool = CheckToolItem(currItemStack)
    if (toolItem ~= oldToolItem) then
        pings.syncHeldItemIsTool(tool)
    end
    oldToolItem = tool

    -- Boating ------------------------------------------------------------------
    isBoating = sitting and string.find(sitting:getType(), "boat")
    if (isBoating) then
        AnimHorseSit:stop()
        AnimHorseRiding:stop()
        AnimSit:play()
    elseif (not isBoating and isBoating ~= oldIsBoating) then
        AnimSit:stop()
    end

    oldIsBoating = isBoating
end