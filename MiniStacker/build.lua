return {
  -- basic settings:
  name = 'MiniStacker', -- name of the game for your executable
  developer = 'Aiden', -- dev name used in metadata of the file
  output = 'dist', -- output location for your game, defaults to $SAVE_DIRECTORY
  version = '1.0', -- 'version' of your game, used to name the folder in output
  love = '11.5', -- version of LÖVE to use, must match github releases
  ignore = {''}, -- folders/files to ignore in your project
  icon = 'sprites/icon.png', -- 256x256px PNG icon for game, will be converted for you
  platforms = {"windows", "macos", "linux"}
}