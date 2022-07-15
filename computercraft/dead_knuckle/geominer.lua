local geo = peripheral.find("geoScanner")
if arg[1] == null then
whatLooking = "ore"
else    
what Looking = tostring(arg[1])
end
term.clear()
term.setCursorPos(1,1)
print("Radius: ")
local r = read()
print("Compass Direction: ")
local com = read()
r = tonumber(r)
print("Put fuel in slot 16")
function fuelCheck()
    local f = turtle.getFuelLevel()
    if f <= r+5 then
        turtle.select(16)
        turtle.refuel(64)
    end
end

function main()
    for i = 1,r do
        turtle.dig()
        turtle.forward()
        turtle.digDown()
    end
    fuelCheck()
    local a = geo.scan(r)
    term.clear()
    for i,v in ipairs(a) do
        if string.find(a[i].name,"ore") then
            print(string.gsub(string.gsub(a[i].name,"minecraft:",""),"_"," ").." is at "..a[i].x.." "..a[i].y.." "..a[i].z)
        end
    end
    os.pullEvent()
end

while true do
    main()
end