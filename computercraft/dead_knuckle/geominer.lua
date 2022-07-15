local geo = peripheral.find("geoScanner")
if arg[1] == null then
whatLooking = "ore"
else    
whatLooking = tostring(arg[1])
end
term.clear()
term.setCursorPos(1,1)
print("Radius: ")
local r = read()
print("Compass Direction: ")
local com = read()
r = tonumber(r)
print("Put fuel in slot 16")
term.clear()
term.setCursorPos(1,1)
function refuel()
    term.setCursorPos(1,1)
    print("Fuel:"..turtle.getFuelLevel())
    if turtle.getFuelLevel() < 100 then
    turtle.select(16)
    turtle.refuel(1)
    turtle.select(1)
    end
   end

function main()
    for i = 1,r do
        turtle.dig()
        refuel()
        turtle.forward()
        turtle.digDown()
    end
    local a = geo.scan(r)
    term.clear()
    refuel()
    term.setCursorPos(1,2)
    for i,v in ipairs(a) do
        if string.find(a[i].name,whatLooking) then
            print(string.gsub(string.gsub(a[i].name,"minecraft:",""),"_"," ").." is at "..a[i].x.." "..a[i].y.." "..a[i].z)
        end
    end
    print('Please press enter to move forward '.. r .. ' blocks.')
    read()
end

while true do
    main()
end
