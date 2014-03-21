# Luvit-Markdown

Markdown parser for [Luvit](http://luvit.io/) without external dependencies.

## Installation

```shell
git clone git://github.com/mneudert/luvit-markdown.git
cd luvit-markdown
make install
```

## Notes

See src/test.lua for details about what exactly is getting parsed and what not.
And obviously to see all the quirks this parser has :)

The following options can be passed to make

```makefile
PREFIX?=/usr/local
LIBDIR?=${PREFIX}/lib/luvit
```

Depending on your luvit installation you might need to adjust those folders.

## Markdown Features Parsed

More or less according to specification...

- Anchors
- Blockquotes
- Codeblocks
- Emphasis (strong / em)
- Headers
- HTML
- Lists
- Paragraphs
- Rules
