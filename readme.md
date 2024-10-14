# force-cul.nvim

various sign plugins and even built in lsp fail to
show appropriate cursorline highlight for signs.

this plugin should make all extmark signs obey your
cursorline highlight.

### setup (lazy.nvim)

```lua
{
    "jake-stewart/force-cul.nvim",
    config = function()
        require("force-cul").setup()
    end
}
```

