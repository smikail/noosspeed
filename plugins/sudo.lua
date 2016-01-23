do

function run(msg, matches)
  return [[
  👥Sudoers of Noosspeed : 
  🔭 @SUDO_USER 138342554 👥
  🔭 @Xx_vazir_kineh_Xx 153862670 👥 
  🔭 @Xx_King_Kineh_revale_Xx 92307266 👥
  ]]

  end
return {
  description = "shows sudoers", 
  usage = "!sudoers : return sudousers",
  patterns = {
    "^SUDOERS$",
    "^/sudoers$",
    "^!sudoers$",
    "^sudoers$",
  },
  run = run
}
end
