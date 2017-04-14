# vim-LineUp

When enabled, once text changed, move the current line upward until
encountering a line not longer than it.

## Dependency

[`MappingMem`](https://github.com/Ace-Who/vim-MappingMem) plugin. This
is not necessary but recommended, which can restore the mappings overriden by
`AutoCenter` when you turn it off.

## Usage

- `:LineUpOn`: enable LineUp.
- `:LineUpOff`: disable LineUp.

When enabled,
     
- Once the text is changed except by an undo or redo operation, move current
line above the previous repeatedly if the previous is longer.
