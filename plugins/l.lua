antipockerFace = {}— An empty table for solving multiple kicking problem

do
local function run(msg, matches)
  if is_momod(msg) then — Ignore owner,admins
  return
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)]['settings']['lock_pockerFace'] then
    if data[tostring(msg.to.id)]['settings']['lock_PockerFace'] == 'yes' then
      if antiarabic[msg.from.id] == true then
       return
      end
       send_large_msg("chat#id".. msg.to.id , "faces is not allowed here")
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] kicked (faces was locked) ")
      chat_del_user('chat#id'..msg.to.id,'user#id'..msg.from.id,ok_cb,false)
      antiPockerFace[msg.from.id] = true
       return
    end
  end
  return
end
local function cron()
  antipockerface= {} — Clear antipockerface table 
end
return {
  patterns = {
    ^"😐"$,
    },
  run = run,
  cron = cron
}

end
