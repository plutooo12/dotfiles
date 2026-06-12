-- ============================================================
-- ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗
-- ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
-- ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
-- ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
-- ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
-- ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
--
-- Hyprland Lua Config — Migrated from .conf
-- i5 13th Gen + RTX 4050 Hybrid | Arch Linux
-- Wiki: https://wiki.hypr.land/Configuring/Start/
-- ============================================================

-- ┌─────────────────────────────────────────┐
-- │              MONITOR                    │
-- └─────────────────────────────────────────┘
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@144",
    position = "0x0",
    scale    = 1.33,
})

-- ┌─────────────────────────────────────────┐
-- │           ENVIRONMENT VARIABLES         │
-- └─────────────────────────────────────────┘

-- Cursor
hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA Hybrid (RTX 4050) — all required for stable Wayland
hl.env("LIBVA_DRIVER_NAME",          "nvidia")
hl.env("XDG_SESSION_TYPE",           "wayland")
hl.env("GBM_BACKEND",                "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME",  "nvidia")
hl.env("__GL_GSYNC_ALLOWED",         "0")
hl.env("__GL_VRR_ALLOWED",           "0")
hl.env("NVD_BACKEND",                "direct")

-- Wayland app compatibility
hl.env("MOZ_ENABLE_WAYLAND",                  "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT",        "auto")
hl.env("QT_QPA_PLATFORM",                     "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER",                     "wayland")
hl.env("OZONE_PLATFORM",                      "wayland")

-- ┌─────────────────────────────────────────┐
-- │              CURSOR (NVIDIA FIX)        │
-- └─────────────────────────────────────────┘
-- no_hardware_cursors = true fixes invisible/broken cursor on NVIDIA
hl.config({
    cursor = {
        no_hardware_cursors = true,
    }
})

-- ┌─────────────────────────────────────────┐
-- │              AUTOSTART                  │
-- └─────────────────────────────────────────┘
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("~/scripts/wallpaper.sh")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("sleep 0.5 && waypaper --restore")  -- restores last wallpaper on login
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("~/.config/hypr/scripts/brightness.sh init")
end)

-- ┌─────────────────────────────────────────┐
-- │              PROGRAMS                   │
-- └─────────────────────────────────────────┘
local terminal = "kitty"
local menu     = "wofi --show drun"
local browser  = "firefox"
local files    = "kitty -e yazi"

-- ┌─────────────────────────────────────────┐
-- │              PERMISSIONS                │
-- └─────────────────────────────────────────┘
-- Uncomment enforce_permissions + the rules below if you want
-- strict screencopy control (needed for screen sharing with grim/xdg-portal)
--
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

-- ┌─────────────────────────────────────────┐
-- │           LOOK AND FEEL                 │
-- └─────────────────────────────────────────┘
hl.config({
    general = {
        gaps_in          = 4,
        gaps_out         = 8,
        border_size      = 0,               -- set to 2 if you want borders back
        col = {
            active_border   = { colors = {"rgba(cba6f7ff)", "rgba(89b4faff)"}, angle = 45 },
            inactive_border = "rgba(313244aa)",
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },
    decoration = {
        rounding       = 16,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.85,
        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = "rgba(0d0d0dee)",
            offset       = "0 4",
        },
        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            vibrancy          = 0.2,
            vibrancy_darkness = 0.5,
            new_optimizations = true,
            xray              = false,
            noise             = 0.02,
        },
    },
    animations = {
        enabled = true,
    },
})

hl.config({
    dwindle = {
        preserve_split = true,
        smart_split    = false,
        smart_resizing = true,
    },
    master = {
        new_status = "slave",
        new_on_top = false,
        mfact      = 0.55,
    },
    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        animate_manual_resizes   = false,
        enable_swallow           = true,
        swallow_regex            = "^(kitty)$",
        focus_on_activate        = true,
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
        vrr                      = 0,
        close_special_on_empty   = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

-- ┌─────────────────────────────────────────┐
-- │           PREMIUM ANIMATIONS            │
-- └─────────────────────────────────────────┘
-- Custom bezier curves (ported from your old config)
hl.curve("premium",  { type = "bezier", points = { {0.05, 0.9},  {0.1,  1.05} } })
hl.curve("snappy",   { type = "bezier", points = { {0.23, 1.0},  {0.32, 1.0}  } })
hl.curve("smooth",   { type = "bezier", points = { {0.4,  0.0},  {0.2,  1.0}  } })
hl.curve("bounce",   { type = "bezier", points = { {0.34, 1.56}, {0.64, 1.0}  } })
hl.curve("linear",   { type = "bezier", points = { {0.0,  0.0},  {1.0,  1.0}  } })
hl.curve("easeOut",  { type = "bezier", points = { {0.0,  0.0},  {0.2,  1.0}  } })

-- Window animations
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3, bezier = "snappy",  style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "easeOut", style = "popin 90%" })
hl.animation({ leaf = "windows",    enabled = true, speed = 3, bezier = "snappy" })

-- Fade
hl.animation({ leaf = "fadeIn",  enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "fade",    enabled = true, speed = 3, bezier = "smooth" })

-- Workspaces & layers
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4, bezier = "smooth",  style = "slidevert" })
hl.animation({ leaf = "layers",           enabled = true, speed = 3, bezier = "snappy" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 3, bezier = "premium", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 2, bezier = "easeOut", style = "fade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "bounce",  style = "slidevert" })

-- ┌─────────────────────────────────────────┐
-- │              INPUT                      │
-- └─────────────────────────────────────────┘
hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "caps:capslock",
        follow_mouse = 1,
        sensitivity  = 0,
        repeat_rate  = 50,
        repeat_delay = 240,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            drag_lock            = true,
            scroll_factor        = 0.8,
            disable_while_typing = true,
        },
    },
})

-- 3-finger horizontal swipe to switch workspaces
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- ┌─────────────────────────────────────────┐
-- │           SMART GAPS                    │
-- └─────────────────────────────────────────┘
-- No gaps when only one tiled window or in fullscreen
hl.workspace_rule({ workspace = "w[t1]", gaps_out = 5, gaps_in = 4 })
hl.workspace_rule({ workspace = "f[1]",  gaps_out = 5, gaps_in = 4 })

-- ┌─────────────────────────────────────────┐
-- │              KEYBINDINGS                │
-- └─────────────────────────────────────────┘
local mod = "SUPER"

-- ── Core ──────────────────────────────────────────────────────
hl.bind(mod .. " + Return",       hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + B",            hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + E",            hl.dsp.exec_cmd(files))
hl.bind(mod .. " + Space",        hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + W",            hl.dsp.window.close())
hl.bind(mod .. " + T",            hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + M",            hl.dsp.window.fullscreen(1))        -- maximize (keeps gaps)
hl.bind(mod .. " + SHIFT + M",    hl.dsp.window.fullscreen(0))        -- true fullscreen
-- hl.bind(mod .. " + Tab",          hl.dsp.cycle_next())             -- NOTE: verify at wiki.hypr.land if this errors
-- hl.bind(mod .. " + SHIFT + Tab",  hl.dsp.cycle_next({ prev = true })) -- NOTE: same
hl.bind(mod .. " + P",            hl.dsp.window.pseudo())
hl.bind(mod .. " + S", hl.dsp.exec_cmd("~/scripts/system-panel.sh"))
hl.bind(mod .. " + SHIFT + L",    hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --prompt '📋 Clipboard' --width 500 --height 400 | cliphist decode | wl-copy"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("echo -e '❌ Clear All Clipboard History\n🚪 Cancel' | wofi --dmenu --prompt 'Purge Clipboard?' --width 400 --height 220 | grep -q 'Clear' && cliphist wipe"))

-- ── Focus (vim keys + arrows) ─────────────────────────────────
hl.bind(mod .. " + H",     hl.dsp.focus({ direction = "left"  }))
hl.bind(mod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K",     hl.dsp.focus({ direction = "up"    }))
hl.bind(mod .. " + J",     hl.dsp.focus({ direction = "down"  }))
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- ── Move windows ──────────────────────────────────────────────
-- NOTE: if these error, try hl.dsp.window.move({ dir = "l" }) with short form
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))

-- ── Resize windows (keyboard, repeating) ─────────────────────
-- NOTE: if these error, check wiki for the correct resizeactive Lua dispatcher
hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x =  30, y =   0 }), { repeating = true })
hl.bind(mod .. " + CTRL + left",  hl.dsp.window.resize({ x = -30, y =   0 }), { repeating = true })
hl.bind(mod .. " + CTRL + up",    hl.dsp.window.resize({ x =   0, y = -30 }), { repeating = true })
hl.bind(mod .. " + CTRL + down",  hl.dsp.window.resize({ x =   0, y =  30 }), { repeating = true })

-- ── Workspaces 1–10 ───────────────────────────────────────────
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ── Scratchpad ────────────────────────────────────────────────
hl.bind(mod .. " + minus",         hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- ── Mouse ─────────────────────────────────────────────────────
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Volume Control Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true, locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })

-- Screen Brightness Keys
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true, locked = true })

-- ── Media (playerctl) ─────────────────────────────────────────
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- ┌─────────────────────────────────────────┐
-- │           WINDOW RULES                  │
-- └─────────────────────────────────────────┘

-- Block apps from sending maximize events
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drag issues
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- btop in a floating kitty window
hl.window_rule({
    name   = "kitty-btop",
    match  = { class = "kitty-btop" },
    float  = true,
    size   = { "monitor_w * 0.60", "monitor_h * 0.60" }, -- Dynamically takes 80% of your screen
    center = true,
})

-- Signal floating window
hl.window_rule({
    name   = "float-signal",
    match  = { class = "Signal" },
    float  = true,
    size   = { "monitor_w * 0.7", "monitor_h * 0.7" }, -- Takes 70% of your screen
    center = true,
})

-- hyprland-run helper window placement
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    float = true,
    move  = { "20", "monitor_h - 120" }, 
})

-- nmtui floating window
hl.window_rule({
    name   = "float-nmtui",
    match  = { class = "float-nmtui" },
    float  = true,
    size   = { "monitor_w * 0.5", "monitor_h * 0.5" }, -- Takes 50% of your screen
    center = true,
})
