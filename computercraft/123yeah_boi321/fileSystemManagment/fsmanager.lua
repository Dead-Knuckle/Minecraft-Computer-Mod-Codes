--[[This is a file system manager, made by 123yeah_boi321, and I hope you can make good use of it! It acts as a way to browse through all your files on a computer, edit them, and run them
It will automatically be used on a monitor if there is one connected to the computer, I am going to make it be boolean once I get to it]]--

--[[This is an example of how you use the file manager, run code similar to this to open it:
local fsm = require("fsmanager")
local dB,dT,dF,dS =fsm.main(false,"","",0)
term.clear
while true do
	local dBt,dTt,dFt,dSt = fsm.main(dB,dT,dF,dS)
	dB = dBt
	dT = dTt
	dF = dFt
	dS = dSt
end
]]--

local fsm = {}

function fsm.playNote(inst,vol,pitch)
	return false
end

function fsm.readDir(disk,name)
	if disk == true then
        n = "disk/"..name
    else
        n = name
    end
    if fs.isDir(n) == true then
        return true, fs.list(n), table.getn(fs.list(n)), n
    else
        return false, "The input, "..n.." was not a directory!", count
    end
	
end

function fsm.selectionBoxes(direct,backButton,list,start)
	if backButton == true then
       		m.setCursorPos(1,1)
		m.blit("<","f","e")
    	end
	if table.getn(list) > 19 then
		m.setCursorPos(1,2)
		m.blit("^","0","4")
		m.setCursorPos(1,3)
		m.blit("v","0","4")
	end
    	for i,v in ipairs(list) do
       		m.setCursorPos(2,i+1)
		yhn = i + start
		if yhn > #list then break end
		if fs.isDir(direct.."/"..list[yhn]) then
			m.blit("[ }","000","fff")
		else
			m.blit("( )","000","fff")
		end
        	local c = string.rep("0",string.len(list[yhn]))
        	local b = string.rep("f",string.len(list[yhn]))
        	m.blit(list[yhn],c,b)
  	end
end

function fsm.selectBox(x,y,text,color,back)
	m.setCursorPos(x,y)
    local c = string.rep(color,string.len(text)) 
    local b = string.rep(back,string.len(text))   
    m.blit(text,c,b)
end

function fsm.selection(dire,isX,tsil,isSelection,isFirst,winMon,inCheese,inBeese,length,scrDis)
	local returned = false
	local scrollDis = scrDis
	repeat
		local evDa = {os.pullEvent()}
		local doesntmatter = evDa[2]
		local x = evDa[3]
		local y = evDa[4]
		if evDa[1] == "mouse_scroll" then
			scrollDis = scrollDis + doesntmatter
			if scrollDis < 0 then scrollDis = 0 end
			m.clear()
			fsm.selectionBoxes(dire,isX,tsil,scrollDis)
		elseif evDa[1] == winMon then
			returned = true
			fsm.selectionBoxes(dire,isX,tsil,scrollDis)
			if type(doesntmatter) == "string" or doesntmatter == 1 then
				if x >= inBeese and x <= inBeese+string.len("  rename ") and y == inCheese+1-scrollDis then
					m.clear()
					fsm.selectionBoxes(dire,isX,tsil,scrollDis)
					m.setCursorPos(3,inCheese+1-scrollDis)
					m.blit(" ","0","8")
					return false,"rename",y+scrollDis,x,scrollDis
				elseif x >= 2 and y >= 2 and y <= length+1-scrollDis then
					m.clear()
					fsm.selectionBoxes(dire,isX,tsil,scrollDis)
					m.setCursorPos(3,y)
					m.blit(" ","0","8")
					s.playNote("bit",1,16)
					fsm.selectBox(3,1,"  select  ","f","0")
					fsm.selectBox(15,1," edit ","f","0")
					return false,"true",y-1+scrollDis,x,scrollDis
				elseif x == 1 and y == 1 and isFirst == true then
					s.playNote("bit",1,6)
					m.clear()
					fsm.selectBox(3,1,"  select  ","f","f")
					return true,"true",y+scrollDis,x,scrollDis
				elseif x  >= 3 and x <= 3+string.len("  select  ") and y == 1 and isSelection == true then
					m.clear()
					s.playNote("bit",1,24)
					return false,"next",y+scrollDis,x,scrollDis
				elseif x >= 15 and x <= 15+string.len(" edit ") and y == 1 and isSelection == true then
					m.clear()
					s.playNote("bit",1,16)
					sleep(0.1)
					s.playNote("bit",1,18)
					sleep(0.1)
					s.playNote("bit",1,24)
					return false,"edit",y+scrollDis,x,scrollDis
				elseif x == 1 or y >= length+2-scrollDis or y == 1 then
					fsm.selectionBoxes(dire,isX,tsil,scrollDis)
					fsm.selectBox(3,1,"  select  ","f","f")
					fsm.selectBox(15,1," edit ","f","f")
					return false, "false",y+scrollDis,x,scrollDis
				end
			elseif doesntmatter == 2 then
				m.clear()
				fsm.selectionBoxes(dire,isX,tsil,scrollDis)
				m.setCursorPos(3,inCheese+1-scrollDis)
				m.blit(" ","0","8")
				fsm.selectBox(x,y,"  rename ","f","0")
				return false,"menu",y+scrollDis,x,scrollDis
			end
		end
	until(returned == true)
end

function fsm.main(isOnDisk,directory,first,doascroll)
	if peripheral.find("monitor") then
		m = peripheral.find("monitor")
		clickVar = "monitor_touch"
	else
		m = window.create(term.current(),1,1,45,20)
		clickVar = "mouse_click"
	end
	if peripheral.find("speaker") then
		s = peripheral.find("speaker")
	else
		s = fsm
	end
	m.clear()
	local check,list,length,dirName = fsm.readDir(isOnDisk,directory)
	local isFirstDirectory = true
	local diskCheck = isOnDisk
	local burger = false
	if directory == first then
		isFirstDirectory = false
	end
	m.clear()
	local churger = doascroll
	local whydoIdothis = 0
	fsm.selectionBoxes(directory,isFirstDirectory,list,churger)
	local cheese = -100
	local beese = -100
	local hurburderber = directory
	while true do
		local mm,n,nY,nX,aaaaa = fsm.selection(directory,isFirstDirectory,list,burger,isFirstDirectory,clickVar,cheese,beese,length,churger)
		if mm == true then
			hurburderber = fs.getDir(directory)
			break
	    elseif n == "next" then
		   burger = true
			if fs.isDir(dirName.."/"..list[cheese]) == true then
				hurburderber = directory.."/"..list[cheese]
			else
				local id = shell.openTab(dirName.."/"..list[cheese])
				shell.switchTab(id)
				whydoIdothis = aaaaa
			end
			break
		elseif n == "edit" then
			burger = true
			if fs.isDir(dirName.."/"..list[cheese]) == false then
				local id = shell.openTab("edit "..dirName.."/"..list[cheese])
				shell.switchTab(id)
				whydoIdothis = aaaaa
			end
			break
	    elseif n == "rename" then
			fsm.selectBox(5,cheese+1-aaaaa,list[cheese],"f","f")
			m.setCursorPos(5,cheese+1-aaaaa)
			shell.run("rename "..dirName.."/"..list[cheese].." "..dirName.."/"..read())
			whydoIdothis = aaaaa
			break
		else
			if n == "menu" then
				beese = nX
			else
				cheese = nY
			end
			if n == "true" then
				burger = true
			elseif n == "false" then
				burger = false
			end
	    end
		churger = aaaaa
	end
	return isOnDisk,hurburderber,first,whydoIdothis
end

return fsm
