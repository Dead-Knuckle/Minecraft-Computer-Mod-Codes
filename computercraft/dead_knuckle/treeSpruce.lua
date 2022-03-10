function refuel()
term.setCursorPos(1,2)
repeat
 term.clearLine()
  print("Fuel: ".. turtle.getFuelLevel())
turtle.select(16)
 turtle.refuel(1)
turtle.select(1)
until(turtle.getFuelLevel() > 200)
end
function chop()
 turtle.select(16)
 turtle.dig()
 turtle.forward()
 turtle.dig()
 turtle.forward()
 turtle.turnLeft()
 turtle.turnLeft()
 while turtle.detectUp() do
 turtle.dig()
 turtle.digUp()
 refuel()
 turtle.up()
 x=x+1
 end
 turtle.turnLeft()
 turtle.dig()
 refuel()
 turtle.forward()
 turtle.turnRight()
 for i = 1,x do
 refuel()
 turtle.dig()
 turtle.digDown()
 turtle.down()
 end
 turtle.dig()
end
function plant()
turtle.select(1)
turtle.up()
turtle.placeDown()
turtle.forward()
turtle.placeDown()
turtle.turnRight()
turtle.forward()
turtle.placeDown()
turtle.turnRight()
turtle.forward()
turtle.placeDown()
turtle.turnLeft()
turtle.turnLeft()
turtle.forward()
turtle.dig()
turtle.forward()
turtle.dig()
turtle.down()
turtle.turnLeft()
turtle.turnLeft()
turtle.select(16)
end
function drop()
for i = 2,15 do
turtle.down()
turtle.select(i)
turtle.dropDown()

end
turtle.select(16)
end
function timer()
time = 120
for i = 1,tonumber(time) do
sleep(1)
term.setCursorPos(1,1)
term.clearLine()
print("Time until next check: ".. i.."/"..  time)
end
end
while true do
turtle.select(16)
refuel()
turtle.digUp()
turtle.up()
turtle.select(16)
if turtle.compare() then
x=0
chop()
plant()
drop()
end
turtle.down()
timer()
end
