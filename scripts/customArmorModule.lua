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
        PModel.Upper.body.ChestplateLeather,
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

kattArmor.Materials.diamond
    :setTexture("minecraft:textures/entity/equipment/humanoid/diamond.png")
    :setTextureLayer2("minecraft:textures/entity/equipment/humanoid_leggings/diamond.png")

kattArmor.registerOnChange(function(partID, item)
    -- print(item:toStackString())
    -- print("===")

    local materialAsset = item:toStackString():match(("^.*asset_id:\"minecraft:(.-)\"\"*."))
    -- print("Asset Id:",  materialAsset)
    if (materialAsset ~= nil) then
        return materialAsset
    end
end)

-- Wynncraft Armor
local wynncraftArmor = {
    ["leather"] = "leather",
    ["chainmail"] = "chainmail",
    ["gold"] = "gold",
    ["iron"] = "iron",
    ["diamond"] = "diamond",
    ["netherite"] = "netherite",
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

-- kattArmor.registerOnRender(function (materialID, partID, item, visible, renderType, color, texture, textureType, texture_e, textureType_e, damageOverlay, trim, trimPattern, trimMaterial, trimTexture, trimTextureType, trimColor, trimUV)
--     print(texture)
-- end)