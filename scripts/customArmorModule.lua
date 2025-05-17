local kattArmor = require("libraries/KattArmor")()

kattArmor.Armor.Helmet
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