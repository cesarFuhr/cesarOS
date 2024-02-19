-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local lain = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- styles
beautiful.useless_gap       = 3
beautiful.gap_single_client = false

-- This is used later as the default terminal and editor to run.
local terminal              = "alacritty"
local editor                = os.getenv("EDITOR") or "nvim"
local editor_cmd            = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey                = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts        = {
  awful.layout.suit.max,
  -- awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  lain.layout.centerwork,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu         = {
  { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
  { "quit",        function() awesome.quit() end },
}

local mymainmenu            = awful.menu({
  items = {
    { "awesome",       myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal },
  }
})

local markup                = lain.util.markup
local gray                  = "#dddddd"

local theme                 = {}
theme.fg_normal             = "#D7D7D7"
theme.bg_normal             = "#060606"

-- /home fs
local fs                    = lain.widget.fs({
  notification_preset = { fg = white, bg = theme.bg_normal, font = "Terminus 10.5" },
  settings            = function()
    local fs_header = " FS "
    local fs_p      = fs_now["/"].percentage
    widget:set_markup(markup.font(theme.font, markup(gray, fs_header) .. fs_p .. "% "))
  end
})

-- CPU
local cpu                   = lain.widget.cpu({
  settings = function()
    local cpu_header = " CPU "
    local cpu_p      = cpu_now.usage
    widget:set_markup(markup.font(theme.font, markup(gray, cpu_header) .. cpu_p .. "% "))
  end
})

-- MEM
local mem                   = lain.widget.mem({
  settings = function()
    local mem_header = " RAM "
    local mem_p      = mem_now.perc
    widget:set_markup(markup.font(theme.font, markup(gray, mem_header) .. mem_p .. "% "))
  end
})

-- Battery
local bat                   = lain.widget.bat({
  settings = function()
    local bat_header = " Bat "
    local bat_p      = bat_now.perc .. " "
    widget:set_markup(markup.font(theme.font, markup(gray, bat_header) .. bat_p))
  end
})

-- ALSA
local volume                = lain.widget.alsa({
  --togglechannel = "IEC958,3",
  settings = function()
    local header = " Vol "
    local vlevel = volume_now.level
    if volume_now.status == "off" then
      vlevel = "Muted"
    else
      vlevel = vlevel .. " "
    end
    widget:set_markup(markup.font(theme.font, markup(gray, header) .. vlevel))
  end
})

-- Menubar configuration
menubar.utils.terminal      = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local mykeyboardlayout      = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock           = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons       = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function()
  awful.spawn.with_shell("feh -z --bg-fill $HOME/Wallpapers")
end)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  awful.spawn.with_shell("feh -z --bg-fill $HOME/Wallpapers")

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.focused,
    --buttons = tasklist_buttons,
    style  = {
      bg_focus              = "#212121",
      tasklist_disable_icon = true,
      align                 = "center",
    },
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  local spr = wibox.widget.textbox(' | ')
  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    {
      -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mylayoutbox,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    {
      -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      cpu,
      spr,
      mem,
      spr,
      fs,
      spr,
      volume,
      spr,
      mykeyboardlayout,
      spr,
      wibox.widget.systray(),
      bat,
      mytextclock,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

local spawn = function(command)
  return function() awful.spawn.with_shell(command) end
end

-- {{{ Key bindings
local globalkeys = gears.table.join(
  awful.key({ modkey, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),

  awful.key({ modkey, }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),

  awful.key({ modkey, }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),

  awful.key({ modkey, }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }),

  awful.key({ modkey, }, "b", spawn("firefox"),
    { description = "open browser", group = "apps" }),
  awful.key({ modkey, "Shift" }, "Page_Up", spawn("setxkbmap -model pc104 -layout us"),
    { description = "us keyboard layout", group = "util" }),

  awful.key({ modkey, "Shift" }, "Page_Down",
    spawn("setxkbmap -model pc104 -layout us -variant intl -option 'compose:rctrl'"),
    { description = "us variant keyboard layout", group = "util" }),

  awful.key({ modkey, }, ";", spawn("dmenu_run"),
    { description = "dmenu command", group = "laucher" }),

  awful.key({ modkey, }, "p", spawn("rofi -show run"),
    { description = "rofi run command", group = "laucher" }),

  awful.key({ modkey, }, "space", spawn("rofi -show combi"),
    { description = "rofi run command", group = "laucher" }),

  awful.key({ modkey, }, "j",
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "focus next by index", group = "client" }
  ),
  awful.key({ modkey, }, "k",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "focus previous by index", group = "client" }
  ),
  awful.key({ modkey, "Shift" }, "w", function() mymainmenu:show() end,
    { description = "show main menu", group = "awesome" }),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, }, "w", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }),

  -- Standard program
  awful.key({ modkey, "Shift" }, "Return", function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.03) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.03) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "k", function() awful.layout.inc(1) end,
    { description = "select next", group = "layout" }),
  awful.key({ modkey, "Control" }, "j", function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),

  -- Audio control
  awful.key({}, "XF86AudioMute", function() awful.spawn.with_shell("pamixer -t") end,
    { description = "mute master", group = "audio" }),
  awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell("pamixer -d 5") end,
    { description = "lower master volume", group = "audio" }),
  awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell("pamixer -i 5") end,
    { description = "raise master volume", group = "audio" }),

  -- Player control
  awful.key({}, "XF86AudioPlay", function() awful.spawn.with_shell("playerctl play-pause") end,
    { description = "pay/pause player", group = "audio" }),
  awful.key({}, "XF86AudioPrev", function() awful.spawn.with_shell("playerctl previous") end,
    { description = "previous track", group = "audio" }),
  awful.key({}, "XF86AudioNext", function() awful.spawn.with_shell("playerctl next") end,
    { description = "next track", group = "audio" }),
  awful.key({}, "XF86AudioStop", function() awful.spawn.with_shell("playerctl stop") end,
    { description = "stop player", group = "audio" }),

  awful.key({ modkey, "Control" }, "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", { raise = true }
        )
      end
    end,
    { description = "restore minimized", group = "client" }),

  -- Prompt
  awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
    { description = "run prompt", group = "launcher" }),

  awful.key({ modkey }, "x",
    function()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    { description = "lua execute prompt", group = "awesome" })
-- Menubar
-- awful.key({ modkey }, "p", function() menubar.show() end,
--           {description = "show the menubar", group = "launcher"})
)

local clientkeys = gears.table.join(
  awful.key({ modkey, }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }),

  awful.key({ modkey, }, "q", function(c) c:kill() end,
    { description = "close", group = "client" }),

  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }),
  awful.key({ modkey, }, "Return", function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),
  awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
    { description = "move to screen", group = "client" }),
  awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }),

  awful.key({ modkey, }, "n",
    function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    { description = "minimize", group = "client" }),
  awful.key({ modkey, }, "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "(un)maximize", group = "client" }),
  awful.key({ modkey, "Control" }, "m",
    function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    { description = "(un)maximize vertically", group = "client" }),
  awful.key({ modkey, "Shift" }, "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      opacity = 1,
      titlebars_enabled = false,
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",   -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer" },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = { type = { "normal", "dialog" }
    },
    properties = { titlebars_enabled = false }
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("property::minimized", function(c)
  c.minimized = false
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- Switch with rofi.
-- Focus urgent tags automatically
tag.connect_signal("property::urgent", function(t)
  awful.screen.focus(t.screen)
  if not (t.selected) then
    t:view_only()
  end
end)

-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
  c.minimized = false
  c:jump_to()
end)
-- }}}

-- Hack so xdg portal loads applications from PATH.
awful.spawn.with_shell("systemctl --user import-environment PATH")
awful.spawn.with_shell("systemctl --user restart xdg-desktop-portal.service")
