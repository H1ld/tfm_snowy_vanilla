--[[
########################## setup ##########################
]]--

function main() 
    tfm.exec.disableAutoNewGame(true)
    system.disableChatCommandDisplay("power", true)

    mapList = { 0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 109, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233} -- Création de la liste de cartes
    lastSnowball = {}
    isCrouched = {}
    snowballPower = 5

    for playerName in pairs(tfm.get.room.playerList) do
        eventNewPlayer(playerName)
    end

    tfm.exec.newGame(mapList[math.random(#mapList)])
end
 
function eventNewPlayer(playerName)
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

function  eventSummoningStart (playerName, objectType, xPosition, yPosition, angle)
    tfm.exec.snow(5,snowballPower)
end

function eventChatCommand(name, command)

    local listeMots = {}
    for word in command:gmatch( '%S+' ) do
        table.insert(listeMots, word)
    end

    if listeMots[1] == 'power' then 
        snowballPower = listeMots[2]
        tfm.exec.snow(0,snowballPower)
    end
end

function eventChatMessage(playerName, message)

    for word in message:gmatch( '%S+' ) do
        for playerName in pairs(tfm.get.room.playerList) do
            if (word==playerName or word==playerName:sub(1,-6)) then
                tfm.exec.playEmote(playerName,9)
            end
        end
    end
end

main()