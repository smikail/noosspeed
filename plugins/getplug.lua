do

local function run(msg, matches)

if matches[1] == "getplug" then

local file = matches[2]

if is_sudo(msg) then

local receiver = get_receiver(msg)

send_document(receiver, "./plugins/"..file..".lua", ok_cb, false)
if not is_sudo(msg) then 
return "Only sudoers can get plugins"
end

end

end

end

return {

patterns = {

"^[!/](getplug) (.*)$"

},

run = run

}

end

