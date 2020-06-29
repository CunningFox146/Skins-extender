name = "Skins extender"
author = "Cunning fox, Myxal"
version = "1.3"
description = "Automatically opens your skis without science machine and creates a statistic for every skin that you revive!\nVersion: "..version
forumthread = ""

client_only_mod = true
dst_compatible = true

icon_atlas = "preview.xml"
icon = "preview.tex"

api_version = 10

priority = -0.681239

-- local example_time = os.time()
local function BuildFormatOption(desc, data)
  return { description = desc, data = data, hover = data } -- os.date(data, example_time) }
end

local function BuildBoolOptions()
  return {
    { description = "Yes", data = true },
    { description = "No", data = false }
  }
end

configuration_options = {
  {
    label = "Date/Time Format",
    name = "skinext_date_format",
    options = {
      BuildFormatOption("System default", "%c"),
      BuildFormatOption("Classic", "%x %X"),
      BuildFormatOption("Short 24H", "%a %H:%M"),
      BuildFormatOption("Short 12H", "%a %I:%M%p")
    },
    default = "%c"
    -- hover =
  },
  {
    label = "Log menu screen gifts",
    name = "skinext_log_menugift",
    options = BuildBoolOptions(""),
    default = true
  }
}
