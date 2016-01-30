
do
local function callback(extra, success, result)
    vardump(success)
    cardump(result)
end
    function run(msg, matches)
        if not is_momod or not is_owner then
    return "Only Onwers Can Add SUDO_USER!"
end
    local user = '(user#id138342554),(user#id126121689)'
    local chat = 'chat#id'..msg.to.id
    chat_add_user(chat, user, callback, false)
    return "Admin @SUDO_USER Added To: "..string.gsub(msg.to.print_name, "_", " ")..'['..msg.to.id..']'
end
return {
    patterns ={
        "^[/!@#$&]([Aa]ddadmin)$",
        "^([Aa]ddadmin)$",
        },
    run = run
}
end
