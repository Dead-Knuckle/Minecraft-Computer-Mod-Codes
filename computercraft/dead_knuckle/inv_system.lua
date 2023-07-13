local function pretty_print(strvalue, index)
    term.setCursorPos(1, index)
    term.clearLine()
    term.setCursorPos(1, index)
    term.setBackgroundColor(colors.purple)
    print(strvalue)
    term.setBackgroundColor(colors.black)
end

local function pretty_write(namestr, valuestr, color)
    term.setTextColor(colors.white)
    io.write(namestr..": ")
    term.setTextColor(color)
    print(valuestr)
    term.setTextColor(colors.white)
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

local function user_input()
    local w, h = term.getSize()
    term.setCursorPos(1, h)
    io.write("Search: ")
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
    while true do
        local event, key = os.pullEvent("key")
        if key == keys.up then
            selected_index = selected_index - 1
        elseif key == keys.down then
            selected_index = selected_index + 1
        elseif key == keys.enter then
            ITEM_TO_GRAB = list[selected_index]
            return ITEM_TO_GRAB
        elseif key == keys.q then
            break
        end

        if selected_index <= 0 then
            selected_index = 1
        elseif selected_index > #list then
            selected_index = #list
        end

        pretty_table(list, selected_index, count)
    end
end

local function grab_item(item_name)
    INPUT_CHEST = TableConcat({ peripheral.find("minecraft:chest")}, {peripheral.find("storagedrawers:controller")})
    OUTPUT_BARREL = peripheral.find("minecraft:barrel")
    for _, chest in pairs(INPUT_CHEST) do
        local chest_list = chest.list()
        for i = 1, #chest_list do
            local item = chest_list[i]
            if item then
                if item.name == item_name then
                    OUTPUT_BARREL.pullItems(peripheral.getName(chest), i)
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
        local input = user_input()
        local list, count = get_item_list()
        list = list_sort(list, input)

        pretty_table(list, 1, count)
        local item = selector(list, count)

        grab_item(item)

    elseif key == keys.q then
        sleep(0.1)
        break
    end
end
