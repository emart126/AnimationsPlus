local OFFHAND_SLOT = 2

local anims = require("libraries/EZAnims")
anims:setOneJump(true)

local animModel = anims:addBBModel(animations.model)
animModel:setBlendTimes(2,2)

local handType = "R"

-- Basic Action Animations ------------------------------------------
AnimIdle = animations.model["idling"]
AnimIdle:setBlendCurve("easeInOutSine")
AnimIdling1 = animations.model["Idle_1"]
AnimIdling1:setBlendTime(2, 4)
AnimIdling1:setBlendCurve("easeInOutSine")
AnimIdling2 = animations.model["Idle_2"]
AnimIdling2:setBlendTime(2, 4)
AnimIdling2:setBlendCurve("easeInOutSine")
AnimIdling3 = animations.model["Idle_3"]
AnimIdling3:setBlendTime(2, 4)
AnimIdling3:setBlendCurve("easeInOutSine")

AnimWalk = animations.model["walking"]
AnimWalk:setBlendCurve("easeInOutSine")
AnimCrouching = animations.model["crouching"]
AnimCrouching:setBlendTime(4)
AnimCrouching:setBlendCurve("easeInOutSine")
AnimUnCrouchJUp = animations.model["crouchjumpup"]
AnimUnCrouchJUp:setBlendTime(4)
AnimUnCrouchJUp:setBlendCurve("easeInOutSine")
AnimCrouchJDown = animations.model["crouchjumpdown"]
AnimCrouchJDown:setBlendTime(5)
AnimCrouchJDown:setBlendCurve("easeInOutSine")
AnimCrouchWalk = animations.model["crouchwalk"]
AnimCrouchWalk:setBlendTime(4)
AnimCrouchWalk:setBlendCurve("easeInOutSine")

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
AnimShortFalling:setBlendTime(5, 2)
AnimShortFalling:setBlendCurve("easeInOutSine")
AnimFreeFalling = animations.model["freeFall"]
AnimFreeFalling:setBlendTime(4, 3)
AnimLand = animations.model["land"]
AnimLand:setBlendTime(1)

AnimSprint = animations.model["sprinting"]
AnimSprint:setBlendTime(2, 2)
AnimSprint:setBlendCurve("easeInOutSine")

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

-- Tools ------------------------------------------------------------

AnimPickaxe1 = animations.model["pickaxe_1"]
AnimPickaxe1:setBlendTime(2, 7)
AnimPickaxe1:setBlendCurve("easeInOutSine")
AnimPickaxe2 = animations.model["pickaxe_2"]
AnimPickaxe2:setBlendTime(2, 7)
AnimPickaxe2:setBlendCurve("easeInOutSine")

AnimAxe1 = animations.model["axe_1"]
AnimAxe1:setBlendTime(3, 5)
AnimAxe1:setBlendCurve("easeInOutSine")
AnimAxe2 = animations.model["axe_2"]
AnimAxe2:setBlendTime(3, 5)
AnimAxe2:setBlendCurve("easeInOutSine")

AnimShovel1 = animations.model["shovel_1"]
AnimShovel1:setBlendTime(3, 6)
AnimShovel1:setBlendCurve("easeInOutSine")
AnimShovel2 = animations.model["shovel_2"]
AnimShovel2:setBlendTime(3, 6)
AnimShovel2:setBlendCurve("easeInOutSine")

AnimHoe1 = animations.model["hoe_1"]
AnimHoe1:setBlendTime(2, 5)
AnimHoe1:setBlendCurve("easeInOutSine")
AnimHoe2 = animations.model["hoe_2"]
AnimHoe2:setBlendTime(2, 5)
AnimHoe2:setBlendCurve("easeInOutSine")

AnimFishing1 = animations.model["fishing_1"]
AnimFishing1:setBlendTime(3, 6)
AnimFishing1:setBlendCurve("easeInOutSine")
AnimFishing2 = animations.model["fishing_2"]
AnimFishing2:setBlendTime(3, 6)
AnimFishing2:setBlendCurve("easeInOutSine")
AnimIsFishing = animations.model["is_fishing"]
AnimIsFishing:setBlendTime(6, 2)
AnimIsFishing:setBlendCurve("easeInOutSine")

-- Attacks ----------------------------------------------------------

AnimPunch = nil
AnimMine = nil

AnimShieldR = animations.model["blockR"]
AnimShieldR:setBlendTime(2, 3)
AnimShieldR:setBlendCurve("easeInOutSine")
AnimShieldL = animations.model["blockL"]
AnimShieldL:setBlendTime(2, 3)
AnimShieldL:setBlendCurve("easeInOutSine")

AnimCombatReady = animations.model["combatReady"]

-- Warrior ------
WarriorSwing1 = nil
WarriorSwing2 = nil
WarriorSwing3 = nil

-- Mage ---------
MageSwing1 = nil
MageSwing2 = nil
MageSwing3 = nil

-- Assassin -----
AssassinSwing1 = nil
AssassinSwing2 = nil
AssassinSwing3 = nil
AssassinSwing4 = nil

-- Shaman -------
ShamanSwing1 = nil
ShamanSwing2 = nil
ShamanSwing3 = nil

-- Archer -------
AnimBowShootHold = nil
ArcherShoot = nil

AnimCrossBowLoad = nil
AnimCrossBowHold = nil
AnimCrossBowShoot = nil

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

-- Animation overrides ----------------------------------------------
animModel:addExcluOverrider(
    AnimFreeFalling,
    AnimShortFalling
)
animModel:addIncluOverrider(
    -- animations.model["Bow_Shoot"],
    -- animations.model["Cross_Shoot"]
    -- animations.model["Taunt_2"],
    -- animations.model["Taunt_3"]
)

function events.tick()

    -- Set Hand
    handType = player:isLeftHanded() and "L" or "R"
    local mainHandItem = player:getHeldItem(false)
    local offhandItem = player:getHeldItem(true)
    local bowMainHand = string.find(mainHandItem.id, "bow") or (CheckClassItem(mainHandItem:toStackString()) == "Archer/Hunter")
    local bowOffHand = string.find(offhandItem.id, "bow") or (CheckClassItem(offhandItem:toStackString()) == "Archer/Hunter")
    local bowHeldInLeft = ((handType == "L" and bowMainHand) or (handType == "R" and bowOffHand)) and 1 or 0
    local bowHeldInRight = ((handType == "R" and bowMainHand) or (handType == "L" and bowOffHand)) and 1 or 0
    local activeBowhandType = ((bowHeldInLeft == 1) and "L") or ((bowHeldInRight == 1) and "R") or "R"

    -- Basic --------
    AnimPunch = animations.model["attack" .. handType]
    AnimPunch:setBlendTime(1, 4)
    AnimPunch:setBlendCurve("easeInOutSine")
    AnimMine = animations.model["mine" .. handType]
    AnimMine:setBlendTime(1, 5)
    AnimMine:setBlendCurve("easeInOutSine")

    -- Warrior ------
    WarriorSwing1 = animations.model["Spear_Swing_1" .. handType]
    WarriorSwing1:setBlendTime(3,7)
    WarriorSwing1:setBlendCurve("easeInOutSine")
    WarriorSwing2 = animations.model["Spear_Swing_2" .. handType]
    WarriorSwing2:setBlendTime(4,7)
    WarriorSwing2:setBlendCurve("easeInOutSine")
    WarriorSwing3 = animations.model["Spear_Swing_3" .. handType]
    WarriorSwing3:setBlendTime(3,7)
    WarriorSwing3:setBlendCurve("easeOutSine")

    -- Mage ---------
    MageSwing1 = animations.model["Wand_Wave_1" .. handType]
    MageSwing1:setBlendTime(3, 7)
    MageSwing1:setBlendCurve("easeInOutSine")
    MageSwing2 = animations.model["Wand_Wave_2" .. handType]
    MageSwing2:setBlendTime(3, 6.5)
    MageSwing2:setBlendCurve("easeInOutSine")
    MageSwing3 = animations.model["Wand_Wave_3" .. handType]
    MageSwing3:setBlendTime(3, 6.5)
    MageSwing3:setBlendCurve("easeInOutSine")

    -- Assassin -----
    AssassinSwing1 = animations.model["Sword_Swing_1" .. handType]
    AssassinSwing1:setBlendTime(3, 5.5)
    AssassinSwing1:setBlendCurve("easeInOutSine")
    AssassinSwing2 = animations.model["Sword_Swing_2" .. handType]
    AssassinSwing2:setBlendTime(3, 5.5)
    AssassinSwing2:setBlendCurve("easeInOutSine")
    AssassinSwing3 = animations.model["Sword_Swing_3" .. handType]
    AssassinSwing3:setBlendTime(4, 5.5)
    AssassinSwing3:setBlendCurve("easeInOutSine")
    AssassinSwing4 = animations.model["Sword_Swing_4" .. handType]
    AssassinSwing4:setBlendTime(3, 5.5)

    -- Shaman -------
    ShamanSwing1 = animations.model["Relik_Strike_1" .. handType]
    ShamanSwing1:setBlendTime(2, 7)
    ShamanSwing1:setBlendCurve("easeInOutSine")
    ShamanSwing2 = animations.model["Relik_Strike_2" .. handType]
    ShamanSwing2:setBlendTime(3, 6.5)
    ShamanSwing2:setBlendCurve("easeInOutSine")
    ShamanSwing3 = animations.model["Relik_Strike_3" .. handType]
    ShamanSwing3:setBlendTime(3, 8)
    ShamanSwing3:setBlendCurve("easeInOutSine")

    -- Archer -------
    AnimBowShootHold = animations.model["bow" .. activeBowhandType]
    AnimBowShootHold:setBlendTime(3,1)
    AnimBowShootHold:setBlendCurve("easeInSine")
    ArcherShoot = animations.model["Bow_Shoot" .. activeBowhandType]
    ArcherShoot:setBlendTime(2, 4.5)
    ArcherShoot:setBlendCurve("easeOutSine")

    AnimCrossBowLoad = animations.model["load" .. activeBowhandType]
    AnimCrossBowLoad:setBlendTime(10,3)
    AnimCrossBowLoad:setBlendCurve("easeInOutSine")
    AnimCrossBowHold = animations.model["cross" .. activeBowhandType]
    AnimCrossBowHold:setBlendTime(4,0)
    AnimCrossBowHold:setBlendCurve("easeInSine")
    AnimCrossBowShoot = animations.model["Cross_Shoot" .. activeBowhandType]
    AnimCrossBowShoot:setBlendTime(0, 4.5)
    AnimCrossBowShoot:setBlendCurve("easeOutSine")

end