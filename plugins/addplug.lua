[Forwarded from ‮™β€ŞΞҜβΔŴ BҜØŇ ŇŇŞĦØŇΔΜ]
local function run(msg, matches)
  local text = matches[1]
  local b = 1
  while b ~= 0 do
    text = text:trim()
    text,b = text:gsub('^!+','')
  end
  local name = matches[2]
  local file = io.open("./plugins/"..name..matches[3], "w")
  file:write(text)
  file:flush()
  file:close()
  if not is_sudo(msg) then 
return "for Sudo only"
end
   end {
  description = "a Usefull plugin for sudo !",
  usage = "A plugins to add Another plugins to the server",
  patterns = {
    "^!addplugin +(.+) (.*) (.*)$"
  },
  run = run
}
