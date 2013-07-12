-- Yaourt infos
require("awful.remote")
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

yinfos = nil
updates = "init"

-- Yaourt updates notifier
yaourt_info = wibox.widget.textbox()
yaourt_info:set_markup("<span color=\"red\">-2</span>")
yaourt_info:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn_with_shell("/vlam/sbin/yaourt_count") end)	
 ))

-- function called from outside via dbus to update the widget

function yaourt_update(text, up_infos)
   yaourt_info:set_markup(text)
   updates = up_infos
end

function clearinfo_y()
   if yinfos ~= nil then
      naughty.destroy(yinfos)
      yinfos = nil
   end
end

function dispinfo_y()
   local capi = {
      mouse = mouse,
      screen = screen
   }
   yinfos = naughty.notify({
			      title        = "Packages Updates :",
			      text        = updates,
			      timeout        = 0,
			      screen        = capi.mouse.screen })
end

yaourt_info:connect_signal('mouse::enter', function () dispinfo_y() end)
yaourt_info:connect_signal('mouse::leave', function () clearinfo_y() end)