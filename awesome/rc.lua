-- {{{ Lua lib import
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

require("widgets/battery")
require("awful.autofocus")
require("widgets/volume")
require("widgets/yaourt")
require("awful.remote")
require("furious")

-- {{{ Startup Error handling
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
		    title = "Oops, there were errors during startup!",
		    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
					     -- Make sure we don't go into an endless error loop
					     if in_error then return end
					     in_error = true

					     naughty.notify({ preset = naughty.config.presets.critical,
							      title = "Oops, an error happened!",
							      text = err })
					     in_error = false
				       end)
end
-- }}}

-- {{{ AUTOSTART
awful.util.spawn_with_shell("xscreensaver -nosplash")
--awful.util.spawn_with_shell("xcompmgr -cF &")
awful.util.spawn("Thunar --daemon")
awful.util.spawn_with_shell("wmname LG3D")
awful.util.spawn_with_shell("feh --bg-center /vlam/Images/wallpaper/wall.jpg &")
awful.util.spawn_with_shell("sudo /usr/sbin/alsactl restore")

-- {{{ Variable definitions
beautiful.init("/home/malvault/.config/awesome/theme.lua")
terminal = "xterm"
editor = os.getenv("EDITOR") or "gvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.fair,
   awful.layout.suit.spiral,
   awful.layout.suit.magnifier,
   awful.layout.suit.tile.bottom
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
   for s = 1, screen.count() do
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
   end
end
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   --tags[s] = awful.tag({ "☐", "❷", "α", "✉", "V", "⚐" }, s, {layouts[1] , layouts[2] , layouts[3] , layouts[5] , layouts[2] , layouts[4] })
   tags[s] = awful.tag({ "1", "2", "3", "4", "5", "6" }, s, {layouts[1] , layouts[2] , layouts[3] , layouts[5] , layouts[2] , layouts[4] })
end

-- {{{ Menu
myacpimenu = {
   { "suspend", "dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Suspend" },
   { "hibernate","dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate" },
   { "reboot", "sudo /sbin/reboot" },
   { "halt", "sudo systemctl poweroff"},
}

myawesomemenu = {
   { "restart-wm", awesome.restart },
   { "disconnect", awesome.quit }
}

--Keys are: up, down, exec, enter, back, close
awful.menu.menu_keys.down = { "Down", "t" }
awful.menu.menu_keys.up = { "Up", "s" }
awful.menu.menu_keys.enter = { "Rigth", "r" }
awful.menu.menu_keys.back = { "Left", "c" }
awful.menu.menu_keys.exec = { "Space", "e" }
awful.menu.menu_keys.close = { "Escape", "q" }
mymainmenu = awful.menu({ items = {{ "awesome", myawesomemenu }, 
				   { "acpi", myacpimenu },
				   --{ "appz", appz_menu},
                                   { "open terminal", terminal }
				}
		    })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Custom widgets
separator = wibox.widget.textbox()
separator:set_text("  ")

pacman_icon = wibox.widget.imagebox()
pacman_icon:set_image(beautiful.apticon)

baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.baticon)

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.volicon)
-- }}}


-- {{{ Wibox
mytextclock = awful.widget.textclock()
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
			   if c == client.focus then
			      c.minimized = true
			   else
			      -- Without this, the following
			      -- :isvisible() makes no sense
			      c.minimized = false
			      if not c:isvisible() then
				 awful.tag.viewonly(c:tags()[1])
			      end
			      -- This will also un-minimize
			      -- the client, if needed
			      client.focus = c
			      c:raise()
			   end
		     end),
   awful.button({ }, 3, function ()
			   if instance then
			      instance:hide()
			      instance = nil
			   else
			      instance = awful.menu.clients({ width=250 })
			   end
		     end),
   awful.button({ }, 
4, function ()
			   awful.client.focus.byidx(1)
			   if client.focus then client.focus:raise() end
		     end),
   awful.button({ }, 5, function ()
			   awful.client.focus.byidx(-1)
			   if client.focus then client.focus:raise() end
		  end))

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt()
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
			     awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			     awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s })

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   --    left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   left_layout:add(mypromptbox[s])

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   --add widgets here
   
   right_layout:add(mytextclock)
   right_layout:add(separator)
   right_layout:add(pacman_icon) 
   right_layout:add(yaourt_info)
   right_layout:add(separator)
   right_layout:add(volicon)
   right_layout:add(tb_volume)
   right_layout:add(separator)
   right_layout:add(baticon)
   right_layout:add(batinfo)
   right_layout:add(separator)
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together (with the tasklist in the middle)
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(mytasklist[s])
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
		awful.button({ }, 3, function () mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	  ))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ modkey,           }, "c",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "r",  awful.tag.viewnext       ),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

   awful.key({ modkey,           }, "Tab",
	     function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	  end),
   awful.key({ "Mod1",           }, "d", function () mymainmenu:show() end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "Tab", function () awful.client.swap.byidx(  1)    end),
   --awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

   --Vlamy's
   awful.key({ "Mod1",          }, "Tab", function () alttab() end),
   awful.key({ "Mod1", "Control" }, "w", function () print_clients_info() end),
   awful.key({ modkey,           }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),

   awful.key({ modkey,           }, "Up",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "Down",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey,           }, "s",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "t",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
   awful.key({ modkey, "Control" }, "n", awful.client.restore),

   -- Prompt
   awful.key({ modkey },            "x",     function () mypromptbox[mouse.screen]:run() end),

   awful.key({ modkey }, "k",
	     function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
				 mypromptbox[mouse.screen].widget,
				 awful.util.eval, nil,
				 awful.util.getdir("cache") .. "/history_eval")
	  end)
   -- Menubar
     --awful.key({ modkey }, "p", function() menubar.show() end)
)

-- CLIENT KEY BINDING
--clientkeys = get_clients() 
clientkeys = awful.util.table.join(
   get_clients(),
   awful.key({ "Mod1",           }, "q",      function (c) c:kill()                         end),
   awful.key({ modkey,           }, "d",      awful.client.movetoscreen                        ),
   awful.key({ "Mod1",           }, "space", function (c) 
						keygrabber.run(function(mod, key, event) 
								  if event == "release" then return end 
								  if     key == 'Up'   then awful.client.moveresize(0, 0, 0, 5, c) 
								  elseif key == 'Down' then awful.client.moveresize(0, 0, 0, -5, c) 
								  elseif key == 'Right' then awful.client.moveresize(0, 0, 5, 0, c) 
								  elseif key == 'Left'  then awful.client.moveresize(0, 0, -5, 0, c) 
								  else   keygrabber.stop() 
								  end 
							    end) 
					  end),
   awful.key({ modkey,           }, "m",
 	     function (c)
 		c.maximized_horizontal = not c.maximized_horizontal
 		c.maximized_vertical   = not c.maximized_vertical
 	  end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
   globalkeys = awful.util.table.join(globalkeys,
				      awful.key({ modkey }, "#" .. i + 9,
						function ()
						   local screen = mouse.screen
						   if tags[screen][i] then
						      awful.tag.viewonly(tags[screen][i])
						   end
					     end),
				      awful.key({ modkey, "Control" }, "#" .. i + 9,
						function ()
						   local screen = mouse.screen
						   if tags[screen][i] then
						      awful.tag.viewtoggle(tags[screen][i])
						   end
					     end),
				      awful.key({ modkey, "Shift" }, "#" .. i + 9,
						function ()
						   if client.focus and tags[client.focus.screen][i] then
						      awful.client.movetotag(tags[client.focus.screen][i])
						   end
					     end),
				      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
						function ()
						   if client.focus and tags[client.focus.screen][i] then
						      awful.client.toggletag(tags[client.focus.screen][i])
						   end
					  end))
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
--init furious
init_global(globalkeys)
-- }}}

--- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
		    border_color = beautiful.border_normal,
		    focus = awful.client.focus.filter,
		    keys = clientkeys,
		    size_hints_honor = false,
		    buttons = clientbuttons },
     callback = function (c)
		   local clients = client.get()
		   for i, c2 in pairs(clients) do
		      if c.class == c2.class then
			 c.screen = c2.screen
			 awful.client.movetotag(awful.tag.selected(), c )
		      end
		   end
	     end},
   { rule = { class = "Firefox" },
     properties = { tag = tags[1][1] }},
   { rule = {class = "Emacs"}, 
     properties = {opacity = 0.75} },
   { rule = { class = "Eclipse" },
     properties = { tag = tags[1][1] } },
   { rule = { class = "Virt-manager" },
     properties = { tag = tags[1][5] } },
   { rule = { class = "Thunderbird" },
     properties = { tag = tags[1][4] } },

   -- Set Firefox to always map on tags number 2 of screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
				   -- Enable sloppy focus
				   --c:connect_signal("mouse::enter", function(c)
				--				       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
				--				       and awful.client.focus.filter(c) then
				--					  client.focus = c
				--				       end
				--				 end)

				   if not startup then
				      -- Set the windows at the slave,
				      -- i.e. put it at the end of others instead of setting it master.
				      awful.client.setslave(c)

				      -- Put windows in a smart way, only if they does not set an initial position.
				      if not c.size_hints.user_position and not c.size_hints.program_position then
					 awful.placement.no_overlap(c)
					 awful.placement.no_offscreen(c)
				      end
				   end

				   local titlebars_enabled = false
				   if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
				      -- Widgets that are aligned to the left
				      local left_layout = wibox.layout.fixed.horizontal()
				      left_layout:add(awful.titlebar.widget.iconwidget(c))

				      -- Widgets that are aligned to the right
				      local right_layout = wibox.layout.fixed.horizontal()
				      right_layout:add(awful.titlebar.widget.floatingbutton(c))
				      right_layout:add(awful.titlebar.widget.maximizedbutton(c))
				      right_layout:add(awful.titlebar.widget.stickybutton(c))
				      right_layout:add(awful.titlebar.widget.ontopbutton(c))
				      right_layout:add(awful.titlebar.widget.closebutton(c))

				      -- The title goes in the middle
				      local title = awful.titlebar.widget.titlewidget(c)
				      title:buttons(awful.util.table.join(
						       awful.button({ }, 1, function()
									       client.focus = c
									       c:raise()
									       awful.mouse.client.move(c)
									 end),
						       awful.button({ }, 3, function()
									       client.focus = c
									       c:raise()
									       awful.mouse.client.resize(c)
									 end)
						 ))

				      -- Now bring it all together
				      local layout = wibox.layout.align.horizontal()
				      layout:set_left(left_layout)
				      layout:set_right(right_layout)
				      layout:set_middle(title)

				      awful.titlebar(c):set_widget(layout)
				   end
			     end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
