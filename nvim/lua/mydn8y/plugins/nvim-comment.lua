local nvim_comment_setup, nvim_comment= pcall(require, "Comment")
if not nvim_comment_setup then
    return
end

nvim_comment.setup({
    toggler = {
        line = '<leader><space>',
    },
    opleader = {
        line = '<leader><space>',
    }
})
