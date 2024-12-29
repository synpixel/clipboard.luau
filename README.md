# Clipboard

## Installation

### pesde

```sh
pesde add synpixel/clipboard
```

## Quick Start

```luau
local clipboard = require("@pkg/clipboard")

local text = clipboard.read():unwrap()
print(text)

clipboard.write("hello, world!"):unwrap()
```
