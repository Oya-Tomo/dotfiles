vim.diagnostic.config({
    virtual_text = {
        source = "always",
        prefix = '●',
    },
    severity_sort = true,
    float = {
        source = "always",
    },
})

vim.diagnostic.enable()
