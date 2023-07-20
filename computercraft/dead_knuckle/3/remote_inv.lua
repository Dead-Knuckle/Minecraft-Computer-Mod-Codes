peripheral.find("modem", rednet.open)

local options = {"    01    ","    16    ","    32    ","    64    ","  Custom  ",}

INV_ID = 4

colors_config = {
    ["list"] = colors.lime,
    ["amount"] = colors.pink,
    ["default"] = colors.black,
}

function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function split(inputstr, sep)
    if inputstr == nil then
        return {"",""}
    end
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
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
    printToCenter("---AMOUNT---\n", 5)
    for i = 1, #list, 1 do
        if i == INDEX then
            term.setBackgroundColor(colors_config["amount"])
        end
        printToCenter("|"..list[i].."|", 5-i)
        term.setBackgroundColor(colors_config["default"])
        last = i
    end
    printToCenter("------------", 5-(last+1))
end



local function STARTUP_SCREEN()
    term.clear()
    term.setCursorPos(1,1)
    print("|\\[~ /||\\|\\/\\(`")
    io.write("|/[_/-||/|/\\/_)  ")



    term.setTextColor(colors.yellow)
    print("\nv.3 --Remote")
    term.setTextColor(colors.white)
    print("\nPush \"i\" to input a search term or \"q\" to exit...")
end

local function user_input(user_message)
    local _, h = term.getSize()
    term.setCursorPos(1, h)
    io.write(user_message)
    return io.read()
end

function GET_INV()
    rednet.send(INV_ID, "get_inv")
    local _, message = rednet.receive()

    return message[1], message[2]
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
        local itemsep = split(value, ":")
        if key == selected_index then
            term.setCursorPos(1, selected_index)
            term.clearLine()
            term.setBackgroundColor(colors_config["list"])
            print(itemsep[2] .. " : "..count[value])
            term.setBackgroundColor(colors_config["default"])
        else
            print(itemsep[2] .. " : "..count[value])
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

local function SEND_GET(item_name, amount)
    rednet.send(INV_ID, {item_name, amount})
end
function main()

end

while true do
    STARTUP_SCREEN()
    local event, key = os.pullEvent("key")
    if key == keys.i then
        sleep(0.1)
        local input = user_input("Search >")
        local list, count = GET_INV()
        list = list_sort(list, input)


        local item = selector(list, count)
        local item_amount = amount_selector(options, item)
        if item then
            SEND_GET(item, item_amount)
        end


    elseif key == keys.q then
        sleep(0.1)
        break
    end
end
