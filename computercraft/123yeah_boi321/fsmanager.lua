
--[[This is a file system manager, made by 123yeah_boi321, and I hope you can make good use of it! It acts as a way to browse through all your files on a computer, edit them, and run them
It will automatically be used on a monitor if there is one connected to the computer, I am going to make it be boolean once I get to it]]--

--[[This is how you can use the program, run it to open the file explorer:

local fsm = require("fsmanager")
fsm.main(false,"","")
]]--

m = peripheral.find("monitor")
if peripheral.find("speaker") then
    s = peripheral.find("speaker")
end
local fsm = {}

function fsm.readDir(disk,name)
	if disk == true then
        n = "disk/"..name
    else
        n = name
    end
    if fs.isDir(n) == true then
        count = 0
        for i,v in ipairs(fs.list(n)) do
			count = count + 1
        end   
        return true, fs.list(n), count, n
    else
        return false, "The input, "..n.." was not a directory!", count
    end
	
end

function fsm.selectionBoxes(direct,backButton,list)
	if backButton == true then
        m.setCursorPos(1,1)
        m.blit("<","f","e")
    end
    for i,v in ipairs(list) do
        m.setCursorPos(2,i+1)
		if fs.isDir(direct.."/"..v) then
			m.blit("[ }","000","fff")
		else
			m.blit("( )","000","fff")
		end
        local c = string.rep("0",string.len(v))
        local b = string.rep("f",string.len(v))
        m.blit(v,c,b)
    end
end

function fsm.selectBox(x,y,text,color,back)
	m.setCursorPos(x,y)
    local c = string.rep(color,string.len(text)) 
    local b = string.rep(back,string.len(text))   
    m.blit(text,c,b)
end

function fsm.selection(dire,isX,tsil,isSelection,isFirst,winMon,inCheese,inBeese,length)
	local event, doesntmatter, x, y = os.pullEventRaw(winMon)
    fsm.selectionBoxes(dire,isX,tsil)
    if type(doesntmatter) == "string" or doesntmatter == 1 then
		if x >= inBeese and x <= inBeese+string.len("  rename ") and y == inCheese+1 then
			m.clear()
			fsm.selectionBoxes(dire,isX,tsil)
			m.setCursorPos(3,inCheese+1)
			m.blit(" ","0","8")
			return false,"rename",y,x
		elseif x >= 2 and y >= 2 and y <= length+1 then
			m.clear()
			fsm.selectionBoxes(dire,isX,tsil)
			m.setCursorPos(3,y)
			m.blit(" ","0","8")
			s.playNote("bit",100,16)
			fsm.selectBox(3,1,"  select  ","f","0")
			fsm.selectBox(15,1," edit ","f","0")
			return false,"true", y-1
		elseif x == 1 and y == 1 and isFirst == true then
			s.playNote("bit",100,6)
			m.clear()
			fsm.selectBox(3,1,"  select  ","f","f")
			return true,"true"
		elseif x  >= 3 and x <= 3+string.len("  select  ") and y == 1 and isSelection == true then
			m.clear()
			s.playNote("bit",100,24)
			return false,"next",y
		elseif x >= 15 and x <= 15+string.len(" edit ") and y == 1 and isSelection == true then
			m.clear()
			s.playNote("bit",100,16)
			sleep(0.1)
			s.playNote("bit",100,18)
			sleep(0.1)
			s.playNote("bit",100,24)
			return false,"edit",y
		elseif x == 1 or y >= length+2 or y == 1 then
			fsm.selectionBoxes(dire,isX,tsil)
			fsm.selectBox(3,1,"  select  ","f","f")
			return false, "false"
		end
	elseif doesntmatter == 2 then
		m.clear()
		fsm.selectionBoxes(dire,isX,tsil)
		m.setCursorPos(3,inCheese+1)
		m.blit(" ","0","8")
		fsm.selectBox(x,y,"  rename ","f","0")
		return false,"menu",y,x
	end
end

function fsm.main(isOnDisk,directory,first)
	if peripheral.find("monitor") then
		m = peripheral.find("monitor")
		click = "monitor_touch"
	else
		m = window.create(term.current(),1,1,45,20)
		click = "mouse_click"
	end
	if peripheral.find("speaker") then
		s = peripheral.find("speaker")
	end
	m.clear()
	local check,list,length,dirName = fsm.readDir(isOnDisk,directory)
	local isFirstDirectory = true
	local diskCheck = isOnDisk
	burger = false
	if directory == first then
		isFirstDirectory = false
	end
	m.clear()
	fsm.selectionBoxes(directory,isFirstDirectory,list)
	cheese = -100
	beese = -100
	while true do
		local mm,n,y,x = fsm.selection(directory,isFirstDirectory,list,burger,isFirstDirectory,click,cheese,beese,length)
		if mm == true then
			fsm.main(isOnDisk,fs.getDir(directory),first)
			break
	    elseif n == "next" then
		   burger = true
			if fs.isDir(dirName.."/"..list[cheese]) == true then
				fsm.main(isOnDisk,directory.."/"..list[cheese],first)
			else
				local id = shell.openTab(dirName.."/"..list[cheese])
				shell.switchTab(id)
				fsm.main(isOnDisk,directory,first)
			end
			break
		elseif n == "edit" then
			burger = true
			if fs.isDir(dirName.."/"..list[cheese]) == false then
				local id = shell.openTab("edit "..dirName.."/"..list[cheese])
				shell.switchTab(id)
				fsm.main(isOnDisk,directory,first)
			end
			break
	    elseif n == "rename" then
			fsm.selectBox(5,cheese+1,list[cheese],"f","f")
			m.setCursorPos(5,cheese+1)
			shell.run("rename "..dirName.."/"..list[cheese].." "..dirName.."/"..read())
			fsm.main(isOnDisk,directory,first)
			break
		else
			if n == "menu" then
				beese = x
			else
				cheese = y
			end
			if n == "true" then
				burger = true
			end
	    end
	end
end

return fsm
