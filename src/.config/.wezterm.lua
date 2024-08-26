local wezterm = require('wezterm')
local c = {}

local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local is_wsl = false
if is_windows then
    is_wsl, _, _ = wezterm.run_child_process({ 'where', 'wsl.exe' })
end

local fonts = { 'SauceCodePro NFM', 'Fira Code', 'Cascadia Code' }
if not is_wsl then
    table.insert(fonts, 1, { family = 'SauceCodePro Nerd Font Mono', weight = 'Medium' })
end

c.scrollback_lines = 10000
c.audible_bell = 'Disabled'
c.default_prog = is_wsl and { 'wsl.exe', '--distribution', 'Ubuntu-20.04' } or nil
c.default_domain = is_wsl and 'WSL:Ubuntu-20.04' or 'local'
c.font = wezterm.font_with_fallback(fonts)
c.freetype_load_flags = 'NO_HINTING'
c.font_size = is_wsl and 12.6 or 15.3
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

------------------
----- Colors -----
------------------

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
    dark_gold = 'hsl:37 100 39',
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

-----------------
---- Styling ----
-----------------

local CPU_UPDATE_SECS = 5

wezterm.GLOBAL.git_dirs = wezterm.GLOBAL.git_dirs or {}

-- Sometimes reloads can cause bad state with our shitty sync mutexes.
wezterm.GLOBAL.cpu_locked = false
for _, dir in pairs(wezterm.GLOBAL.git_dirs) do
    dir.locked = false
end

-- Shell helpers --

local function update_cpu()
    local cmd = is_windows and { 'wmic', 'cpu', 'get', 'loadpercentage' } or { 'top', '-l', '1' }
    local matcher = is_windows and '%d+' or 'CPU usage:.* (%d+%.%d+)%% idle \n'

    local success, cpu, err = wezterm.run_child_process(cmd)
    if not success then
        wezterm.log_error('could not get cpu %', err)
        return 0
    end
    local res = math.floor(tonumber(cpu:match(matcher)) + 0.5)
    return is_windows and res or 100 - res
end

local function get_user_info()
    local whoami = is_wsl and { 'wsl.exe', 'whoami' } or { 'whoami' }
    local _, me, _ = wezterm.run_child_process(whoami)
    return me and me:gsub('%s+$', ' | ') or 'me'
end

local function update_git_dir(cwd)
    local cmd = { 'git', '-C', cwd, 'rev-parse', '--show-toplevel' }
    if is_wsl then
        table.insert(cmd, 1, 'wsl.exe')
    end
    local success, dir, _ = wezterm.run_child_process(cmd)
    dir = success and dir:gsub('%s+$', ''):match('[^/\\]+$') or nil

    return success and dir or nil
end

local function get_cwd(pane)
    local success, cwd = pcall(function()
        return pane:get_current_working_dir()
    end)
    return (success and cwd ~= nil) and cwd.file_path or ''
end

-- Async Update Handlers --

local function tick_cpu()
    if wezterm.GLOBAL.cpu_locked then
        return
    end
    wezterm.GLOBAL.cpu_locked = true
    wezterm.time.call_after(CPU_UPDATE_SECS, function()
        wezterm.GLOBAL.cpu = update_cpu()
        wezterm.GLOBAL.cpu_locked = false
    end)
end

local function tick_git(pane, cwd)
    local id = tostring(pane:pane_id())
    wezterm.GLOBAL.git_dirs[id] = wezterm.GLOBAL.git_dirs[id] or {}
    local info = wezterm.GLOBAL.git_dirs[id]

    -- skip update if updating or if same dir
    if info.locked or cwd == info.prev_cwd then
        return
    end

    wezterm.GLOBAL.git_dirs[id].locked = true
    wezterm.time.call_after(0, function()
        wezterm.GLOBAL.git_dirs[id] = {
            dir = update_git_dir(cwd),
            prev_cwd = cwd,
        }
    end)
end

local function run_async_updates(pane, cwd)
    tick_cpu()
    tick_git(pane, cwd)
end

-- Display Helpers --

local mode_map = {
    copy_mode = { text = 'COPY', hl = hl.golden },
    search_mode = { text = 'SEARCH', hl = hl.red },
    quick_select = { text = 'SELECT', hl = hl.lime },
    [''] = { text = 'NORM', hl = hl.light_violet },
}

local function update_dynamic_colors(window, _)
    local overrides = { colors = c.colors }

    overrides.colors.cursor_bg = mode_map[window:active_key_table() or ''].hl
    window:set_config_overrides(overrides)
end

local function get_cpu_display_and_hl()
    local cpu = wezterm.GLOBAL.cpu or 0
    local display_cpu = ' CPU 00.00% '
    local display_color = hl.green_2
    if cpu ~= 0 then
        display_color = cpu < 50 and hl.green_2 or hl.dark_gold
        display_color = cpu > 75 and hl.red_2 or display_color
        display_cpu = string.format(' CPU %02d%% ', cpu)
    end
    return display_cpu, display_color
end

-- Status Formatters --

local function format_left()
    local session_info = '  ' .. get_user_info() .. wezterm.mux.get_active_workspace() .. ' '

    return wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Background = { Color = hl.sky_blue } },
        { Foreground = { Color = hl.bg_blue } },
        { Text = session_info .. '' },
        { Background = { Color = hl.bg_blue } },
        { Text = ' ' },
    })
end

local function format_right(window, cwd)
    local cwd_display = '  ' .. cwd:gsub(wezterm.home_dir, '~') .. ' '
    local mode = mode_map[window:active_key_table() or '']
    local cpu, cpu_hl = get_cpu_display_and_hl()

    local items = {
        { Foreground = { Color = hl.purple_2 } },
        { Text = cwd_display },
        { Foreground = { Color = mode.hl } },
        { Attribute = { Intensity = 'Bold' } },
        { Text = mode.text },
        { Foreground = { Color = cpu_hl } },
        { Text = cpu },
    }

    return wezterm.format(items)
end

local pane_subs = {
    ['simple-trade'] = 'sts',
    ['~'] = is_wsl and 'fish' or 'zsh',
}

-- This function is latency sensitive. Prefer retrieving state from 'update-status'.
-- tab, tabs, panes, config, hover, max_width
local function format_tab_title(tab, _, _, _, _, _)
    local info = wezterm.GLOBAL.git_dirs[tostring(tab.active_pane.pane_id)]
    local foreground = tab.is_active and hl.sky_blue or hl.light_gray

    -- Use user-define title, git dir, or 1st word of dyn title.
    local t = tab.tab_title
    t = t ~= '' and t or ((info and info.dir) and info.dir or nil)
    t = t and t or tab.active_pane.title:match('^[^%s]*')

    t = pane_subs[t] or t

    return {
        { Background = { Color = hl.bg_blue } },
        { Foreground = { Color = foreground } },
        { Text = tab.tab_index + 1 .. ' ' .. t .. ' ' },
        { Foreground = { Color = hl.bg_blue } },
        { Text = ' ' },
    }
end

-- Event handlers --

wezterm.on('update-status', function(window, pane)
    local cwd = get_cwd(pane)

    run_async_updates(pane, cwd)
    update_dynamic_colors(window, pane)

    window:set_left_status(format_left())
    window:set_right_status(format_right(window, cwd))
end)

wezterm.on('format-window-title', function()
    return 'Wezterm'
end)

wezterm.on('format-tab-title', format_tab_title)

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
    return { key = key, mods = 'LEADER', action = action }
end

local function ctrl_tmux(key, action)
    local ret = tmux(key, action)
    ret.mods = ret.mods .. '|' .. 'CTRL'
    return ret
end

local function close_copy_mode()
    return act.Multiple({
        act.EmitEvent('update-status'),
        act.CopyMode('ClearSelectionMode'),
        act.CopyMode('ClearPattern'),
        act.CopyMode('Close'),
    })
end

local function copy_to()
    return act.Multiple({ act.CopyTo('Clipboard'), act.CopyMode('ClearSelectionMode') })
end

local function next_match(int)
    local m = act.CopyMode(int == -1 and 'PriorMatch' or 'NextMatch')
    return act.Multiple({ m, act.CopyMode('ClearSelectionMode') })
end

local function tab_rename()
    return act.PromptInputLine({
        description = 'Enter new tab name',
        action = wezterm.action_callback(function(window, _, line)
            if line then
                window:active_tab():set_title(line)
            end
        end),
    })
end

local function new_workspace()
    return act.PromptInputLine({
        description = 'Enter workspace name',
        action = wezterm.action_callback(function(window, pane, name)
            name = name or ''
            name = name ~= '' and name or 'default'
            window:perform_action(act.SwitchToWorkspace({ name = name }), pane)
        end),
    })
end

c.keys = {
    ctrl_tmux('q', act.SwitchWorkspaceRelative(1)),
    ctrl_tmux('r', act.ReloadConfiguration),
    ctrl_tmux('o', act.RotatePanes('Clockwise')),
    ctrl_tmux('s', act.Multiple({ act.CopyMode('ClearSelectionMode'), act.ActivateCopyMode })),
    ctrl_tmux('[', act.SplitHorizontal({ domain = 'CurrentPaneDomain' })),
    ctrl_tmux(']', act.SplitVertical({ domain = 'CurrentPaneDomain' })),
    ctrl_tmux(',', tab_rename()),
    tmux(',', tab_rename()),
    ctrl_tmux('l', act.ActivatePaneDirection('Right')),
    ctrl_tmux('h', act.ActivatePaneDirection('Left')),
    ctrl_tmux('k', act.ActivatePaneDirection('Next')),
    ctrl_tmux('j', act.ActivatePaneDirection('Prev')),
    tmux('j', act.ActivatePaneDirection('Down')),
    tmux('k', act.ActivatePaneDirection('Up')),
    ctrl_tmux('t', act.SpawnTab('CurrentPaneDomain')),
    ctrl_tmux('p', act.ActivateTabRelative(-1)),
    ctrl_tmux('m', new_workspace()),
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
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },
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
            mods = 'SHIFT',
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
        { key = 'r', mods = 'CTRL', action = act.CopyMode('CycleMatchType') },
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

----------------
--- Sessions ---
----------------

local mux = wezterm.mux

local function home_startup(_)
    local _, pane, window = mux.spawn_window({
        workspace = 'home',
        cwd = '/home/mikatpt/coding/home/backend',
    })
    pane:send_text('keychain --eval $SSH_KEYS_TO_AUTOLOAD | source\n')
    pane:send_text('cargo run --release\n')
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

return c
