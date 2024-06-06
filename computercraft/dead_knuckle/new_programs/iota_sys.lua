local focal = peripheral.find("focal_port")
local completion = require "cc.completion"

if not focal then
    error("Focal Port not found. Ensure it is connected and try again.", 1)
end

local function prettyPrint(color, message)
    term.setTextColor(color)
    print(message)
    term.setTextColor(colors.white)
end

local function prettyUserInput(color, prompt, choices)
    term.setTextColor(color)
    write(prompt .. " ")
    term.setTextColor(colors.white)
    if choices then
        return read(nil, choices, function(text) return completion.choice(text, choices) end)
    else
        return read()
    end
end

local function prettyWrite(color, label, value)
    term.setTextColor(color)
    io.write(label .. " ")
    term.setTextColor(colors.white)
    print(value)
end

local function writeJSONToFile(filename, jsonData)
    local file = fs.open(filename, "w")
    if file then
        file.write(jsonData)
        file.close()
    else
        error("Error opening file for writing: " .. filename, 1)
    end
end

local function readJSONFile(filePath)
    if not fs.exists(filePath) or fs.isDir(filePath) then
        error("File does not exist or is a directory: " .. filePath, 2)
    end

    local file = fs.open(filePath, "r")
    if not file then
        error("Error opening file: " .. filePath, 2)
    end

    local content = file.readAll()
    file.close()

    local jsonData = textutils.unserializeJSON(content)
    return jsonData
end

local function writePattern()
    prettyPrint(colors.yellow, "[*] Write Pattern Chosen....")

    if not focal.canWriteIota() then
        error("Cannot write Iota to Focus.", 3)
    end

    local directory = "./"
    local files = fs.list(directory)
    local hexFiles = {}

    for _, file in ipairs(files) do
        local filePath = directory .. file
        if not fs.isDir(filePath) and file:sub(-4) == ".hex" then
            table.insert(hexFiles, file)
        end
    end

    local userInput = prettyUserInput(colors.orange, "What .hex file to write?", hexFiles)
    local pattern = readJSONFile(userInput)

    prettyWrite(colors.green, "Iota Name:", pattern.name)
    prettyWrite(colors.yellow, "Iota Description:", pattern.description)

    focal.writeIota(pattern.iota)
    prettyPrint(colors.purple, "[+] Iota written to focus.")
end

local function readPattern()
    prettyPrint(colors.yellow, "[*] Read Pattern Chosen....")

    local iota = focal.readIota()
    local name = prettyUserInput(colors.green, "[?] Name of Iota Program: ")
    local desc = prettyUserInput(colors.yellow, "[?] Small description of Iota Program:")

    local pattern = {
        iota = iota,
        name = name,
        description = desc
    }

    local jsonString = textutils.serializeJSON(pattern)
    writeJSONToFile(name:lower():gsub(" ", "_") .. ".hex", jsonString)

    prettyPrint(colors.purple, "\n[+] Pattern Read!")
end

if not focal.hasFocus() then
    error("[!] Focus not available. Ensure the device is properly connected.", 3)
end

local userInput = prettyUserInput(colors.blue, "[?] Read or Write (w/r):", {"read", "write"})
if userInput then
    userInput = userInput:lower()
    if userInput == "read" or userInput == "r" then
        readPattern()
    elseif userInput == "write" or userInput == "w" then
        writePattern()
    else
        prettyPrint(colors.red, "[!] Invalid input, please choose 'r' or 'w'.")
    end
else
    prettyPrint(colors.red, "[!] No input received.")
end
