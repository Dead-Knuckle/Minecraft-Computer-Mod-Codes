--[[
	Uses .fcpnt files, which is just a lua table in a file. I made a "new file type" just so you could know what files are for facePaint
	It tells you its usage when you run the command.
	By: 123yeah_boi321
]]--
local completion = require "cc.completion"
local colors_inverse = {}
for k, v in pairs(colors) do colors_inverse[v] = k end
if peripheral.find("monitor") then m = peripheral.find("monitor") else printError("Error: A monitor must be connected") end

function background(z,fL)
    z = string.gsub(z,"background ","")
    if string.find(z,"bg") == 1 then z = string.gsub(z,"bg ","")end
    local k = m.getBackgroundColor()
    if colors[z] then k = colors[z] else print("Usage: background <color>") end
    m.setBackgroundColor(k)
    m.clear()
    for i = 1,#fL-3 do
        for j = 1, #fL[i] do
            m.setCursorPos(i,j)
            if fL[i][j] ~= "" then m.blit(" ",tostring(fL[i][j]),tostring(fL[i][j])) end
        end
    end
    return k
end

function setColor(z,current)
    z = string.gsub(z,"draw ","")
    local k = current
    if colors[z] then k = colors[z] end
    return k
end

function help(z)
    print("help: shows commands")
    print("draw: starts drawing | draw <color>")
    print("colors: shows the avaliable colors")
    print("erase: erases")
    print("background: set background color | background <color> | shortcut: bg <color>")
    print("close: closes the Face Paint Terminal")
end

function printColors()
    print("white")
    print("orange")
    print("magenta")
    print("lightBlue")
    print("yellow")
    print("lime")
    print("pink")
    print("gray")
    print("lightGray")
    print("cyan")
    print("purple")
    print("blue")
    print("brown")
    print("green")
    print("red")
    print("black")
end

local existing = false
local args = {...}
local loading = false

if args[1] == "load" then
    loading = true
end

if args[1] then
    if args[2] ~= nil then faceName = args[2] else print("File name: ") faceName = read() end
    if fs.exists(faceName..".fcpnt") then
        face = fs.open(faceName..".fcpnt","r")
        existing = true
    else
        if loading == true then
            printError("No file called "..faceName)
            return false
        end
        print("No file called "..faceName..". Make a new file? Y/N")
        local n = read()
        if n == "y" or n == "ye" or n == "yes" then
            face = fs.open(faceName..".fcpnt","w")
        else
            return "canceled"
        end
    end
end

local fileList = {}
local sizeX,sizeY = m.getSize()

if existing == true then
    local tempList = textutils.unserialize(face.readAll())
    if sizeX ~= tempList["width"] or sizeY ~= tempList["height"] then
        printError("This face file is a different size than the current monitor size you have connected!")
        printError("The monitor should be "..tempList["width"].."x"..tempList["height"].." pixels")
        return false
    end
    fileList = tempList
    background(colors_inverse[fileList["background"]],fileList)
    face.close()
    if loading == true then
        return true
    end
    face = fs.open(faceName..".fcpnt","w")
else
    for i = 1,sizeX do
        fileList[i] = {}
        for j = 1,sizeY do
            fileList[i][j] = ""
        end
    end
    fileList["background"] = colors.black
end

fileList["width"],fileList["height"] = m.getSize()

if args[1] ~= "edit" then
    print("Usage: facepaint <edit | load> [file]")
    return false
end

term.clear()
term.setCursorPos(1,1)
term.blit("Face Paint Terminal","4444444444444444444","fffffffffffffffffff")
term.setCursorPos(1,2)
print("Type help for help, draw to start drawing")

local erase = false
local color = colors.white
local commands = {"help","background","bg","draw","close","erase","colors","data"}
local history = {}
local start = true
while true do
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "monitor_touch" then
        x = eventData[3]
        y = eventData[4]
    end
    if eventData[1] == "mouse_click" or eventData[1] == "key" or start == true then
        erase = false
        repeat
            term.blit("> ","44","ff")
            local n = read(nil,history,function(text) if text ~= "" then return completion.choice(text, commands) else return "" end end)
            table.insert(history,n)
            if string.find(n,"background") == 1 or string.find(n,"bg") == 1 then
                fileList["background"] = background(n,fileList)
            elseif string.find(n,"help") == 1 then
                help(n)
            elseif string.find(n,"draw") == 1 then
                color = setColor(n,color)
            elseif n == "close" then
                face.write(textutils.serialize(fileList,{compact = true}))
                face.close()
                m.setBackgroundColor(colors.black)
                m.clear()
                term.clear()
                term.setCursorPos(1,1)
                shell.run("rom/startup.lua")
                return true
            elseif n == "erase" then
                erase = true
            elseif n == "colors" then
                printColors()
            elseif n == "data" then
                print("width: "..fileList["width"])
                print("height: "..fileList["height"])
                print("background: "..colors.toBlit(fileList["background"]))
            else
                printError("No such command")
            end
        until(string.find(n,"draw") == 1 or erase == true)
        if erase == true then print("Click or press any key to stop erase mode") else print("Click or press any key to stop draw mode") end
    elseif eventData[1] == "monitor_touch" then
        m.setCursorPos(eventData[3],eventData[4])
        if erase == true then
            local u = colors.toBlit(m.getBackgroundColor())
            m.setCursorPos(eventData[3],eventData[4])
            m.blit(" ",u,u)
            fileList[x][y] = ""
        else
        m.blit(" ",colors.toBlit(color),colors.toBlit(color))
        fileList[x][y] = colors.toBlit(color)
        end
    end
    start = false
end
