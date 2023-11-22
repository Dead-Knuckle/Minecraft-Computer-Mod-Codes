-- ver = 1.0
peripheral.find("modem", rednet.open)


DEV_MODE = false

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
    io.write("                        |______|             \n")
    term.setTextColor(colors.yellow)
    print("\nv.3 --Hub\n")
    term.setTextColor(colors.white)
    print("Press \"q\" to quit")

end


local function get_item_list()
    INPUT_CHEST = TableConcat({ peripheral.find("minecraft:chest")}, {peripheral.find("storagedrawers:controller")})
    ITEM_LIST, ITEM_COUNT = {}, {}

    for _, chest in pairs(INPUT_CHEST) do
        local chest_list = chest.list()
        for key, item in pairs(chest_list) do
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



local function grab_item(item_name, amount)
    INPUT_CHEST = TableConcat({ peripheral.find("minecraft:chest")}, {peripheral.find("storagedrawers:controller")})
    OUTPUT_BARREL = peripheral.find("enderstorage:ender_chest")

    local amount_grabbed = tonumber(amount)
    for _, chest in pairs(INPUT_CHEST) do
        local chest_list = chest.list()
        for key, item in pairs(chest_list) do
            if item then
                if item.name == item_name then
                    OUTPUT_BARREL.pullItems(peripheral.getName(chest), key, amount_grabbed)
                    amount_grabbed = amount_grabbed - item.count
                end
            end
        end
    end
end


local function get_storage_connected()
    INPUT_CHEST = TableConcat({ peripheral.find("minecraft:chest")}, {peripheral.find("storagedrawers:controller")})
    INPUT_CHEST_NAME = {}
    for i = 1, #INPUT_CHEST, 1 do
        if INPUT_CHEST[i] then
            table.insert(INPUT_CHEST_NAME, peripheral.getName(INPUT_CHEST[i]))
        end
    end
    return INPUT_CHEST_NAME
end


local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    sleep(0.1)
    term.setBackgroundColor(colors.red)
    io.write("Breaking!")
    term.setBackgroundColor(colors.black)
end
local last_item = nil
function  main()
    local clients_served = 0
while true do
    STARTUP_SCREEN()
    local _, h = term.getSize()

    term.setCursorPos(1, h-2)
    io.write("Clients Served: ")
    term.setTextColor(colors.lime)
    print(clients_served)
    term.setTextColor(colors.white)

    term.setCursorPos(1, h-1)
    io.write("Last item: ")
    term.setTextColor(colors.lime)
    print(last_item)
    term.setTextColor(colors.white)


    local id, message = rednet.receive()

    if message == "get_inv" then
        rednet.send(id, {get_item_list()})
    else if message == "get_sto" and DEV_MODE then
        rednet.send(id, get_storage_connected())
    else
        grab_item(message[1], message[2])
        last_item = message[1].. ", ".. tonumber(message[2])
        clients_served = clients_served + 1
    end
end
end
end

parallel.waitForAny(main, wait_for_q)
