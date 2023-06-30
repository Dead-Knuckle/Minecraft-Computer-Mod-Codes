local fuel_sources = {
    ["minecraft:coal"] = true,
    ["minecraft:coal_block"] = true,
    ["minecraft:charcoal"] = true,
    ["minecraft:blaze_rod"] = true,
}

local external_inv = {
    "shulker_box",
}

local blackList = {
["minecraft:stone"] = true,
["minecraft:cobblestone"] = true,
["minecraft:dirt"] = true,
["minecraft:granite"] = true,
["minecraft:diorite"] = true,
["minecraft:gravel"] = true,
["minecraft:flint"] = true,
["minecraft:netherrack"] = true,
["minecraft:tuff"] = true,
}

local light_sources = { 
    ["minecraft:torch"] = true,
}



is_storage = false
is_voiding = true
is_running = true
tunnel_amount = 5
will_turnRight = true
BLOCK_COUNT = 0
CURRENT_TUNNELS_MINED = 1

function STARTUP()
    term.clear()
    term.setCursorPos(1,1)
    for i = 1, #arg do
        if arg[i] == "-h" or arg[i] == "--help" then
            print("This program is a minning script, it can void, refuel, and use external storage. This script is desgins to be user friendly, you can you -v or --void to turn off voiding (default is true), -t #  or --tunnel # to spefic the tunnel amount (default is 5), -l or --left to make the script turn left (default is right),or -h or --help to see this message again")
            is_running = false
        end
        
        if arg[i] == "-v" or arg[i] == "--void" then
            is_voiding = false
        end
        
        if arg[i] == "-t" or arg[i] == "--tunnel" then
            number = tonumber(arg[i + 1])

            if not number then
                print("Need a number after the -t or --tunnel argument, the defualt is 5!")
                is_running = false
            end
            tunnel_amount = number
        end

        if arg[i] == "-l" or arg[i] == "--left" then
            will_turnRight = false
        end

    end
end


function CHECK_FUEL()
    local current_fuel_level = turtle.getFuelLevel()
    level_color = colors.white
    if current_fuel_level > 150 then
        level_color = colors.lime
    elseif current_fuel_level > 50 then
        level_color = colors.yellow
    elseif  current_fuel_level <= 50 then
        level_color = colors.red
    end

    io.write("Fuel: ")
    term.setTextColor(level_color)
    print(current_fuel_level)
    term.setTextColor(colors.white)
    if current_fuel_level <= 10 then
        REFUEL()
    end

end


function REFUEL()
    for slot_inv = 1, 16 do
        local item_detail = turtle.getItemDetail(slot_inv)
        if item_detail then
            sleep(0.1)
            if fuel_sources[item_detail.name] then
                print("Found Fuel source: "  .. slot_inv)
                turtle.select(slot_inv)
                print("Selecting slot")



                local count = 1
                repeat
                    sleep(0.1)
                    print("Refueling" .. "." .. string.rep(".", count))
                    turtle.refuel(1)
                    count = count + 1
                    if turtle.getItemCount(slot_inv) == 0 then
                        refuel()
                    end

                until turtle.getFuelLevel() > 200


                term.clear()
                term.setCursorPos(1,1)
                turtle.select(1)
                break
            end
        end
    end
end


function SEARCH_STORAGE()
    for inv_slot = 1, 16 do
        if turtle.getItemDetail(inv_slot) then

            for _, word in ipairs(external_inv) do
                if  string.match(turtle.getItemDetail(inv_slot).name, word) then
                    is_storage = inv_slot
                    break
                end
            end
        end
    end
end


function DROPPIN_STORAGE()
    if is_storage then
        local count = 0

        turtle.select(is_storage)
        turtle.placeUp()

        for inv_slot = 1, 16, 1 do
            sleep(0.1)
            turtle.select(inv_slot)
            local item_detail = turtle.getItemDetail()
            if item_detail then
                if not fuel_sources[item_detail.name] and not light_sources[item_detail.name] then
                    term.clear()
                    term.setCursorPos(1,1)
                    count = count + 1
                    print("Dropping" .. "." .. string.rep(".", count))
                    turtle.dropUp()
                end
            end

        end
        term.clear()
        turtle.select(1)
        turtle.digUp()
    end
end


function DROPPIN_VOID()
    if is_voiding then
        local count = 0
        for inv_slot = 1, 16 do
            
            local item_detail = turtle.getItemDetail(inv_slot)
            if item_detail then
                turtle.select(inv_slot)
                sleep(0.1)
                if blackList[item_detail.name] then
                    term.clear()
                    term.setCursorPos(1,1)
                    count = count + 1
                    print("Voiding" .. "." .. string.rep(".", count))
                    turtle.dropDown()
                end
            end
        end
        turtle.select(1)
    end
end



function UI()
    io.write("External storage: ")
    if is_storage then
        term.setTextColor(colors.blue)
        print("true")
    else
        term.setTextColor(colors.orange)
        print("false")
    end
    term.setTextColor(colors.white)

    io.write("Void: ")
    if is_voiding then
        term.setTextColor(colors.purple)
        print("true")
    else
        term.setTextColor(colors.cyan)
        print("false")
    end
    term.setTextColor(colors.white)

    io.write("Turns: ")
    if will_turnRight then
        term.setTextColor(colors.pink)
        print("right")
    else
        term.setTextColor(colors.orange)
        print("left")
    end
    term.setTextColor(colors.white)


    io.write("Tunnel percent: ")
    term.setTextColor(colors.lightBlue)
    print(math.ceil(BLOCK_COUNT / 30 * 100).."%")

    term.setTextColor(colors.white)

    io.write("Mining percent:")
    term.setTextColor(colors.magenta)
    print(math.ceil(CURRENT_TUNNELS_MINED / tunnel_amount * 100).."%")

    term.setTextColor(colors.white)


end

local function mine()
    turtle.dig()
    turtle.forward()
    local _, inspection = turtle.inspectDown()
    if inspection then
        if not light_sources[inspection.name] then
            turtle.digDown()
        end
    end 
    
    turtle.digUp()
end


function PLACE_TORCH()
    for inv_slot = 1, 16, 1 do
        local item_detail = turtle.getItemDetail(inv_slot)
        if item_detail then
            if light_sources[item_detail.name] then
                turtle.select(inv_slot)
                turtle.placeDown()
                turtle.select(1)
            end
        end
    end
end


function DIG_TUNNEL()
    BLOCK_COUNT = 0
    for i = 1, 3, 1 do
        for i = 1, 10, 1 do

            BLOCK_COUNT = BLOCK_COUNT + 1
            mine()

            term.clear()
            term.setCursorPos(1,1)
            sleep(0.1)
            CHECK_FUEL()
            UI()

        end

        PLACE_TORCH()
    end
    SEARCH_STORAGE()
    DROPPIN_VOID()
    DROPPIN_STORAGE()

    turtle.turnLeft()
    turtle.turnLeft()
    for i = 1, 30, 1 do
        term.clear()
        term.setCursorPos(1,1)
        CHECK_FUEL()
        UI()
        term.setTextColor(colors.magenta)
        print('Moving to next tunnel...')
        term.setTextColor(colors.white)
        mine()
    end
    turtle.turnLeft()
    turtle.turnLeft()
    BLOCK_COUNT = 0
end




function MOVE_TO_NEXT_TUNNEL()
    if will_turnRight then
        turtle.turnRight()
        mine()
        mine()
        mine()
        turtle.turnLeft()
    else
        turtle.turnLeft()
        mine()
        mine()
        mine()
        turtle.turnRight()
    end
end


STARTUP()

if  is_running then
    SEARCH_STORAGE()
    UI()
    for i = 1, tunnel_amount do
        DIG_TUNNEL()
        MOVE_TO_NEXT_TUNNEL()
        CURRENT_TUNNELS_MINED = i + 1
    end
    CURRENT_TUNNELS_MINED = tunnel_amount
    DROPPIN_VOID()
    SEARCH_STORAGE()
    DROPPIN_STORAGE()
    term.clear()
    term.setCursorPos(1,1)
    CHECK_FUEL()
    UI()
end
