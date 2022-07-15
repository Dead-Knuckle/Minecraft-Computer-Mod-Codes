local geo = peripheral.find("geoScanner")

if arg[1] == null then
whatLooking = "ore"
else    
whatLooking = tostring(arg[1])
end
print("Radius: ")
local r = read()
print("Compass Direction: ")
local com = read()
r = tonumber(r)
print("Put fuel in slot 16")
sleep(1)
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
parrot = {}
action = 'boat'
term.setCursorPos(1,2)
print('Moving...')
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
print('=======================================')
term.setCursorPos(1,3)
 for i,v in ipairs(a) do
    if string.find(a[i].name,whatLooking) then
        print(string.gsub(string.gsub(a[i].name,"minecraft:",""),"_"," ").." is at "..a[i].x.." "..a[i].y.." "..a[i].z)
        table.insert(parrot, a[i].name)
    end
print('=======================================')
 if parrot[0] == nil then
 print("No ores")
 sleep(0.5)
 term.clear()
 term.setCursorPos(1,1)
 else 
 print('Please press enter to move forward '.. r .. ' blocks.')
 action = read()
  if action == "e" then
     break
  end
  if action == "l" then
    turtle.turnLeft()
  end
  if action == "r" then
  turtle.turnLeft()
  end
end
end
end
while true do
    main()
end
