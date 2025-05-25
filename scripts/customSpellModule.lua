local spell
local oldspell

function IsSpellAttacking()
    for i = 1, #AllSpellAnimations do
        if (AllSpellAnimations[i]:isPlaying()) then
            return true
        end
    end
    return false
end

local function StopAllSwingAnimations()
    for i = 1, #AllSwingingAnimations do
        AllSwingingAnimations[i]:stop()
        GSBlend.stopBlend(AllSwingingAnimations[i])
    end
end

local function CheckSpellAction(name)
    if (name == nil) then
        return(nil)
    end

    if (string.find(name, "Bash") ~= nil) then
        return("Bash")
    elseif (string.find(name, "Uppercut") ~= nil) then
        return("Uppercut")
    elseif (string.find(name, "Charge") ~= nil) then
        return("Charge")
    elseif (string.find(name, "War Scream") ~= nil) then
        return("War Scream")
    end
    return(nil)
end

function events.tick()
    local mainHandItemName = player:getHeldItem(false):getName()
    spell = CheckSpellAction(mainHandItemName)

    if (spell ~= nil and spell ~= oldspell) then
        ResetIdle()

        if (spell == "Bash") then
            WarriorBash:play()
            print("Bash")
        elseif (spell == "Uppercut") then
            print("Uppercut")
        elseif (spell == "Charge") then
            print("Charge")
        elseif (spell == "War Scream") then
            print("War Scream")
        end
    end

    if (IsSpellAttacking()) then
        StopAllSwingAnimations()
    end

    oldspell = spell
end