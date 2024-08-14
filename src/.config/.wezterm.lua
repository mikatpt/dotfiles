local wezterm = require('wezterm')
local c = {}

---@type number | nil
local dpi = 74

local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local is_wsl = false
local default_domain = 'local'
local default_prog = nil
local fonts = { 'SauceCodePro NFM', 'Fira Code', 'Cascadia Code' }

if is_windows then
    is_wsl, _, _ = wezterm.run_child_process({ 'where', 'wsl.exe' })
end

if is_wsl then
    default_domain = 'WSL:Ubuntu-20.04'
    default_prog = { 'wsl.exe', '--distribution', 'Ubuntu-20.04' }
    dpi = nil
else
    table.insert(fonts, 1, { family = 'SauceCodePro Nerd Font Mono', weight = 'Medium' })
end

c.scrollback_lines = 10000
c.audible_bell = 'Disabled'
c.default_prog = default_prog
c.default_domain = default_domain
c.dpi = dpi
c.font = wezterm.font_with_fallback(fonts)
c.freetype_load_flags = 'NO_HINTING'
c.font_size = is_wsl and 12.0 or 15.0
c.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }
c.use_fancy_tab_bar = false
c.tab_bar_at_bottom = false
c.tab_max_width = 50
c.status_update_interval = 1000
c.enable_scroll_bar = true
c.inactive_pane_hsb = {
    saturation = 1,
    brightness = 0.9,
}
c.show_new_tab_button_in_tab_bar = false
-- start with default session so main can be long-lived.
c.default_workspace = 'default'

----------------
--- Sessions ---
----------------

local mux = wezterm.mux

local function home_startup(_)
    local _, pane, window = mux.spawn_window({
        workspace = 'home',
        cwd = '/home/mikatpt/coding/home/backend',
    })
    _, pane, window = mux.spawn_window({
        workspace = 'main',
        cwd = '~',
        args = { 'fish', '-l' },
    })

    for _ = 1, 3 do
        window:spawn_tab({ cwd = '~' })
    end
    mux.set_active_workspace('main')
    pane:activate()
end

local function work_startup(_)
    local tab, pane, window = mux.spawn_window({
        workspace = 'main',
        cwd = '~',
        args = { 'zsh', '-l' },
    })
    tab:set_title('sts')

    for i = 1, 3 do
        local t, _, _ = window:spawn_tab({ cwd = '~' })
        if i == 1 then
            t:set_title('sts')
        end
    end
    mux.set_active_workspace('main')
    pane:activate()
end

wezterm.on('gui-startup', function(cmd)
    if is_wsl then
        home_startup(cmd)
    else
        work_startup(cmd)
    end
end)

-----------------
---- Styling ----
-----------------

local hl = {
    bg_blue = 'hsl:210 100 4',
    bg_blue_2 = 'hsl:210 20 14',
    bg_blue_3 = 'hsl:210 100 13',
    blue = 'hsl:212 95 38',
    sky_blue = 'hsl:204 83 63',
    light_blue = 'hsl:206 71 55',
    light_blue_2 = 'hsl:212 67 51',
    light_gray = 'hsl:193 6 58',
    gray = 'hsl:261 8 33',
    turquoise = 'hsl:180 100 48',
    black = 'hsl:254 25 10',
    total_black = 'hsl:0 0 0',
    purple = 'hsl:293 74 34',
    purple_2 = 'hsl:275 100 64',
    pink = 'hsl:286 60 67',
    red = 'hsl:0 100 48',
    red_2 = 'hsl:357 76 43',
    green = 'hsl:146 93 39',
    green_2 = 'hsl:152 62 39',
    light_jade = 'hsl:107 100 88',
    jade = 'hsl:158 56 52',
    lime = 'hsl:120 100 48',
    tan = 'hsl:27 36 47',
    silver = 'hsl:0 0 80',
    grey = 'hsl:0 0 48',
    ivory = 'hsl:47 96 81',
    white = 'hsl:0 0 95',
    light_violet = 'hsl:229 73 86',
    golden = 'hsl:54 90 49',
}

c.colors = {
    ansi = {
        hl.black,
        is_windows and hl.red_2 or hl.red,
        is_windows and hl.green_2 or hl.green,
        hl.ivory,
        hl.blue,
        hl.purple,
        hl.light_blue,
        hl.silver,
    },
    brights = {
        hl.grey,
        hl.red,
        hl.lime,
        hl.ivory,
        hl.light_blue_2,
        hl.purple_2,
        hl.turquoise,
        hl.white,
    },
    foreground = is_windows and hl.white or hl.silver,
    background = hl.bg_blue,
    cursor_bg = hl.light_violet,
    cursor_fg = hl.total_black,
    cursor_border = hl.light_violet,
    selection_fg = hl.total_black,
    selection_bg = hl.light_jade,
    scrollbar_thumb = hl.bg_blue_2,
    split = hl.bg_blue_3,
    compose_cursor = hl.jade, -- leader key on press
    copy_mode_active_highlight_fg = { Color = hl.total_black },
    copy_mode_active_highlight_bg = { Color = hl.jade },
    copy_mode_inactive_highlight_bg = { Color = hl.golden },
    copy_mode_inactive_highlight_fg = { Color = hl.total_black },
    quick_select_label_bg = { Color = hl.golden },
    quick_select_label_fg = { Color = hl.black },
    quick_select_match_bg = { Color = hl.light_jade },
    quick_select_match_fg = { Color = hl.total_black },
    tab_bar = {
        background = hl.bg_blue,
        active_tab = {
            bg_color = hl.sky_blue,
            fg_color = hl.bg_blue,
            intensity = 'Bold',
        },
        inactive_tab = {
            bg_color = hl.bg_blue,
            fg_color = hl.light_gray,
        },
        new_tab = {
            bg_color = hl.gray,
            fg_color = hl.bg_blue,
        },
    },
}

wezterm.on('format-window-title', function()
    return 'Wezterm'
end)

-- tab, tabs, panes, config, hover, max_width
wezterm.on('format-tab-title', function(tab, _, _, _, _, _)
    local foreground = tab.is_active and hl.sky_blue or hl.light_gray

    local t = tab.tab_title
    -- use auto-gen tab title if not named
    if t == '' or not t then
        t = tab.active_pane.title:match('^%s*(.*)'):match('^[^%s]*')
    end
    -- default to terminal if no program
    if t == '~' then
        t = is_wsl and 'fish' or 'zsh'
    end

    local title = tab.tab_index + 1 .. ' ' .. t

    return {
        { Background = { Color = hl.bg_blue } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Foreground = { Color = hl.bg_blue } },
        { Text = ' ' },
    }
end)

wezterm.on('update-status', function(window, _)
    -- Display the session name on the left (simulating `status-left`)
    local session_name = '  ' .. wezterm.mux.get_active_workspace() .. ' '

    window:set_left_status(wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Background = { Color = hl.sky_blue } },
        { Foreground = { Color = hl.bg_blue } },
        { Text = session_name .. '' },
        { Background = { Color = hl.bg_blue } },
        { Text = ' ' },
    }))

    local date_cmd = { 'date' }
    local whoami = { 'whoami' }
    if is_wsl then
        table.insert(date_cmd, 1, 'wsl.exe')
        table.insert(whoami, 1, 'wsl.exe')
    end

    local _, date, _ = wezterm.run_child_process(date_cmd)
    local _, me, _ = wezterm.run_child_process(whoami)
    date = wezterm.strftime('%a %m/%d %k:%M%P')
    local clock_display = ' ' .. date .. ' '
    local user_info = ' ' .. me .. ' '
    local mode = window:active_key_table()
    local mode_display = 'NORM'
    local mode_fg = hl.white
    if mode == 'copy_mode' then
        mode_display = 'COPY'
        mode_fg = hl.golden
    elseif mode == 'search_mode' then
        mode_display = 'SEARCH'
        mode_fg = hl.red
    elseif mode == 'quick_select' then
        mode_display = 'SELECT'
        mode_fg = hl.lime
    end

    window:set_right_status(wezterm.format({
        { Foreground = { Color = mode_fg } },
        { Attribute = { Intensity = 'Bold' } },
        { Text = mode_display },
        { Background = { Color = hl.bg_blue } },
        { Foreground = { Color = hl.pink } },
        { Text = clock_display },
        { Background = { Color = hl.bg_blue } },
        { Foreground = { Color = hl.sky_blue } },
        { Text = '' .. user_info },
    }))
end)

-----------------
-- Keybindings --
-----------------

local default_keys = wezterm.gui.default_key_tables()
local act = wezterm.action

local function extend_keys(target, source)
    local map = {}
    for i = 1, #target do
        local item = target[i]
        map[item.key] = item
    end
    for i = 1, #source do
        local item = source[i]
        local key = item.key
        if map[key] ~= nil then
            table[i] = map[key]
        else
            table.insert(target, source[i])
        end
    end
    return target
end

local function tmux(key, action)
    return {
        key = key,
        mods = 'LEADER',
        action = action,
    }
end

local function ctrl_tmux(key, action)
    local ret = tmux(key, action)
    ret.mods = ret.mods .. '|' .. 'CTRL'
    return ret
end

local function close_copy_mode()
    return act.Multiple({
        act.CopyMode('ClearSelectionMode'),
        act.CopyMode('ClearPattern'),
        act.CopyMode('Close'),
    })
end
local function copy_to()
    return act.Multiple({
        act.CopyTo('Clipboard'),
        act.CopyMode('ClearSelectionMode'),
    })
end
local function next_match(int)
    local m = act.CopyMode('NextMatch')
    if int == -1 then
        m = act.CopyMode('PriorMatch')
    end
    return act.Multiple({ m, act.CopyMode('ClearSelectionMode') })
end

c.keys = {
    ctrl_tmux('q', act.SwitchWorkspaceRelative(1)),
    ctrl_tmux('r', act.ReloadConfiguration),
    ctrl_tmux('o', act.RotatePanes('Clockwise')),
    ctrl_tmux('s', act.Multiple({ act.CopyMode('ClearSelectionMode'), act.ActivateCopyMode })),
    ctrl_tmux('[', act.SplitHorizontal({ domain = 'CurrentPaneDomain' })),
    ctrl_tmux(']', act.SplitVertical({ domain = 'CurrentPaneDomain' })),
    ctrl_tmux(
        ',',
        act.PromptInputLine({
            description = 'Enter new tab name',
            action = wezterm.action_callback(function(window, _, line)
                print(line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        })
    ),
    ctrl_tmux('l', act.ActivatePaneDirection('Right')),
    ctrl_tmux('h', act.ActivatePaneDirection('Left')),
    ctrl_tmux('k', act.ActivatePaneDirection('Next')),
    ctrl_tmux('j', act.ActivatePaneDirection('Prev')),
    tmux('j', act.ActivatePaneDirection('Down')),
    tmux('k', act.ActivatePaneDirection('Up')),
    ctrl_tmux('t', act.SpawnTab('CurrentPaneDomain')),
    ctrl_tmux('p', act.ActivateTabRelative(-1)),
    ctrl_tmux('n', act.ActivateTabRelative(1)),
    ctrl_tmux('1', act.ActivateTab(1)),
    ctrl_tmux('2', act.ActivateTab(2)),
    ctrl_tmux('3', act.ActivateTab(3)),
    ctrl_tmux('4', act.ActivateTab(4)),
    ctrl_tmux('5', act.ActivateTab(5)),
    ctrl_tmux('6', act.ActivateTab(6)),
    ctrl_tmux('7', act.ActivateTab(7)),
    ctrl_tmux('8', act.ActivateTab(8)),
    ctrl_tmux('9', act.ActivateTab(9)),
    ctrl_tmux(
        'LeftArrow',
        act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, timeout_milliseconds = 400 })
    ),
    ctrl_tmux(
        'RightArrow',
        act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, timeout_milliseconds = 400 })
    ),
    tmux('LeftArrow', act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, timeout_milliseconds = 400 })),
    tmux('RightArrow', act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, timeout_milliseconds = 400 })),
}

c.key_tables = {
    copy_mode = extend_keys(default_keys.copy_mode, {
        { key = 'c', mods = 'CTRL', action = close_copy_mode() },
        { key = 'q', mods = 'NONE', action = close_copy_mode() },
        { key = 'y', mods = 'NONE', action = copy_to() },
        { key = 'Escape', mods = 'NONE', action = close_copy_mode() },

        { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
        { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
        { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
        { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },
        {
            key = '/',
            mods = 'NONE',
            action = act.Multiple({
                act.CopyMode('ClearPattern'),
                act.EmitEvent('update-status'),
                act.Search({ CaseInSensitiveString = '' }),
            }),
        },
        {
            key = '?',
            mods = 'NONE',
            action = act.Multiple({
                act.CopyMode('ClearPattern'),
                act.EmitEvent('update-status'),
                act.Search({ CaseInSensitiveString = '' }),
            }),
        },
        { key = 'p', mods = 'CTRL', action = next_match(-1) },
        { key = 'n', mods = 'CTRL', action = next_match(1) },
        { key = 'n', mods = 'NONE', action = next_match(1) },
        { key = 'N', mods = 'NONE', action = next_match(-1) },
    }),
    resize_pane = {
        { key = 'LeftArrow', mods = 'CTRL', action = act.AdjustPaneSize({ 'Left', 2 }) },
        { key = 'LeftArrow', mods = 'NONE', action = act.AdjustPaneSize({ 'Left', 2 }) },
        { key = 'RightArrow', mods = 'CTRL', action = act.AdjustPaneSize({ 'Right', 2 }) },
        { key = 'RightArrow', mods = 'NONE', action = act.AdjustPaneSize({ 'Right', 2 }) },
    },
    search_mode = extend_keys(default_keys.search_mode, {
        {
            key = 'Escape',
            mods = 'NONE',
            action = act.Multiple({ act.CopyMode('Close'), act.EmitEvent('update-status') }),
        },
        {
            key = 'Enter',
            mods = 'NONE',
            action = act.Multiple({
                act.ActivateCopyMode,
                act.EmitEvent('update-status'),
                -- act.SendKey({ key = 'v', mods = 'NONE' }), -- Currently doesn't work.
            }),
        },
    }),
}

return c
