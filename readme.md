# force-cul.nvim

This plugin ensures that signs have a cursorline highlight.

#### Before
<img width="200" alt="before" src="https://github.com/user-attachments/assets/dc8fd2e1-d9ca-4258-b7af-81314d87daa9">


#### After
<img width="200" alt="after" src="https://github.com/user-attachments/assets/8f7014b3-6d82-413b-adad-3f0053727f0d">


### Setup (lazy.nvim)

```lua
{
    "jake-stewart/force-cul.nvim",
    config = function()
        require("force-cul").setup()
    end
}
```

### API
You can ignore this section. The plugin works automatically.

```lua
-- Force update the highlight groups.
-- This is useful if you programatically change the CursorLineSign highlight.
require("force-cul").forceUpdate()
```
