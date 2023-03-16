local status, _ = pcall(vim.cmd, "colorscheme OceanicNext")
if not status then
    vim.notify("The colorscheme is not found bro")
    return
end
