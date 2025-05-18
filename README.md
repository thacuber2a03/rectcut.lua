# rectcut.lua

an implementation of the [RectCut layouting system](https://halt.software/p/rectcut-for-dead-simple-ui-layouts) for Lua.

## usage

clone this repository as `rectcut` wherever you want, then `require 'rectcut'`.
this will provide you with a Rect class, which you can then instantiate by calling or by the functions `new` or `fromXYWH`.

## example

these examples are adapted from the article linked previously.

### toolbar layout

```lua
local Rect = require 'rectcut'

local layout = Rect(0, 0, 180, 16)

local r1 = layout:cut_left(16)
local r2 = layout:cut_left(16)
local r3 = layout:cut_left(16)

local r4 = layout:cut_right(16)
local r5 = layout:cut_right(16)
```

### two-panel application

```lua
local top = layout:cut_top(16)
	local button_close = top:cut_right(16)
	local button_maximize = top:cut_right(16)
	local button_minimize = top:cut_right(16)
local title = top

local bottom = layout:cut_bottom(16)

local panel_left = layout:cut_left(w/2)
local panel_right = layout
```

## license

this module is free software; you can redistribute it and/or modify it under the terms of the MIT License. See [LICENSE](./LICENSE) for details.
