do

function run(msg, matches)

local fuse = ' #DearAdmin we have recived a new feedback just now : #newfeedback \n\n id  : ' .. msg.from.id .. '\n\nNAME : ' .. msg.from.print_name ..'\n\nusername : @ ' .. msg.from.username  ..'\pm :\n\n' .. matches[1] 
local fuses = '!printf user#id' .. msg.from.id


    local text = matches[1]
 bannedidone = string.find(msg.from.id, '123')
        bannedidtwo =string.find(msg.from.id, '465')       
   bannedidthree =string.find(msg.from.id, '678')  


        print(msg.to.id)

        if bannedidone or bannedidtwo or bannedidthree then                    --for banned people
                return 'You are banned to send a feedback'
 else


                 local sends0 = send_msg('chat#106931848', fuse, ok_cb, false)

 return 'Your request has been sended to suppurt noosspeed 😜!'

     

end

end
return {
  description = "Feedback to sudos",

  usage = "!feedback : send maseage to admins with bot",
  patterns = {
    "^[!/]([Ff]eedback) (.*)$"
    "^[Ff](eedback) (.*)$"

  },
  run = run
}

end
