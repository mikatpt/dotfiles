" Enable Mouse
set mouse=a
set termguicolors
colo lucid_nvim

" Set Editor Font
if exists(':GuiFont')
	" Use GuiFont! to ignore fonterrors
	GuiFont! SauceCodePro NF:h11
endif

" Disable GUI Tabline
if exists(':GuiTabline')
	GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
	GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
	GuiScrollBar 1
endif

" Right click Context menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
