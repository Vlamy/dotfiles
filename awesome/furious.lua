---------------------------------------------------------
-- This library is released under the GNU licence GPL v3 
-- @author Willy Malvault, alias Vlamy (vlamy@vlamy.fr) 
-- @release 1.0
-- (tested with awesome 3.5)
---------------------------------------------------------
--constants
ROR = 0
CATCH = 1
DROP = 2
PLACE = 3

-- Grab environment
local pairs     =   pairs
local type      =   type
--local awful     =   awful
local awful = require("awful")
local root      =   root
local naughty   =   require("naughty")
local tostring = tostring

--
-- client = client object
-- tag = tag to place object on
-- screen = screen  to place object on
local teardrop = nil 

-- {{{ Appz
--- key = hotkey
--- cmd = application launch command
--- tag = default tag
--- screen = default screen
--- match = string to match
--- type = ror match type
myappz = {}
myappz["f"] = { info="firefox", cmd="firefox", tag="1", screen=1, match="Firefox", type="instance" }
myappz["g"] = { info="chrome", cmd="chromium", tag="1", screen=2, hotkey="g", match="Chrome", type="instance" }
myappz["d"] = { info="eclipse", cmd="/vlam/bin/eclipse/eclipse", tag="1", screen=2, match="Eclipse", type="instance" }
myappz["c"] = { info="mailer", cmd="thunderbird", tag="4", screen=2, match="Thunderbird", type="instance" }
myappz["i"] = { info="im", cmd="pidgin", tag="4", screen=2, match="Pidgin", type="instance" }
myappz["s"] = { info="devterm", cmd="/vlam/sbin/devterm", tag="2", screen=2, match="devterm", type="name" }
myappz["a"] = { info="adminterm", cmd="/vlam/sbin/adminterm", tag="3", screen=2, match="adminterm", type="name" }
myappz["e"] = { info="editor", cmd="gvim", tag="2", screen=2, match="Gvim", type="instance" }
myappz["n"] = { info="file manager", cmd="Thunar", tag="4", screen=2, match="Thunar", type="instance" }
myappz["v"] = { info="virt-manager", cmd="virt-manager", tag="5", screen=2, match="Virt-manager", type="instance" }

--{{{modal menu for clients
myclients = {}
myclients["r"] = { info = "redraw" , func = function(c) c:redraw() end }
myclients["n"] = { info = "minimize" , func = function(c) c.minimized = true end }
myclients["q"] = { info = "kill" , func = function(c) c:kill() end }
myclients["m"] = { info = "maximize" , func = function (c)
						   c.maximized_horizontal = not c.maximized_horizontal
						   c.maximized_vertical   = not c.maximized_vertical
					     end}
myclients["o"] = { info = "move to screen" , func = awful.client.movetoscreen }
myclients["f"] = { info = "toggle floating" , func = awful.client.floating.toggle }
myclients["c"] = { info = "resize" , func =  function () resize() end }

--global awesome keybindings
myglobals = {}
myglobals["r"] = { info="restart", func = awesome.restart }
myglobals["s"] = { info="shuffle", func = function() shuffle() end }
--myglobals["x"] = { info="run", func = awesome.restart }

--myacpimenu = {
--  { "suspend", "dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Suspend" },
--  { "hibernate","dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate" },
--  { "reboot", "sudo /sbin/reboot" },
--  { "halt", "sudo systemctl poweroff"},
--}
--
--myawesomemenu = {
--  { "restart-wm", awesome.restart },
--  { "disconnect", awesome.quit }
--}
--
--mymainmenu = awful.menu({ items = {{ "awesome", myawesomemenu }, 
--    { "acpi", myacpimenu },
--    --{ "appz", appz_menu},
--    { "open terminal", terminal }
--    }
--    })

-- pops up informations on running clients
function print_clients_info()
   local clients = client.get(0)
   
   -- print("run_or_raise_by_name")

   for i, c in pairs(clients) do
      --make an array of matched clients
      string = "\"client "..tostring(i).."\n class = "..tostring(c.class).."\n title = "..tostring(c.name).."\n instance ="..tostring(c.instance).."\n geometry = "
      for j,v in pairs(c.geometry(c)) do
	 string = string.." "..v
      end
      naughty.notify { text = string, timeout = 6, hover_timeout = 1 }
      -- thin(c)
   end
end

function print_strings(param)
   local to_print = "printing : "..param
   naughty.notify { text = to_print, timeout = 6, hover_timeout = 1 }
end

function alttab()
   awful.menu.menu_keys.down = { "Down", "Tab" }
   local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
end

function get_clients()
   local clients = {}
   clients = awful.util.table.join(clients, awful.key({"Mod1"},"c", function(c) clients_graber(c) end))
   return clients
end

function clients_graber(c)
local menu = ""   
   for k, ta in pairs(myclients) do
      menu = menu..'\n['..k..'] --> '..ta.info
   end
   infos = naughty.notify({title = "clients", text= menu})

   --run keygrabber
   keygrabber.run(function(mod, key, event)
		     if event == "release" then return end 
		     if key == "Escape" then
			keygrabber.stop()
			naughty.destroy(infos)
		     end
		     for k, ta in pairs(myclients) do
			if key == k then
			   keygrabber.stop()
			   naughty.destroy(infos)
			   ta.func(c)
			end 
		     end
		     keygrabber.stop()
	       end)
end

function shuffle()
   for k, table in pairs(myappz) do
      grab(myappz[k], PLACE, true)
   end
end

function init_global(globalkeys)
   local ror_table = {}
   local catch_table = {}
   local drop_table = {}
   local glob = {}

   for k, table in pairs(myappz) do
      ror_table[k] = {info = myappz[k].info, func = function() grab(myappz[k], ROR, false) end}
      catch_table[k] = {info = myappz[k].info, func = function() grab(myappz[k], CATCH, false) end}
      drop_table[k] = {info = myappz[k].info, func = function() grab(myappz[k], DROP, false) end}
      drop_table[","] = {info = "release teardrop", func = function() release_teardrop() end}
   end

    glob = awful.util.table.join(glob, awful.key({"Mod1"},"t", function() global_keygraber("ROR", ror_table) end),
    awful.key({"Mod1",},"s", function() global_keygraber("Catch", catch_table) end),
    awful.key({"Mod1",},"'", function() global_keygraber("Genaral", myglobals) end),
    awful.key({"Mod1"},"r", function() global_keygraber("drop", drop_table) end))

    root.keys(awful.util.table.join(globalkeys,glob))
end

-- Prints menu and runs keygrabber
-- run_table.key (key is table key)
-- run_table.menu
-- run_table.info
-- run_table.func
function global_keygraber(title, run_table)
   --print menu
   local menu = ''   
   for k, ta in pairs(run_table) do
      menu = menu..'\n['..k..'] --> '..ta.info
   end
   infos = naughty.notify({title = title, text= menu})

   --run keygrabber
   keygrabber.run(function(mod, key, event)
		     if event == "release" then return end 
		     if key == "Escape" then
			keygrabber.stop()
			naughty.destroy(infos)
		     end
		     for k, ta in pairs(run_table) do
			if key == k then
			   naughty.destroy(infos)
			   ta.func()
			end 
		     end
		     keygrabber.stop()
	       end)
end

-- Returns true if all pairs in table1 are present in table2
function match (table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end

--------------------------------
-- Releases the teardrop client.
--------------------------------
function release_teardrop()
   if teardrop ~= nil then
      local c = teardrop.client
      naughty.notify({title = "info", text= "release teardrop"})
      c:geometry({ x = x, y = y, width = width, height = height })
      c.ontop = false 
      c.above = false 
      c.skip_taskbar = false
      c.sticky = false
      awful.client.movetotag(teardrop.screen, c)
      for k,tag in pairs(awful.tag.gettags(teardrop.screen)) do
	 if tag.name == teardrop.tag then
	    awful.client.movetotag(tag, c)
	 end
      end
      awful.client.floating.set(c, false)
      teardrop = nil
   end
end

------------------------------------------------------------------------------------
-- Grab function allows to grab any application following
-- three different modes : classic run_or_raise, catch or teardrop.
-- The application is spawned if no matching client exists.
-- Parameters :
--     -app : table that contains at least the three following entries :
--          -match : the string to use, so as to match the requested application
--          -type : the WM field to match again (class or name)
--          -cmd : the command to run to spawm the application
--          -tag : the default tag for the given application
--          -screen : the default screen for the given application
--     -mode : the grab mode
--          -ROR : classic run or raise will focus the requested
--          application if some matching exists. Else it will spawn
--          that application on its default tag and screen.
--          -CATCH : this mode will move the requested application
--          , if some matching client exists, to the current tag and screen.
--          Else it will spawm the application to the current tag and screen.
--          -DROP : is a teardrop like mode that spawn or move application,
--          if matching client exists, makes the client sticky (vible on all tags),
--          floating, at a given geometry (static for now).
--      -rec : indicates if the call is recursive
--           (used to ease the prevention of infinite recursion)
------------------------------------------------------------------------------------
function grab(app, mode, rec)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0

   local properties = {}
   if app.type == "instance" then
      properties = {class = app.match}
   else
      properties = {name = app.match}
   end
   
   --look for existing match
   for i, c in pairs(clients) do
      --make an array of matched clients
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end

   -- if match exist, treat the first matching clients
   if n > 0 then
      local c = matched_clients[1]
      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      
      if mode == ROR then
	 local ctags = c:tags()
	 if #ctags == 0 then
	    -- ctags is empty, show client on current tag
	    local curtag = awful.tag.selected()
	    awful.client.movetotag(curtag, c)
	 else
	    -- Otherwise, pop to first tag client is visible on
	    awful.tag.viewonly(ctags[1])
	 end

      elseif mode == CATCH then
	 --move client to current tag
	 local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)

      elseif mode == DROP then
	 release_teardrop()
	 teardrop = {client = c, tag = app.tag, screen = app.screen }
	 awful.client.floating.set(c, true)
	 c:geometry({ x = 300, y = 200, width = 1200, height = 600})
	 c.ontop = true 
	 c.above = true 
	 c.skip_taskbar = true
	 c.sticky = true
	 awful.client.movetotag(awful.tag.selected(), c)
      elseif mode == PLACE then
	 awful.client.movetoscreen(c, app.screen)
	 for k,tag in pairs(awful.tag.gettags(app.screen)) do
	    if tag.name == app.tag then
	       awful.client.movetotag(tag, c)
	    end
	 end
      else
	 naughty.notify({ preset = naughty.config.presets.critical,
			  title = "Error in Furious lib :",
			  text = "unknown grab mode :"..tostring(mode) })
      end
      -- And then focus the client
      client.focus = c
      c:raise()
   else
      --spawn and grab again
      if not rec then
	 naughty.notify({title = "info", text= "spawning :"..app.info})
	 awful.util.spawn(app.cmd)
	 grab(app, mode, true)
      end
   end
end
