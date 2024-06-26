bt = require("btfuncs")

REQUEST_FUEL = false

local ore_list = {
    --Ore Groups
    ["minecraft:diamond_ore"] = 1,
    ["minecraft:deepslate_diamond_ore"] = 1,

    ["minecraft:emerald_ore"] = 1,
    ["minecraft:deepslate_emerald_ore"]= 1,


    ["minecraft:gold_ore"] = 1,
    ["minecraft:deepslate_gold_ore"] = 1,
    ["minecraft:nether_gold_ore"] = 1,

    ["minecraft:iron_ore"] = 1,
    ["minecraft:deepslate_iron_ore"] = 1,
}

local fuel_sources = {
    ["minecraft:coal"] = 1,
    ["minecraft:coal_block"] = 1,
    ["minecraft:charcoal"] = 1,
    ["minecraft:blaze_rod"] = 1,
}

local blackList_and_fill_blocks = {
    ["minecraft:stone"] = 1,
    ["minecraft:cobblestone"] = 1,
    ["minecraft:dirt"] = 1,
    ["minecraft:granite"] = 1,
    ["minecraft:diorite"] = 1,
    ["minecraft:gravel"] = 1,
    ["minecraft:flint"] = 1,
    ["minecraft:netherrack"] = 1,
    ["minecraft:tuff"] = 1,
}

local function auto_refuel()
    if turtle.getFuelLevel() < 50 then
        do return end
    end
    for inv_slot = 1, 16, 1 do
        local item_detail = turtle.getItemDetail(inv_slot)
        if item_detail and fuel_sources[item_detail.name] then
            local return_slot = turtle.getSelectedSlot()
            turtle.select(inv_slot)
            local fuel_count = item_detail.count
            repeat
                turtle.refuel(1)
                fuel_count = fuel_count - 1
            until turtle.getFuelLevel() > 200 or fuel_count == 0
        end
    end
end


local function single()
    for block = 1,5 do
        auto_refuel()
        turtle.dig()
        turtle.forward()
        bt.dfs_mine(ore_list, blackList_and_fill_blocks)
    end

    for i = 1, 5, 1 do
        turtle.back()
    end
end

local function side_branch()
    local switcher = false

    for branch = 1, 20, 1 do
        auto_refuel()

        turtle.dig()
        turtle.forward()
        bt.dfs_mine(ore_list, blackList_and_fill_blocks)
        turtle.digUp()
        turtle.digDown()

        if switcher then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end

        single()

        if not switcher then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
        switcher = not switcher
    end
end


local function main_branch()
    --pass
end




local function main()
    side_branch()
end


main()
