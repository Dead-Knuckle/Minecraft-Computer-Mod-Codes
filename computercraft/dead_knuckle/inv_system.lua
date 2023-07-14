local options = {"    01    ","    16    ","    32    ","    64    ","  Custom  ",}

local function printToCenter(content, yoffset)
    local width, height = term.getSize()
    local centerX = math.floor(width / 2)
    local centerY = math.floor(height / 2)
    local content_center = math.floor(#content / 2)
    term.setCursorPos(centerX- content_center, centerY-yoffset)
    io.write(content)
end


local function pretty_print(strvalue, index)
    term.setCursorPos(1, index)
    term.clearLine()
    term.setCursorPos(1, index)
    term.setBackgroundColor(colors.purple)
    print(strvalue)
    term.setBackgroundColor(colors.black)
end

local function pretty_write(list, INDEX)
    local last = 0
    term.clear()
    printToCenter("---AMOUNT---\n", 5)
    for i = 1, #list, 1 do
        if i == INDEX then
            term.setBackgroundColor(colors.pink)
        end
        printToCenter("|"..list[i].."|", 5-i)
        term.setBackgroundColor(colors.black)
        last = i
    end
    printToCenter("------------", 5-(last+1))
end


function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end
local function STARTUP_SCREEN()
    term.clear()
    term.setCursorPos(1,1)
    print(" _____                 __      _______ _______ ")
    print("|     \\.-----.---.-.--|  |    |       |     __|")
    print("|  --  |  -__|  _  |  _  |    |   -   |__     |")
    print("|_____/|_____|___._|_____|____|_______|_______|")
    print("                        |______|               ")

    print("\nPush \"i\" to input a search term or \"q\" to exit...")
end

local function user_input(user_message)
    local _, h = term.getSize()
    term.setCursorPos(1, h)
    io.write(user_message)
    return io.read()
end

local function get_item_list()
    INPUT_CHEST = TableConcat({ peripheral.find("minecraft:chest")}, {peripheral.find("storagedrawers:controller")})
    OUTPUT_BARREL = peripheral.find("minecraft:barrel")
    ITEM_LIST = {}
    ITEM_COUNT = {}

    for _, chest in pairs(INPUT_CHEST) do
        local chest_list = chest.list()
        for i = 1, #chest_list do
            local item = chest_list[i]
            if item then
                if ITEM_LIST[item.name] then
                    ITEM_LIST[item.name] = ITEM_LIST[item.name] + item.count
                else
                    ITEM_LIST[item.name] = item.count
                end
            end

        end
    end
    ITEM_COUNT = ITEM_LIST
    return ITEM_LIST, ITEM_COUNT
end

local function list_sort(list, term)
    local sorted_list = {}
    for item_name, item_count in pairs(list) do
        if string.find(item_name, term) then
            table.insert(sorted_list, item_name)
        end
    end
    return sorted_list
end

local function pretty_table(list, selected_index, count)
    term.setCursorPos(1, 1)
    term.clear()
    for key, value in pairs(list) do
        if key == selected_index then
            pretty_print(value .. " : "..count[value], selected_index)
        else
            print(value .. " : "..count[value])
        end
    end
end

local function selector(list, count)
    local selected_index = 1
    if next(list) == nil then
        return false
    end
    pretty_table(list, 1, count)
    while true do
        local event, key = os.pullEvent("key")
        if key == keys.up then
            selected_index = selected_index - 1
        elseif key == keys.down then
            selected_index = selected_index + 1
        elseif key == keys.enter then
            SELECTED_ITEM = list[selected_index]
            return SELECTED_ITEM
        elseif key == keys.q then
            break
        end

        if selected_index <= 0 then
            selected_index = #list
        elseif selected_index > #list then
            selected_index = 1
        end

        pretty_table(list, selected_index, count)
    end
end

local function amount_selector(options, isRun)
    local INDEX = 1
    if not isRun then
        term.clear()
        term.setCursorPos(1,1)
        print("Item not found :(")
        sleep(1)
        return 0
    end
    pretty_write(options,  1)
    while true do
        local event, key = os.pullEvent("key")
        if key == keys.up then
            INDEX = INDEX - 1
        elseif key == keys.down then
            INDEX = INDEX + 1
        elseif key == keys.enter then
            local amount_selected = options[INDEX]
            if amount_selected == "  Custom  " then
                amount_selected = user_input("Amount >")
            end
            return amount_selected
        elseif key == keys.q then
            return 0
        end

        if INDEX <= 0 then
            INDEX = #options
        elseif INDEX > #options then
            INDEX = 1
        end

        pretty_write(options, INDEX)
    end
end

local function grab_item(item_name, amount)
    INPUT_CHEST = TableConcat({ peripheral.find("minecraft:chest")}, {peripheral.find("storagedrawers:controller")})
    OUTPUT_BARREL = peripheral.find("minecraft:barrel")

    local amount_grabbed = tonumber(amount)
    for _, chest in pairs(INPUT_CHEST) do
        local chest_list = chest.list()
        for i = 1, #chest_list do
            local item = chest_list[i]
            if item then
                if item.name == item_name then
                    OUTPUT_BARREL.pullItems(peripheral.getName(chest), i, amount_grabbed)
                    amount_grabbed = amount_grabbed - item.count
                end
            end

        end
    end
end

while true do
    STARTUP_SCREEN()
    local event, key = os.pullEvent("key")
    if key == keys.i then
        sleep(0.1)
        local input = user_input("Search >")
        local list, count = get_item_list()
        list = list_sort(list, input)


        local item = selector(list, count)
        local item_amount = amount_selector(options, item)
        if item then
            grab_item(item, item_amount)
        end


    elseif key == keys.q then
        sleep(0.1)
        break
    end
end
