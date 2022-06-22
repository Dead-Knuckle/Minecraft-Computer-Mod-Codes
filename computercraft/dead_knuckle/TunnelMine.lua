--This program is for minning
--It can use ender chest or shulkerboxes for extra storgae, recommended that you use ender chest or something simlar 
-- It mines out tunnels, 30 long it will use torches, use coal as fuel for best results 
--Made by: Dead_Knuckle
function start()
  print("Please Place Torches in Slot 1")
  print("Please Place Fuel in Slot 16")
  sleep(2)
  term.clear()
  term.setCursorPos(1,1)
  print("How many Tunnels")
  x = read()
   tunnelAmount =x 
  term.clear()
  term.setCursorPos(1,1)
  print("Storage? (y/n)")
   s =read() 
   if s == "y" then
    print("Please Place In Slot 15")
    sleep(2)
   end  
    term.clear()
end
function echest()
  if s == "y" then
    turtle.select(15)
  turtle.placeUp()
   for i = 2,14 do
   turtle.select(i)
   turtle.dropUp()
   end
   turtle.select(15)
   turtle.digUp()
  turtle.select(1)
  end
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
function invSort()   
  turtle.select(1)
blackList = {"minecraft:stone","minecraft:cobblestone","minecraft:dirt","minecraft:granite","minecraft:diorite","minecraft:gravel","minecraft:flint", "minecraft:netherrack", "minecraft:cobbled_deepslate", "minecraft:tuff"}
    for i = 1,15 do
turtle.select(i)
x,y,z = turtle.getItemDetail()
 if turtle.getItemCount() < 1 then
 sleep(0.01)
 else
 for i,v in ipairs(blackList) do 
if x.name == "minecraft:coal" then
  turtle.transferTo(16)
end
if x.name == blackList[i] then
turtle.dropDown()
end
 end
    end
end
turtle.select(1)
end
function mine()
turtle.dig()
turtle.forward()
turtle.digUp()
turtle.digDown()
end
function tunnel()
turtle.placeDown()
  for i = 1,3 do
 for i = 1,10 do
 refuel()
 turtle.dig()
 turtle.forward()
 turtle.digUp()
 turtle.digDown()
 end
  turtle.placeDown() 
  end
invSort() 
echest()  
 for i = 1,30 do
 turtle.back()
 end
end
function main()
start()
  for i = 1,x do
term.setCursorPos(1,2)
print("Tunnel:"..i.."/"..tunnelAmount)
term.setCursorPos(1,1)
tunnel()
turtle.turnLeft()
mine()
mine()
mine()
turtle.turnRight()
term.clear()
 end
end
main()
echest()
