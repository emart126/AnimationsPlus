-- ///////////////////////////////////////////////////////////////// --
--                          Wynn Extra Bends
--                              Vance568
--                              v1.3-dev
--
--   Helper Library Authors: Jimmy H., GrandpaScout, Squishy, Katt962
-- ///////////////////////////////////////////////////////////////// --

require("scripts/animationParts")
require("scripts/blockbenchParts")
require("scripts/customArmorModule")
require("scripts/customSwingModule")
require("scripts/customIdleModule")
require("scripts/customMovementModule")
require("scripts/customPhysicsModule")
require("scripts/customHolsterModule")
require("scripts/actionWheel")

-- Global Variables =================================================================================================================================

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

-- Render animation conditions by in game ticks
function events.tick() --============================================================================================================================

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
function events.render(delta, context) --============================================================================================================

    -- Player Conditions --------------------------------------------------------
    local sitting = player:getVehicle()

    -- First person hand model --------------------------------------------------
    if (player:isLeftHanded()) then
        vanilla_model.LEFT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.RIGHT_ARM:setVisible(false)
    else
        vanilla_model.RIGHT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.LEFT_ARM:setVisible(false)
    end

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