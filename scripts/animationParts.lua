local anims = require("libraries/EZAnims")
anims:setOneJump(true)
local animModel = anims:addBBModel(animations.model)
animModel:setBlendTimes(2,2)

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

AnimPunch = animations.model["attackR"]
AnimPunch:setBlendTime(1, 4)
AnimPunch:setBlendCurve("easeInOutSine")
AnimMine = animations.model["mineR"]
AnimMine:setBlendTime(1, 5)
AnimMine:setBlendCurve("easeInOutSine")
AnimShieldR = animations.model["blockR"]
AnimShieldR:setBlendTime(2, 3)
AnimShieldR:setBlendCurve("easeInOutSine")
AnimShieldL = animations.model["blockL"]
AnimShieldL:setBlendTime(2, 3)
AnimShieldL:setBlendCurve("easeInOutSine")
AnimCombatReady = animations.model["combatReady"]

-- Warrior ------
WarriorSwing1 = animations.model["Spear_Swing_1"]
WarriorSwing2 = animations.model["Spear_Swing_2"]
WarriorSwing3 = animations.model["Spear_Swing_3"]
WarriorSwing1:setBlendTime(3,7)
WarriorSwing1:setBlendCurve("easeInOutSine")
WarriorSwing2:setBlendTime(4,7)
WarriorSwing2:setBlendCurve("easeInOutSine")
WarriorSwing3:setBlendTime(3,7)
WarriorSwing3:setBlendCurve("easeOutSine")

-- UNUSED Version
-- WarriorSwing2:setBlendTime(4,5.5)
-- -- WarriorSwing2:setBlendCurve("easeInOutSine")
-- WarriorSwing3:setBlendTime(3,5)
-- -- WarriorSwing3:setBlendCurve("easeOutSine")

-- Mage ---------
MageSwing1 = animations.model["Wand_Wave_1"]
MageSwing2 = animations.model["Wand_Wave_2"]
MageSwing3 = animations.model["Wand_Wave_3"]
MageSwing1:setBlendTime(3, 7)
MageSwing1:setBlendCurve("easeInOutSine")
MageSwing2:setBlendTime(3, 6.5)
MageSwing2:setBlendCurve("easeInOutSine")
MageSwing3:setBlendTime(3, 6.5)
MageSwing3:setBlendCurve("easeInOutSine")

-- Assassin -----
AssassinSwing1 = animations.model["Sword_Swing_1"]
AssassinSwing2 = animations.model["Sword_Swing_2"]
AssassinSwing3 = animations.model["Sword_Swing_3"]
AssassinSwing4 = animations.model["Sword_Swing_4"]
AssassinSwing1:setBlendTime(3, 5.5)
AssassinSwing1:setBlendCurve("easeInOutSine")
AssassinSwing2:setBlendTime(3, 5.5)
AssassinSwing2:setBlendCurve("easeInOutSine")
AssassinSwing3:setBlendTime(4, 5.5)
AssassinSwing3:setBlendCurve("easeInOutSine")
AssassinSwing4:setBlendTime(3, 5.5)

-- Shaman -------
ShamanSwing1 = animations.model["Relik_Strike_1"]
ShamanSwing2 = animations.model["Relik_Strike_2"]
ShamanSwing3 = animations.model["Relik_Strike_3"]
ShamanSwing1:setBlendTime(2, 7)
ShamanSwing1:setBlendCurve("easeInOutSine")
ShamanSwing2:setBlendTime(3, 6.5)
ShamanSwing2:setBlendCurve("easeInOutSine")
ShamanSwing3:setBlendTime(3, 8)
ShamanSwing3:setBlendCurve("easeInOutSine")

-- Archer -------
ArcherShoot = animations.model["Bow_Shoot"]
ArcherShoot:setBlendTime(2, 4.5)
ArcherShoot:setBlendCurve("easeOutSine")
AnimBowShootHold = animations.model["bowR"]
AnimBowShootHold:setBlendTime(3,1)
AnimBowShootHold:setBlendCurve("easeInSine")

AnimCrossBowLoad = animations.model["loadR"]
AnimCrossBowLoad:setBlendTime(10,3)
AnimCrossBowLoad:setBlendCurve("easeInOutSine")
AnimCrossBowHold = animations.model["crossR"]
AnimCrossBowHold:setBlendTime(4,0)
AnimCrossBowHold:setBlendCurve("easeInSine")
AnimCrossBowShoot = animations.model["Cross_Shoot"]
AnimCrossBowShoot:setBlendTime(0, 4.5)
AnimCrossBowShoot:setBlendCurve("easeOutSine")

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