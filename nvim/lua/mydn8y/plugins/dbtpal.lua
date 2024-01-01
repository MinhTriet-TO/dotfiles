-- import plugin safely
local dbt_setup, dbt= pcall(require, "dbtpal")
if not dbt_setup then
	return
end

local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
  return
end

dbt.setup {
    -- Path to the dbt executable
    path_to_dbt = "dbt",

    -- Path to the dbt project, if blank, will auto-detect
    -- using currently open buffer for all sql,yml, and md files
    path_to_dbt_project = "",

    -- Path to dbt profiles directory
    path_to_dbt_profiles_dir = "./dbt/profiles.yml",

    -- Search for ref/source files in macros and models folders
    extended_path_search = true,

    -- Prevent modifying sql files in target/(compiled|run) folders
    protect_compiled_files = true

}

-- Setup key mappings

vim.keymap.set('n', '<leader>drf', dbt.run)
vim.keymap.set('n', '<leader>drp', dbt.run_all)
vim.keymap.set('n', '<leader>dtf', dbt.test)
vim.keymap.set('n', '<leader>dm', require('dbtpal.telescope').dbt_picker)

-- Enable Telescope Extension
telescope.load_extension('dbtpal')
