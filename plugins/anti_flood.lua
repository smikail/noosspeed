1	local NUM_MSG_MAX = 5 -- Max number of messages per TIME_CHECK seconds
2	local TIME_CHECK = 5
3	
4	local function kick_user(user_id, chat_id)
5	  local chat = 'chat#id'..chat_id
6	  local user = 'user#id'..user_id
7	  chat_del_user(chat, user, function (data, success, result)
8	    if success ~= 1 then
9	      local text = 'I can\'t kick '..data.user..' but should be kicked'
10	      send_msg(data.chat, '', ok_cb, nil)
11	    end
12	  end, {chat=chat, user=user})
13	end
14	
15	local function run (msg, matches)
16	  if msg.to.type ~= 'chat' then
17	    return 'Anti-flood works only on channels'
18	  else
19	    local chat = msg.to.id
20	    local hash = 'anti-flood:enabled:'..chat
21	    if matches[1] == 'enable' then
22	      redis:set(hash, true)
23	      return 'Anti-flood enabled on chat'
24	    end
25	    if matches[1] == 'disable' then
26	      redis:del(hash)
27	      return 'Anti-flood disabled on chat'
28	    end
29	  end
30	end
31	
32	local function pre_process (msg)
33	  -- Ignore service msg
34	  if msg.service then
35	    print('Service message')
36	    return msg
37	  end
38	
39	  local hash_enable = 'anti-flood:enabled:'..msg.to.id
40	  local enabled = redis:get(hash_enable)
41	
42	  if enabled then
43	    print('anti-flood enabled')
44	    -- Check flood
45	    if msg.from.type == 'user' then
46	      -- Increase the number of messages from the user on the chat
47	      local hash = 'anti-flood:'..msg.from.id..':'..msg.to.id..':msg-num'
48	      local msgs = tonumber(redis:get(hash) or 0)
49	      if msgs > NUM_MSG_MAX then
50	        local receiver = get_receiver(msg)
51	        local user = msg.from.id
52	        local text = 'User '..user..' is flooding'
53	        local chat = msg.to.id
54	
55	        send_msg(receiver, text, ok_cb, nil)
56	        if msg.to.type ~= 'chat' then
57	          print("Flood in not a chat group!")
58	        elseif user == tostring(our_id) then
59	          print('I won\'t kick myself')
60	        elseif is_sudo(msg) then
61	          print('I won\'t kick an admin!')
62	        else
63	          kick_user(user, chat)
64	        end
65	        msg = nil
66	      end
67	      redis:setex(hash, TIME_CHECK, msgs+1)
68	    end
69	  end
70	  return msg
71	end
72	
73	return {
74	  description = 'Plugin to kick flooders from group.',
75	  usage = {},
76	  patterns = {
77	    '^!antiflood (enable)$',
78	    '^!antiflood (disable)$'
79	  },
80	  run = run,
81	  privileged = true,
82	  pre_process = pre_process
83	}
