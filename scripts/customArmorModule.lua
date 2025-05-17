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