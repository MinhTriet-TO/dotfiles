local comment_setup, comment= pcall(require, "nvim_comment")
if not comment_setup then
    return
end

comment.setup()
