# vim-LineUp

Let the current line "climb" up and down by itself on the basis of its width
and the adjacent lines'.

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
