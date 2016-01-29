l         local function user_print_name(user)
2	  if user.print_name then
3	    return user.print_name
4	  end
5	  local text = ''
6	  if user.first_name then
7	    text = user.last_name..' '
8	  end
9	  if user.lastname then
10	    text = text..user.last_name
11	  end
12	  return text
13	end
14	
15	local function returnids(cb_extra, success, result)
16	  local receiver = cb_extra.receiver
17	  local chat_id = "chat#id"..result.id
18	  local chatname = result.print_name
19	
20	  local text = 'IDs for chat '..chatname
21	  ..' ('..chat_id..')\n'
22	  ..'There are '..result.members_num..' members'
23	  ..'\n---------\n'
24	  for k,v in pairs(result.members) do
25	    text = text .. v.print_name .. " (user#id" .. v.id .. ")\n"
26	  end
27	  send_large_msg(receiver, text)
28	end
29	
30	local function run(msg, matches)
31	  local receiver = get_receiver(msg)
32	  if matches[1] == "!id" then
33	    local text = user_print_name(msg.from) .. ' (user#id' .. msg.from.id .. ')'
34	    if is_chat_msg(msg) then
35	      text = text .. "\nYou are in group " .. user_print_name(msg.to) .. " (chat#id" .. msg.to.id  .. ")"
36	    end
37	    return text
38	  elseif matches[1] == "chat" then
39	    -- !ids? (chat) (%d+)
40	    if matches[2] and is_sudo(msg) then
41	      local chat = 'chat#id'..matches[2]
42	      chat_info(chat, returnids, {receiver=receiver})
43	    else
44	      if not is_chat_msg(msg) then
45	        return "You are not in a group."
46	      end
47	      local chat = get_receiver(msg)
48	      chat_info(chat, returnids, {receiver=receiver})
49	    end
50	  elseif matches[1] == "member" and matches[2] == "@" then
51	    local nick = matches[3]
52	    local chat = get_receiver(msg)
53	    if not is_chat_msg(msg) then
54	      return "You are not in a group."
55	    end
56	    chat_info(chat, function (extra, success, result)
57	      local receiver = extra.receiver
58	      local nick = extra.nick
59	      local found
60	      for k,user in pairs(result.members) do
61	        if user.username == nick then
62	          found = user
63	        end
64	      end
65	      if not found then
66	        send_msg(receiver, "User not found on this chat.", ok_cb, false)
67	      else
68	        local text = "ID: "..found.id
69	        send_msg(receiver, text, ok_cb, false)
70	      end
71	    end, {receiver=chat, nick=nick})
72	  elseif matches[1] == "members" and matches[2] == "name" then
73	    local text = matches[3]
74	    local chat = get_receiver(msg)
75	    if not is_chat_msg(msg) then
76	      return "You are not in a group."
77	    end
78	    chat_info(chat, function (extra, success, result)
79	      local members = result.members
80	      local receiver = extra.receiver
81	      local text = extra.text
82	
83	      local founds = {}
84	      for k,member in pairs(members) do
85	        local fields = {'first_name', 'print_name', 'username'}
86	        for k,field in pairs(fields) do
87	          if member[field] and type(member[field]) == "string" then
88	            if member[field]:match(text) then
89	              local id = tostring(member.id)
90	              founds[id] = member
91	            end
92	          end
93	        end
94	      end
95	      if next(founds) == nil then -- Empty table
96	        send_msg(receiver, "User not found on this chat.", ok_cb, false)
97	      else
98	        local text = ""
99	        for k,user in pairs(founds) do
100	          local first_name = user.first_name or ""
101	          local print_name = user.print_name or ""
102	          local user_name = user.user_name or ""
103	          local id = user.id  or "" -- This would be funny
104	          text = text.."First name: "..first_name.."\n"
105	            .."Print name: "..print_name.."\n"
106	            .."User name: "..user_name.."\n"
107	            .."ID: "..id
108	        end
109	        send_msg(receiver, text, ok_cb, false)
110	      end
111	    end, {receiver=chat, text=text})
112	  end
113	end
114	
115	return {
116	  description = "Know your id or the id of a chat members.",
117	  usage = {
118	    "!id: Return your ID and the chat id if you are in one.",
119	    "!ids chat: Return the IDs of the current chat members.",
120	    "!ids chat <chat_id>: Return the IDs of the <chat_id> members.",
121	    "!id member @<user_name>: Return the member @<user_name> ID from the current chat",
122	    "!id members name <text>: Search for users with <text> on first_name, print_name or username on current chat"
123	  },
124	  patterns = {
125	    "^!id$",
126	    "^!ids? (chat) (%d+)$",
127	    "^!ids? (chat)$",
128	    "^!id (member) (@)(.+)",
129	    "^!id (members) (name) (.+)"
130	  },
131	  run = run
132	}
