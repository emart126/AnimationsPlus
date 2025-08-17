local kattArmor = require("libraries/KattArmor")()

kattArmor.Armor.Helmet
    :addParts(
        PModel.Upper.head.Helmet,
        PModel.Upper.head.HelmetHat
    )
kattArmor.Armor.Chestplate
    :addParts(
        PModel.Upper.body.Chestplate,
        PModel.Upper.body.Arms.Arm_R.RightArmArmor,
        PModel.Upper.body.Arms.Arm_L.LeftArmArmor
    )
kattArmor.Armor.Leggings
    :addParts(
        PModel.Upper.body.Belt,
        PModel.Lower.Leg_R.RightLeggingsArmor,
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmor,
        PModel.Lower.Leg_L.LeftLeggingsArmor,
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmor
    )
kattArmor.Armor.Boots
    :addParts(
        PModel.Lower.Leg_R.Knee_R.RightBootArmor,
        PModel.Lower.Leg_L.Knee_L.LeftBootArmor
    )

kattArmor.registerOnChange(function(partID, item)
    -- print(partID, item)

    local materialAsset = item:toStackString():match(("^.*asset_id:\"minecraft:(.-)\"\"*."))
    -- print("Asset Id:",  materialAsset)
    if (materialAsset ~= nil) then
        return materialAsset
    end
end)