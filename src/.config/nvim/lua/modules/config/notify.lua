return function()
    ---@diagnostic disable: missing-fields
    require('notify').setup({
        timeout = 4000,
        background_colour = 'NotifyBackground',
        fps = 30,
        icons = {
            DEBUG = '',
            ERROR = '',
            INFO = '',
            TRACE = '✎',
            WARN = '',
        },
        level = 2,
        minimum_width = 50,
        max_width = 50,
        render = 'wrapped-default',
        stages = 'fade_in_slide_out',
        top_down = true,
    })
end
