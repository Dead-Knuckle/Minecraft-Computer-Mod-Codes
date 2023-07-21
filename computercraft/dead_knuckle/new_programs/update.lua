local need_update = false

function update(filepath, program)
    local file_to_update = fs.open(filepath, "w")
    file_to_update.write(program)
    file_to_update.close()
end

function pretty_print(statement, color)
    term.setTextColor(color)
    print(statement)
    term.setTextColor(colors.white)
end


for i = 1, #arg, 1 do
    if arg[i] == "-l" or arg[i] == "--link" then
        FILELINK  = arg[i+1]

elseif arg[i] == "-n" or arg[i] == "--name"  then
        FILENAME= arg[i+1]
    end
end

if FILELINK == nil or FILENAME == nil then
    error("You need to fill in the args FILELINK and FILENAME", 2)
end

FILEPATH = shell.resolveProgram(FILENAME)

local request = http.get(FILELINK)
local updated_program = request.readAll()
request.close()


local file = fs.open(FILEPATH, "r")
local local_file = file.readAll()
file.close()


if local_file == updated_program then
    pretty_print("It appears ".. FILENAME .." the program is up to date", colors.lime)
    need_update = false
else
    pretty_print("It appears ".. FILENAME .." is not up to date", colors.red)
    need_update = true
end

local update_successful

if need_update then
    pretty_print("Standby...", colors.yellow)
    update_successful = pcall(update, FILEPATH, updated_program)

    if update_successful then
        pretty_print("Update successful!", colors.lime)
    else
        pretty_print("Update failed", colors.red)
    end
end