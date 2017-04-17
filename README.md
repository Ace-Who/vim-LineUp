# vim-LineUp

![vim-LineUp-demo](https://github.com/Ace-Who/vim-LineUp/blob/master/demo/vim-LineUp-demo-003.gif)

Let the current line "climb" up and down on the basis of its width and the
adjacent lines'.

This plugin is written for fun, but can be useful for some ones.

## Usage

- `:LineUpOn`: enable LineUp.
- `:LineUpOff`: disable LineUp.
- `:LineUpReverse`: reverse the movement direction, meaning the short goes down
and the long goes up.

When enabled,
     
- Once the text is changed except by an undo or redo operation, move the
current line upward until encountering a line not longer than it, otherwise
downward in like manner.
- Never moves a line across any blank line.

## Dependency

- [MappingMem](https://github.com/Ace-Who/vim-MappingMem) plugin. Optional but
recommended. Used to restore the mappings overriden or deleted by `AutoCenter`
automatically when you turn it off.
