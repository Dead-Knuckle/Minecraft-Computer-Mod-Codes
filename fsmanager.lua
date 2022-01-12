--This is how you can use the program, run it to open the file explorer:
--
--require("disk.ssmanager")
--fsm.main(false,"","")
--os.run({},"thisprogramsname")


m = peripheral.find("monitor")
if peripheral.find("speaker") then
    s = peripheral.find("speaker")
end
ssm = {}

function fsm.readDir(disk,name)
    print("reading inputed directory")
	if disk == true then
        n = "disk/"..name
    else
        n = name
    end
	print(n)
    if fs.isDir(n) == true then
        count = 0
        for i,v in ipairs(fs.list(n)) do
            print(v)
			count = count + 1
        end   
		print("directory found")
        return true, fs.list(n), count, n
    else
		print("The input, "..n.." was not a directory!"..count)
        return false, "The input, "..n.." was not a directory!", count
    end
	
end

function fsm.selectionBoxes(boxes,backButton,list)
    print("making selections")
	if backButton == true then
        m.setCursorPos(1,1)
        m.blit("<","f","e")
    end
    for i = 2,boxes+1 do
        m.setCursorPos(2,i)
        m.blit("[ ]","000","fff")
    end
    for i,v in ipairs(list) do
        m.setCursorPos(5,i+1)
        local c = string.rep("0",string.len(v))
        local b = string.rep("f",string.len(v))
        m.blit(v,c,b)
    end
	print("selections made")
end

function fsm.selectBox(x,y,text,color,back)
    print("printing select box")
	m.setCursorPos(x,y)
    local c = string.rep(color,string.len(text)) 
    local b = string.rep(back,string.len(text))   
    m.blit(text,c,b)
	print("printed")
end

function fsm.selection(amountOfBoxes,isX,tsil,isSelection,isFirst)
    print("checking for selection")
	local event, side, x, y = os.pullEventRaw("monitor_touch")
    fsm.selectionBoxes(amountOfBoxes,isX,tsil)
    if x >= 2 and y >= 2 and y <= amountOfBoxes+1 then
        fsm.selectionBoxes(amountOfBoxes,isX,tsil)
        m.setCursorPos(2,y)
        m.blit("[ ]","000","f8f")
        s.playNote("bit",100,16)
		fsm.selectBox(3,1,"  select  ","f","0")
		fsm.selectBox(15,1," edit ","f","0")
		print("selection pressed")
        return false,"true", y-1
    elseif x == 1 and y == 1 and isFirst == true then
        s.playNote("bit",100,6)
        m.clear()
		fsm.selectBox(3,1,"  select  ","f","f")
		print("back button pressed")
        return true,"true"
    elseif x  >= 3 and x <= 3+string.len("  select  ") and y == 1 and isSelection == true then
        m.clear()
		s.playNote("bit",100,24)
		print("selection box pressed")
        return false,"next",y
    elseif x >= 15 and x <= 15+string.len(" edit ") and y == 1 and isSelection == true then
		m.clear()
		print("edit box pressed")
		s.playNote("bit",100,16)
		sleep(0.1)
		s.playNote("bit",100,18)
		sleep(0.1)
		s.playNote("bit",100,24)
		return false,"edit",y
	elseif x == 1 or y >= amountOfBoxes+2 or y == 1 then
        fsm.selectionBoxes(amountOfBoxes,isX,tsil)
		fsm.selectBox(3,1,"  select  ","f","f")
		print("empty space pressed")
        return false, "false"
    end
end

function fsm.main(isOnDisk,directory,first)
	print("This is 123yeah_boi321's file reader and selection system, that he made for his own uses, and gives to you to use as well")
	m = peripheral.find("monitor")
	if peripheral.find("speaker") then
		s = peripheral.find("speaker")
	end
	local check,list,length,dirName = fsm.readDir(isOnDisk,directory)
	local isFirstDirectory = true
	local diskCheck = isOnDisk
	local firstDirectory = first
	burger = false
	if directory == first then
		isFirstDirectory = false
	end
	m.clear()
	fsm.selectionBoxes(length,isFirstDirectory,list)
	print("boxes load check")
	while true do
		term.setCursorPos(1,1)
		local m,n,y = fsm.selection(length,isFirstDirectory,list,burger,isFirstDirectory)
		print(n)
		if m == true then
  	      print("now it will back out/back menu")
		  fsm.main(isOnDisk,fs.getDir(directory),first)
 	       break
	    elseif n == "next" then
 	       print("now it will go to the next menu, selection was: "..directory.."/"..list[cheese])
		   burger = true
			if fs.isDir(dirName.."/"..list[cheese]) == true then
				print("isDir test check")
				fsm.main(isOnDisk,directory.."/"..list[cheese],first)
			else
				local id = shell.openTab(dirName.."/"..list[cheese])
				shell.switchTab(id)
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
	    else
	        print(y)
	        cheese = y
			if n == "true" then
				burger = true
			end
	    end
		term.clear()
	end
end
