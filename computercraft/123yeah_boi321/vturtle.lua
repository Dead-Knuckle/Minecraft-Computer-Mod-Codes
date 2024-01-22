scanner = peripheral.find("plethora:scanner")
local vturtle = {}
vturtle.x = 0
vturtle.y = 0
vturtle.z = 0
vturtle.facing = {x=0,z=0}

function checkFacing()
	local dta = {x=0,z=0}
	turtle.select(16)
	local heldItem = turtle.getItemDetail()
	turtle.place()
	if scanner.getBlockMeta(1,0,0).name == heldItem.name then dta.x = 1
	elseif scanner.getBlockMeta(-1,0,0).name == heldItem.name then dta.x = -1
	elseif scanner.getBlockMeta(0,0,1).name == heldItem.name then dta.z = 1
	elseif scanner.getBlockMeta(0,0,-1).name == heldItem.name then dta.z = -1 end
	turtle.dig()
	return dta
end
vturtle.facing = checkFacing()

function vturtle.forward()
	if turtle.getFuelLevel > 0 then
		turtle.forward()
		vturtle.x = vturtle.x + vturtle.facing.x
		vturtle.z = vturtle.z + vturtle.facing.z
	end
end

function vturtle.back()
	if turtle.getFuelLevel > 0 then
		turtle.back()
		vturtle.x = vturtle.x - vturtle.facing.x
		vturtle.z = vturtle.z - vturtle.facing.z
	end
end

function vturtle.turnRight()
	turtle.turnRight()
	vturtle.facing = {x=-vturtle.facing.z,z=vturtle.facing.x}
end

function vturtle.turnLeft()
	turtle.turnLeft()
	vturtle.facing = {x=vturtle.facing.z,z=-vturtle.facing.x}
end
