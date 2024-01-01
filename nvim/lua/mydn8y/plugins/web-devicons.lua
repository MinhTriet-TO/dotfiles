local web_devicons_setup, web_devicons = pcall(require, "nvim-web-devicons")
if not web_devicons_setup then
    return
end

web_devicons.setup {
    strict = true;
    override_by_extension = {
        ["toml"] = {
            icon = "",
            color = "#3273ad",
            name = "Toml"
        },
        ["duckdb"] = {
            icon = "",
            color = "#dddd08",
            name = "Duckdb"
        },
        ["wal"] = {
            icon = "",
            color = "#dddd08",
            name = "DuckdbWal"
        }
    };
}
