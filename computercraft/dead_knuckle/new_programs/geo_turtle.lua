-- ver = 1.0
local scanner = peripheral.find("geoScanner")




colors_config = {
    ["amount"] = colors.pink,
    ["default"] = colors.black,
}

--! Best to mine at  y=16 for nether

--[[
todo
2. Clear INV function
3. Refuel
4. Build path beneath turtle
5. make it so it says what ore its going for
6. Added a Reverse to "mine" function so it goes back the way it came
--]]

local function getOut()
    local suc, block = turtle.inspect()
    if  suc then
        if block.name == "minecraft:bedrock" then
            return true
        end
    end
end

local function mineGravel()
    repeat
        turtle.dig()
    until turtle.forward()
end




local function printLogo()
    DOS_COLOR = colors.orange
    DEAD_COLOR = colors.lightBlue

    term.setTextColor(DEAD_COLOR)
    io.write("___  ____ ____ ___")

    term.setTextColor(DOS_COLOR)
    io.write("  ___  ____ ____")

    term.setTextColor(DEAD_COLOR)
    io.write("\n|__> |=== |--| |__> ")

    term.setTextColor(DOS_COLOR)
    io.write("|__> [__] ====")

    term.setTextColor(colors.yellow)
    print("\nv.2 GeoMinner")
    term.setTextColor(colors.white)
end

local function ui(header_action,message_action, color)
    term.clear()
    local w,h = term.getSize()
    term.setCursorPos(1,1)
    printLogo()


    term.setCursorPos(1, h-1)

    io.write(header_action)
    term.setTextColor(color)
    io.write(message_action)
    term.setTextColor(colors.white)

end

local function printToCenter(content, yoffset)
    local width, height = term.getSize()
    local centerX = math.floor(width / 2)
    local centerY = math.floor(height / 2)
    local content_center = math.floor(#content / 2)
    term.setCursorPos(centerX- content_center, centerY-yoffset)
    io.write(content)
end

local function pretty_write(list, INDEX)
    local last = 0
    term.clear()
    printToCenter("--DIRECTION--\n", 5)
    for i = 1, #list, 1 do
        if i == INDEX then
            term.setBackgroundColor(colors_config["amount"])
        end
        printToCenter("|"..list[i].."|", 5-i)
        term.setBackgroundColor(colors_config["default"])
        last = i
    end
    printToCenter("--------------", 5-(last+1))
end


local function amount_selector(options)
    local INDEX = 1
    pretty_write(options,  1)
    while true do
        local event, key = os.pullEvent("key")
        if key == keys.up then
            INDEX = INDEX - 1
        elseif key == keys.down then
            INDEX = INDEX + 1
        elseif key == keys.q then
            error("User Quit Program...")
        elseif key == keys.enter then
            return options[INDEX]
        end

        if INDEX <= 0 then
            INDEX = #options
        elseif INDEX > #options then
            INDEX = 1
        end

        pretty_write(options, INDEX)
    end
end

function mine(X_POS,Y_POS,Z_POS, dir, reverse)
    reverse = reverse or false
    DOWN = Y_POS < 0
    if dir == "east" then
        LEFT = Z_POS < 0
        BACK = X_POS < 0
    elseif dir == "west" then
        LEFT = (Z_POS * -1) < 0
        BACK = (X_POS * -1) < 0
    elseif dir == "north" then
        BACK = (Z_POS * -1) < 0
        LEFT = (X_POS) < 0
    elseif dir == "south" then
        BACK = (Z_POS) < 0
        LEFT = (X_POS * -1) < 0
    end

    Y = math.abs(Y_POS)

    if dir == "east" or dir == "west"then
        X = math.abs(X_POS)
        Z = math.abs(Z_POS)

    elseif dir  == "north" or dir == "south" then
        Z = math.abs(X_POS)
        X = math.abs(Z_POS)
    end



    if reverse then
        if Y ~= 0 then
            for i = 1, Y, 1 do
                if DOWN then
                    turtle.digDown()
                    turtle.down()
                else
                    turtle.digUp()
                    turtle.up()
                end
            end
        end
        if Z ~= 0 then
            if LEFT then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end

            for i = 1, Z, 1 do
                if getOut() then
                    return
                end
                mineGravel()
            end

            if not LEFT then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end
        end
        if X ~= 0 then
            if BACK then
                turtle.turnLeft()
                turtle.turnLeft()
            end

            for i = 1, X, 1 do
                if getOut() then
                    return
                end
                mineGravel()
            end

            if BACK then
                turtle.turnLeft()
                turtle.turnLeft()
            end
        end
    else
        if X ~= 0 then
            if BACK then
                turtle.turnLeft()
                turtle.turnLeft()
            end

            for i = 1, X, 1 do
                if getOut() then
                    return
                end
                mineGravel()
            end

            if BACK then
                turtle.turnLeft()
                turtle.turnLeft()
            end
        end

        if Z ~= 0 then
            if LEFT then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end

            for i = 1, Z, 1 do
                if getOut() then
                    return
                end
                mineGravel()
            end

            if not LEFT then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end
        end

        if Y ~= 0 then
            for i = 1, Y, 1 do
                if DOWN then
                    turtle.digDown()
                    turtle.down()
                else
                    turtle.digUp()
                    turtle.up()
                end
            end
        end

    end


end

function scanMine(radius, list, dir)
    ui("Action:", "Scanning", colors.cyan)
    sleep(2)

    local scanResults = scanner.scan(radius)

    if scanResults == nil or next(scanResults) == nil then
        return 0
    end

    local oreTable = {}
    for key, value in pairs(scanResults) do
        if value then
            if list[value.name] then
                table.insert(oreTable, value)
            end
        end
    end

    ui("# of ore:", #oreTable, colors.purple)
    sleep(1)

    if #oreTable == 0 then
        ui("", "No ores in area, quitting function", colors.red)
        sleep(1)
        return 0
    end


    local offset_X, offset_Y, offset_Z = 0, 0, 0
    for key, value in pairs(oreTable) do
        --FIXME:
        ui("Ore at:"..value.x - offset_X.." "..value.y-offset_Y.." "..value.z-offset_Z,":"..value.name , colors.blue)
        mine(value.x - offset_X, value.y - offset_Y, value.z - offset_Z, dir)
        offset_X, offset_Y, offset_Z = value.x, value.y, value.z
        LAST = value
    end
    if LAST and #oreTable ~= 0  then
        ui("Action: ", "Returning home...", colors.magenta)
        mine(LAST.x * -1, LAST.y * -1, LAST.z * -1, dir, true)
    end

end

local ore_list = {
    ["minecraft:diamond_ore"] = true,
    ["minecraft:deepslate_diamond_ore"] = true,


    -- ["minecraft:iron_ore"] = true,
    -- ["minecraft:deepslate_iron_ore"] = true,

    -- ["minecraft:redstone_ore"] = true,
    -- ["minecraft:deepslate_redstone_ore"] = true,

    ["minecraft:gold_ore"] = true,
    ["minecraft:deepslate_gold_ore"] = true,

    -- ["create:zinc_ore"] = true,
    -- ["create:deepslate_zinc_ore"] = true,

    ["minecraft:ancient_debris"] = true,
}


local radius = 8
local options = {
    "    NORTH   ",
    "    SOUTH   ",
    "    EAST    ",
    "    WEST    "}

DIRECTION = string.lower(amount_selector(options))

while true do


    term.clear()
    term.setCursorPos(1,1)
    scanMine(radius, ore_list, string.gsub(DIRECTION, " ", ""))

    for i = 1, (math.floor(radius / 2 ) + radius), 1 do
        ui("Moving:", tostring(i).."/"..tostring(math.floor(radius / 2 ) + radius), colors.green)
        turtle.digUp()
        mineGravel()
    end
end



