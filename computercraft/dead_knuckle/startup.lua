x = 600
function refuel()
term.clear()
term.setCursorPos(1,1)
print("Fuel:"..turtle.getFuelLevel())
if turtle.getFuelLevel() < 100 then
turtle.select(16)
turtle.suckUp(2)
turtle.refuel(2)
turtle.select(1)
end
end
function checkGrowth()
turtle.forward()
select(1)
local sucess,data = turtle.inspectDown()
 if sucess then
term.setCursorPos(1,4)
term.clearLine()
print("Age:"..data.state.age)
 if data.state.age == 7 then
 turtle.digDown()
 turtle.placeDown()
 end
 end
end
function growthTimer()
x = 600
for i = 1,600 do
term.clear()
term.setCursorPos(1,1)
print("Time Until Harvest:"..x)
print("Fuel:"..turtle.getFuelLevel())
print("Age:N/A")
x = x -1
sleep(1)
end
end
function harvest()
 for i =1,5 do
 checkGrowth()
 end
 for i = 1,5 do
 turtle.back()
 end
end
function harvestRows()
 print(turtle.getFuelLevel())
 print("Time until Harvest: Now!")
 harvest()
 for i = 1,5 do
 turtle.turnLeft()
 turtle.forward()
 turtle.turnRight()
 harvest()
 end
turtle.turnRight()
 for i = 1,5 do
 turtle.forward()
 end
 turtle.turnLeft()
end
function inv()
turtle.select(1)
c = turtle.getItemCount()
c = c - 1
turtle.dropDown(c)
for i = 2,16 do
turtle.select(i)
turtle.dropDown()
end
turtle.select(1)
end
function main()
refuel()
harvestRows()
inv()
growthTimer()
end
while true do
main()
end
