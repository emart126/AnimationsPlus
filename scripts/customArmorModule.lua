HelmetUnhidden = false
ChestplateUnhidden = false
LeggingsUnhidden = false
BootsUnhidden = false
local kattArmor = require("libraries/KattArmor")()

kattArmor.Armor.Helmet
    :addParts(
        PModel.Upper.head.Helmet,
        PModel.Upper.head.HelmetHat
    )
    :addTrimParts(
        PModel.Upper.head.HelmetTrim,
        PModel.Upper.head.HelmetHatTrim
    )
kattArmor.Armor.Chestplate
    :addParts(
        PModel.Upper.body.Chestplate,
        PModel.Upper.body.Arms.Arm_R.RightArmArmor,
        PModel.Upper.body.Arms.Arm_R.Elbow_R.RightLimbArmor,
        PModel.Upper.body.Arms.Arm_L.LeftArmArmor,
        PModel.Upper.body.Arms.Arm_L.Elbow_L.LeftLimbArmor
    )
    :addTrimParts(
        PModel.Upper.body.ChestplateTrim,
        PModel.Upper.body.Arms.Arm_R.RightArmArmorTrim,
        PModel.Upper.body.Arms.Arm_R.Elbow_R.RightLimbArmorTrim,
        PModel.Upper.body.Arms.Arm_L.LeftArmArmorTrim,
        PModel.Upper.body.Arms.Arm_L.Elbow_L.LeftLimbArmorTrim
    )
kattArmor.Armor.Leggings
    :addParts(
        PModel.Upper.body.Belt,
        PModel.Lower.Leg_R.RightLeggingsArmor,
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmor,
        PModel.Lower.Leg_L.LeftLeggingsArmor,
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmor
    )
    :addTrimParts(
        PModel.Upper.body.BeltTrim,
        PModel.Lower.Leg_R.RightLeggingsArmorTrim,
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmorTrim,
        PModel.Lower.Leg_L.LeftLeggingsArmorTrim,
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmorTrim
    )
kattArmor.Armor.Boots
    :addParts(
        PModel.Lower.Leg_R.Knee_R.RightBootArmor,
        PModel.Lower.Leg_L.Knee_L.LeftBootArmor
    )
    :addTrimParts(
        PModel.Lower.Leg_R.Knee_R.RightBootArmorTrim,
        PModel.Lower.Leg_L.Knee_L.LeftBootArmorTrim
    )

local leather1 = "minecraft:textures/entity/equipment/humanoid/leather_overlay.png"
local leather2 = "minecraft:textures/entity/equipment/humanoid_leggings/leather_overlay.png"
kattArmor.Materials.leather
    :addParts("Helmet",
        PModel.Upper.head.HelmetLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.head.HelmetHatLeather:setPrimaryTexture("RESOURCE", leather1)
    )
    :addParts("Chestplate",
        PModel.Upper.body.ChestplateLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_R.RightArmArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_R.Elbow_R.RightLimbArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_L.LeftArmArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_L.Elbow_L.LeftLimbArmorLeather:setPrimaryTexture("RESOURCE", leather1)
    )
    :addParts("Leggings",
        PModel.Upper.body.BeltLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_R.RightLeggingsArmorLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmorLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_L.LeftLeggingsArmorLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmorLeather:setPrimaryTexture("RESOURCE", leather2)
    )
    :addParts("Boots",
        PModel.Lower.Leg_R.Knee_R.RightBootArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Lower.Leg_L.Knee_L.LeftBootArmorLeather:setPrimaryTexture("RESOURCE", leather1)
    )

kattArmor.registerOnChange(function(partID, item)
    local materialAsset = item:toStackString():match(("^.*asset_id:\"minecraft:(.-)\"\"*."))
    -- print(materialAsset)
    if (materialAsset ~= nil and materialAsset ~= 'elytra') then
        return materialAsset
    end
end)

-- Wynncraft Armor
local wynncraftArmor = {
    ["hidden"] = "hidden",
    ["leather"] = "leather",
    ["copper"] = "copper",
    ["chainmail"] = "chainmail",
    ["gold"] = "gold",
    ["iron"] = "iron",
    ["diamond"] = "diamond",
    ["netherite"] = "netherite",
    ["pale_leather"] = "pale_leather",
    ["pale_copper"] = "pale_copper",
    ["pale_chainmail"] = "pale_chainmail",
    ["pale_gold"] = "pale_gold",
    ["pale_iron"] = "pale_iron",
    ["pale_diamond"] = "pale_diamond",
    ["infernal"] = "infernal",
    ["tan"] = "tan",
    ["shaman"] = "shaman"
}

local wynncraftArmorPathLayer1 = "minecraft:textures/entity/equipment/humanoid/%s.png"
local wynncraftArmorPathLayer2 = "minecraft:textures/entity/equipment/humanoid_leggings/%s.png"

for material, materialItem in pairs(wynncraftArmor) do
    kattArmor.Materials[material]
        :setTexture(wynncraftArmorPathLayer1:format(materialItem))
        :setTextureLayer2(wynncraftArmorPathLayer2:format(materialItem))
end

kattArmor.Materials.pale_leather:setDefaultColor(0xA06540)

-- Wynncraft Hide/Unhide Armor --
OldHelmetUnhidden = false
OldChestplateUnhidden = false
OldLeggingsUnhidden = false
OldBootsUnhidden = false
function events.render(delta, context)

    vanilla_model.ARMOR:setVisible(false)
    Changed = (OldHelmetUnhidden ~= HelmetUnhidden)
            or (OldChestplateUnhidden ~= ChestplateUnhidden)
            or (OldLeggingsUnhidden ~= LeggingsUnhidden)
            or (OldBootsUnhidden ~= BootsUnhidden)
    if (Changed) then
        -- print("Changed")
        kattArmor.forceUpdate()
    end

    -- Handle Helmet/Hat visibility
    kattArmor.Armor.Helmet:setMaterial(HelmetUnhidden or nil)
    kattArmor.Armor.Chestplate:setMaterial(ChestplateUnhidden or nil)
    kattArmor.Armor.Leggings:setMaterial(LeggingsUnhidden or nil)
    kattArmor.Armor.Boots:setMaterial(BootsUnhidden or nil)

    if (string.find(player:getItem(6).id, "helmet") ~= nil or (not HelmetUnhidden)) then
        -- vanilla_model.ARMOR:setVisible(true)
        vanilla_model.HELMET_ITEM:setVisible(true)
        -- ModelHead.HelmetItemPivot:setScale(1, 1, 1)
    else
        -- vanilla_model.ARMOR:setVisible(false)
        vanilla_model.HELMET_ITEM:setVisible(false)
        -- ModelHead.HelmetItemPivot:setScale(0, 0, 0)
    end
    -- print(HelmetUnhidden, ChestplateUnhidden, LeggingsUnhidden, BootsUnhidden)

    OldHelmetUnhidden = HelmetUnhidden
    OldChestplateUnhidden = ChestplateUnhidden
    OldLeggingsUnhidden = LeggingsUnhidden
    OldBootsUnhidden = BootsUnhidden
end