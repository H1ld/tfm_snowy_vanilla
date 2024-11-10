--[[
########################## setup ##########################
]]--

function main() -- Fonction de lancement du module
    tfm.exec.disableAutoNewGame(true)
    -- tfm.exec.disableAutoShaman(true)

    mapList = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 17, 14, 33, 104 } -- Création de la liste de cartes
    lastSnowball = {}
    isCrouched = {}
    snowballPower = 5

    for playerName in pairs(tfm.get.room.playerList) do
            eventNewPlayer(playerName)
        end

        tfm.exec.newGame(mapList[math.random(#mapList)])
        system.disableChatCommandDisplay("power", true)
end
 
function eventNewPlayer(playerName)
    system.bindMouse(playerName, true)
    tfm.exec.bindKeyboard(playerName, 32, true, true)  -- espace
    tfm.exec.bindKeyboard(playerName, 40, true, true)  -- flèche bas
    tfm.exec.bindKeyboard(playerName, 40, false, true) -- flèche bas
    tfm.exec.bindKeyboard(playerName, 83, true, true)  -- S
    tfm.exec.bindKeyboard(playerName, 83, false, true) -- S
    lastSnowball[playerName] = os.time()
    isCrouched[playerName] = false
end

function eventLoop(timePast, timeLeft)
   if timeLeft <= 0 then
       tfm.exec.newGame( mapList[math.random(#mapList)] )
   end
end

function eventPlayerDied(name)
   if playerLeft() == 0 then
       tfm.exec.newGame( mapList[math.random(#mapList)] )
   end
end

function eventPlayerWon(name, timeBegin, timeRes)
   if playerLeft() == 0 then
       tfm.exec.newGame( mapList[math.random(#mapList)] )
   end
end

function playerLeft()
   local i = 0
   for _, prop in pairs(tfm.get.room.playerList) do
       if not prop.isDead then
           i = i+1
       end
   end
   return i
end

--[[
########################## game ##########################
]]--

function eventKeyboard(playerName, key, down, x, y)

    if (key==32 and not tfm.get.room.playerList[playerName].isShaman and not tfm.get.room.playerList[playerName].isDead and os.time()-lastSnowball[playerName]>=1000) then
        if (tfm.get.room.playerList[playerName].isFacingRight) then
            if (isCrouched[playerName]) then
                tfm.exec.addShamanObject(34, x+15, y, 0, 15, 0, false)
            else
                tfm.exec.addShamanObject(34, x+15, y-5, 0, 15, -5, false)
            end
        else
            if (isCrouched[playerName]) then
                tfm.exec.addShamanObject(34, x-15, y, 0, -15, 0, false)
            else
                tfm.exec.addShamanObject(34, x-15, y-5, 0, -15, -5, false)
            end
        end
        lastSnowball[playerName] = os.time()
    end

    if (key==40 or key==83) then
        if (down) then
            isCrouched[playerName] = true
        else
            isCrouched[playerName] = false
        end
    end
end

function eventMouse(playerName, xMousePosition, yMousePosition)
    if (tfm.get.room.playerList[playerName].isShaman ) then
        tfm.exec.snow(5,snowballPower)
    end
end

function eventChatCommand(name, command)

    local listeMots = {}
    for word in command:gmatch( '%S+' ) do -- On liste les mots de la commande
        table.insert(listeMots, word)
    end

    if listeMots[1] == 'power' then 
        snowballPower = listeMots[2]
        tfm.exec.snow(0,snowballPower)
    end
end

main()