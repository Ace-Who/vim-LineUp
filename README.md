# vim-LineUp

![vim-LineUp-demo](https://github.com/Ace-Who/vim-LineUp/blob/master/demo/vim-LineUp-demo-002.gif)

Let the current line "climb" up and down on the basis of its width and the
adjacent lines'.

This plugin is written for fun, but can be useful for some ones.

## Dependency

[`MappingMem`](https://github.com/Ace-Who/vim-MappingMem) plugin. This
is not necessary but recommended, which can restore the mappings overriden by
`AutoCenter` when you turn it off.

## Usage

- `:LineUpOn`: enable LineUp.
- `:LineUpOff`: disable LineUp.

When enabled,
     
- Once the text is changed except by an undo or redo operation, move the
current line upward until encountering a line not longer than it, otherwise
downward in like manner.
- Never moves a line across any blank line.
