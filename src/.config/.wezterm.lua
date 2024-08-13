local wezterm = require('wezterm')
local c = {}

---@type number | nil
local dpi = 73

local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local is_wsl = false
local default_domain = 'local'
local default_prog = nil
local fonts = { 'SauceCodePro Nerd Font Mono', 'SauceCodePro NFM', 'Fira Code', 'Cascadia Code' }

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

local tmux_bg = '#000A14'
local tmux_blue = '#51afef'
local tmux_grey = '#8c979a'
local tmux_magenta = '#c678dd'

local color_map = {
    mac = {
        ansi = {
            '#171421', -- 'black',
            'red', -- 'maroon',
            'hsl:146 93 39', -- 'green',
            '#A2734C', -- 'olive',
            'hsl:212 95 38', -- 'navy',
            '#881798', -- 'purple',
            '#3A96DD', -- 'teal',
            '#CCCCCC', -- 'silver',
        },
        brights = {
            'grey', -- grey
            'red', -- red
            'lime', -- lime
            'hsl:47 96 81', -- ivory
            'hsl:212 67 51', -- light blue
            'hsl:275 100 64', -- fuchsia
            'aqua', -- aqua
            '#F2F2F2', -- white
        },
    },
    windows = {
        ansi = {
            '#171421', -- 'black',
            '#C21A23', -- 'maroon',
            '#26A269', -- 'green',
            '#A2734C', -- 'olive',
            'hsl:212 95 38', -- 'navy',
            '#881798', -- 'purple',
            '#3A96DD', -- 'teal',
            '#CCCCCC', -- 'silver',
        },
        brights = {
            'grey', -- grey
            'red', -- red
            'lime', -- lime
            'hsl:47 96 81', -- ivory
            'hsl:212 67 51', -- light blue
            'hsl:275 100 64', -- fuchsia
            'aqua', -- aqua
            '#F2F2F2', -- white
        },
    },
}
local colors = is_windows and color_map.windows or color_map.mac

c.colors = {
    foreground = '#FFFFFF',
    background = 'hsl:210 100 4',
    cursor_bg = '#c0caf5',
    cursor_fg = 'hsl:0 0 0',
    cursor_border = '#52ad70', -- TODO
    selection_fg = 'black',
    selection_bg = 'hsl:107 100 88',
    scrollbar_thumb = 'hsl:210 20 14',
    split = 'hsl:210 100 13',
    ansi = colors.ansi,
    brights = colors.brights,
    compose_cursor = 'hsl:158 56 52', -- leader key on press
    copy_mode_active_highlight_fg = { Color = 'hsl:0 0 0' },
    copy_mode_active_highlight_bg = { Color = 'hsl:100 90 49' },
    copy_mode_inactive_highlight_bg = { Color = 'hsl:54 90 49' },
    copy_mode_inactive_highlight_fg = { Color = 'hsl:0 0 0' },
    quick_select_label_bg = { Color = 'hsl:54 90 49' },
    quick_select_label_fg = { Color = '#171421' },
    quick_select_match_bg = { Color = 'hsl:107 100 88' },
    quick_select_match_fg = { Color = 'hsl:0 0 0' },
    tab_bar = {
        background = tmux_bg,
        active_tab = {
            bg_color = tmux_blue,
            fg_color = tmux_bg,
            intensity = 'Bold',
        },
        inactive_tab = {
            bg_color = tmux_bg,
            fg_color = tmux_grey,
        },
        new_tab = {
            bg_color = 'hsl:261 8 33',
            fg_color = tmux_bg,
        },
    },
}

wezterm.on('format-window-title', function()
    return 'Wezterm'
end)

-- tab, tabs, panes, config, hover, max_width
wezterm.on('format-tab-title', function(tab, _, _, _, _, _)
    local foreground = tab.is_active and tmux_blue or tmux_grey

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
        { Background = { Color = tmux_bg } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Foreground = { Color = tmux_bg } },
        { Text = ' ' },
    }
end)

wezterm.on('update-status', function(window, _)
    -- Display the session name on the left (simulating `status-left`)
    local session_name = '  ' .. wezterm.mux.get_active_workspace() .. ' '

    window:set_left_status(wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Background = { Color = tmux_blue } },
        { Foreground = { Color = tmux_bg } },
        { Text = session_name .. '' },
        { Background = { Color = tmux_bg } },
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

    window:set_right_status(wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Background = { Color = tmux_bg } },
        { Foreground = { Color = tmux_magenta } },
        { Text = clock_display },
        { Background = { Color = tmux_bg } },
        { Foreground = { Color = tmux_blue } },
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

c.keys = {
    ctrl_tmux('q', act.SwitchWorkspaceRelative(1)),
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
}

c.key_tables = {
    copy_mode = extend_keys(default_keys.copy_mode, {
        { key = 'c', mods = 'CTRL', action = act.CopyMode('Close') },
        { key = 'q', mods = 'NONE', action = act.CopyMode('Close') },
        { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },

        { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
        { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
        { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
        { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },
        {
            key = '/',
            mods = 'NONE',
            action = act.Multiple({
                act.Search({ CaseInSensitiveString = '' }),
                act.CopyMode('ClearSelectionMode'),
            }),
        },
        { key = 'p', mods = 'CTRL', action = act.CopyMode('PriorMatch') },
        { key = 'n', mods = 'CTRL', action = act.CopyMode('NextMatch') },
        {
            key = 'n',
            mods = 'NONE',
            action = act.Multiple({ act.CopyMode('NextMatch'), act.CopyMode('ClearSelectionMode') }),
        },
        {
            key = 'N',
            mods = 'NONE',
            action = act.Multiple({ act.CopyMode('PriorMatch'), act.CopyMode('ClearSelectionMode') }),
        },
    }),
    resize_pane = {
        { key = 'LeftArrow', mods = 'CTRL', action = act.AdjustPaneSize({ 'Left', 2 }) },
        { key = 'LeftArrow', mods = 'NONE', action = act.AdjustPaneSize({ 'Left', 2 }) },
        { key = 'RightArrow', mods = 'CTRL', action = act.AdjustPaneSize({ 'Right', 2 }) },
        { key = 'RightArrow', mods = 'NONE', action = act.AdjustPaneSize({ 'Right', 2 }) },
    },
    search_mode = extend_keys(default_keys.search_mode, {
        { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
        {
            key = 'Enter',
            mods = 'NONE',
            action = act.Multiple({
                act.ActivateCopyMode,
                act.SendKey({ key = 'v', mods = 'NONE' }),
            }),
        },
    }),
}

return c
