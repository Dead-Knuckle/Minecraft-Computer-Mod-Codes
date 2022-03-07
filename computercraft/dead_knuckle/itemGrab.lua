local chestGet1 = peripheral.wrap("expandedstorage:barrel_0")
local chestGet2 = peripheral.wrap("expandedstorage:barrel_1")
local chestPush = peripheral.wrap("minecraft:chest_1")
local  turtle2 = peripheral.wrap("turtle_1")
local chestSize1 = chestGet1.size()
local chestSize2 = chestGet2.size()
local mon = peripheral.wrap("monitor_11")
local mon2 = peripheral.wrap("monitor_12")
local mon3  = peripheral.wrap("monitor_13")
local mon4 = peripheral.wrap("monitor_14")
local w, h = mon.getSize()
local w2, h2 = mon2.getSize()
local w3, h3 = mon3.getSize()
local w4, h4 = mon4.getSize()
local max = h
local modem = peripheral.find("modem")
s = peripheral.find("speaker")

function style()
    y = 1
    g= 1 
    x=1
    q=1
mon.clear()
mon.setTextScale(0.5)
mon.setTextColor(  colors.lime  )
mon.setCursorPos(1, y)
mon.write("Listed Items:")
mon.setTextColor(  colors.lightBlue  )
mon2.clear()
mon2.setTextScale(0.5)
mon2.setTextColor(  colors.lime  )
mon2.setCursorPos(1, g)
mon2.write("Listed Items:")
mon2.setTextColor(  colors.lightBlue  )
mon.setTextColor(  colors.pink )
mon.setCursorPos(w-5, g)
mon.write("Count:")
mon2.setTextColor(  colors.pink )
mon2.setCursorPos(w2-5, g)
mon2.write("Count:")
mon3.clear()
mon3.setTextScale(0.5)
mon3.setTextColor(  colors.lime  )
mon3.setCursorPos(1, x)
mon3.write("Listed Items:")
mon3.setTextColor(  colors.lightBlue  )
mon3.setTextColor(  colors.pink )
mon3.setCursorPos(w3-5, x)
mon3.write("Count:")
mon4.clear()
mon4.setTextScale(0.5)
mon4.setTextColor(  colors.lime  )
mon4.setCursorPos(1, q)
mon4.write("Listed Items:")
mon4.setTextColor(  colors.lightBlue  )
mon4.setTextColor(  colors.pink )
mon4.setCursorPos(w4-5, q)
mon4.write("Count:")
end
style()
args = {...}
local itemAmount = args[1]
local itemGet = args[2]

    function main( ... )
        local itemListed = {...}
                
function yibbit()
q= q+1

mon4.setTextColor(  colors.lightBlue  )

mon4.setCursorPos(1,q)
mon4.write(a)
mon4.setTextColor( colors.orange)

 
if d > 9 then
mon4.setCursorPos(w4-1, q)
mon4.write(d)
else
mon4.setCursorPos(w4, q)
mon4.write(d)
end




end
function ribbit()
g =g+1

mon2.setTextColor(  colors.lightBlue  )

mon2.setCursorPos(1,g)
mon2.write(a)
mon2.setTextColor( colors.orange)

 
if d > 9 then
mon2.setCursorPos(w2-1, g)
mon2.write(d)
else
mon2.setCursorPos(w2, g)
mon2.write(d)
end
end 
function robbot()
    x=x+1
    mon3.setTextColor(  colors.lightBlue  )

    mon3.setCursorPos(1,x)
    mon3.write(a)
    mon3.setTextColor( colors.orange)
    
     
    if d > 9 then
    mon3.setCursorPos(w3-1, x)
    mon3.write(d)
    else
    mon3.setCursorPos(w3, x)
    mon3.write(d)
    end
if x> h3 then
yibbit()
end
end   


for i = 1,chestSize1 do 
local item = chestGet1.getItemDetail(i)
if item ~= nil then
a = item.displayName
d = item.count
table.insert(itemListed, item.name )
local itemList = item.name 
y =y+1
 if y > max then
 ribbit()
 end    
 mon.setTextColor(  colors.lightBlue  )

 mon.setCursorPos(1, y)
mon.write(a)
mon.setTextColor( colors.orange)

if d > 9 then
    mon.setCursorPos(w-1, y)
    mon.write(d)
    else
    mon.setCursorPos(w, y)
    mon.write(d)
    end



print(a)
if itemGet == itemList then
     newItemAmount = itemAmount - d

    chestGet1.pushItems(peripheral.getName(chestPush), i, tonumber(itemAmount))
 
    
 end
end
end    

if newItemAmount == nil then
newItemAmount=itemAmount
end

 for i = 1,chestSize2 do 
local item2 = chestGet2.getItemDetail(i)
if item2 ~= nil then
a = item2.displayName
d = item2.count
local itemList2 = item2.name
 if g == h3 then
    robbot()
 else
ribbit()
 end
 table.insert(itemListed, item2.name )
 print(a)
  if itemGet == itemList2 then
 chestGet2.pushItems(peripheral.getName(chestPush), i, tonumber(newItemAmount))
 
  end
 
 end

end
itemLists = itemListed
    end
    main()
    s.playNote("pling",10,13)
os.sleep(0.2)
s.playNote("pling",10,12)
os.sleep(0.2)
s.playNote("pling",10,9)
os.sleep(0.2)
s.playNote("pling",10,3)
os.sleep(0.2)
s.playNote("pling",10,2)
os.sleep(0.2)
s.playNote("pling",10,10)
os.sleep(0.2)
s.playNote("pling",10,14)
os.sleep(0.2)
s.playNote("pling",10,18)
modem.open(1)

while true do 
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")   
 print(message)
itemGet = itemLists[tonumber(message)]
print(itemGet)
mon3.write("E")
sleep(3)
main()










end    