local need_update = false

FILELINK = ''

FILENAME = ''


FILEPATH = shell.resolveProgram(FILENAME)

local request = http.get(FILELINK)
local updated_program = request.readAll()
request.close()


local file = fs.open(FILEPATH, "r")
local local_file = file.readAll()
file.close()



if local_file == updated_program then
    term.setTextColor(colors.lime)
    print("It appears ".. FILENAME .." the program is up to date")
    need_update = false
else
    term.setTextColor(colors.red)
    print("It appears ".. FILENAME .." is not up to date")
    need_update = true
end

term.setTextColor(colors.white)



function update(filepath, program)
    local file_to_update = fs.open(filepath, "w")
    file_to_update.write(program)
    file_to_update.close()
end


local update_successful

if need_update then
    print("Standby...")
    update_successful = pcall(update, FILEPATH, updated_program)


    if update_successful then
        term.setTextColor(colors.lime)
        print("Update successful!")
    else
        term.setTextColor(colors.red)
        print("Update failed")
    end
    term.setTextColor(colors.white)
end


