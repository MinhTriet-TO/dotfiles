local status, _ = pcall(vim.cmd, "colorscheme catppuccin-mocha")
if not status then
    vim.notify("The colorscheme is not found bro")
    return
end
