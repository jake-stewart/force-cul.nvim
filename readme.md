# force-cul.nvim

various sign plugins and even built in lsp fail to
show appropriate cursorline highlight for signs.

this plugin should make all extmark signs obey your
cursorline highlight.

#### before
<img width="168" alt="before" src="https://github.com/user-attachments/assets/384d69c8-8eb7-459a-89ec-d45f69e7d092">

#### after
<img width="175" alt="after" src="https://github.com/user-attachments/assets/f6e8fe7e-dc5e-4471-93af-2618e00d233d">


### setup (lazy.nvim)

```lua
{
    "jake-stewart/force-cul.nvim",
    config = function()
        require("force-cul").setup()
    end
}
```

### api
you don't need to worry about the api, it all works automatically.

```lua
-- forces the sign hl to update
-- this is useful if you programatically change CursorLineSign highlight
require("force-cul").forceUpdate()
```
