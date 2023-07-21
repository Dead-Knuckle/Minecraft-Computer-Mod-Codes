
rob = false
checking = false
x=0
local geo = peripheral.find("geoScanner")
function start()
if arg[1] == null then
whatLooking = "ore"
else    
whatLooking = tostring(arg[1])
end
print("Radius: ")
local r = read()
radius = tonumber(r)
print("Put fuel in slot 16")
sleep(1)
term.clear()
term.setCursorPos(1,1)
end
function refuel()
    term.setCursorPos(1,1)
    print("Fuel:"..turtle.getFuelLevel())
    if turtle.getFuelLevel() < 100 then
    turtle.select(16)
    turtle.refuel(1)
    turtle.select(1)
    end
   end
function move ()
    term.clear()
    term.setCursorPos(1,1)
    for i = 1,radius do
        turtle.dig()
        term.setCursorPos(1,1)
        refuel()
        term.setCursorPos(1,2)
        print('Moving...')
        turtle.forward()
        turtle.digDown()
    end
end    
function scan()
    term.clear()
    refuel()
    term.setCursorPos(1,2)
    print("Looking for: ".. whatLooking)
    term.setCursorPos(1,3)
    print(whatLooking.. " gathered so  far:".. x)
print('=======================================')
        term.setCursorPos(1,4)
        a = geo.scan(radius)
    for i,v in ipairs(a) do
        if string.find(a[i].name,whatLooking) then
            print(string.gsub(string.gsub(a[i].name,"minecraft:",""),"_"," ").." is at "..a[i].x.." "..a[i].y.." "..a[i].z)
            x=x+1
            checking = true
        end
    end
print('=======================================')
end
function check()
    if not checking then
    print('No, '.. whatLooking.. ' here :[')
    sleep(1)
    else
    print(whatLooking..' was found.Please press enter to move forward '.. radius .. ' blocks. Or anyother arguments')
    cath  = read()
    if cath =="l" then
        turtle.turnLeft()
    end
    if cath == "r" then
        turtle.turnRight()
    end
    if cath == "e" then
        rob = true
    end
end
end
function main()
    move()
    scan()
    check()
end
start()
while true do
    main()
    if rob then 
     break
    end
end
