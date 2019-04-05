Pandoc Lua filters
==================

Universal filters
-----------------

### [Filters](filters.lua)
### [Meta to header](meta2headers.lua)
### [Equal size of table columns](equalsizecolumns.lua)

ConTeXt filters
---------------

### [Bibliography](context/bibliography.lua)
Replace `pandoc-citeproc` by native MkIV bibliography.

### [Citations](context/citations.lua)

### [Comments](context/comments.lua)
Convert MS Word "Track Changes " comments to PDF comments.

<table><tr><td colspan=2>

```bash
pandoc --lua-filter context/comments.lua -t context
```
</td></tr><tr><td>

```markdown
Lorem ipsum dolor sit amet, [Comment text]{.comment-start id=1 author="Martin Hasoň"}consectetuer adipiscing elit[]{.comment-end id=1}.
```

</td><td>

```tex
Lorem ipsum dolor sit amet, \comment[author={Martin Hasoň}]{Comment text}consectetuer adipiscing elit.
```

</td></tr></table>

### [References](context/references.lua)

Creates an invisible, referencable anchor texts from span with id.

<table><tr><td colspan=2>

```bash
pandoc --lua-filter context/references.lua -t context
```
</td></tr><tr><td>

```markdown
The various [canal houses]{#houses} houses at the canal have nice interior.
```

</td><td>

```tex
The various \textreference[houses]{canal houses} houses at the canal have nice interior.
```

</td></tr></table>


### [Sections](context/sections.lua)
Use new MkIV commands for sections.

<table><tr><td colspan=2>

```bash
pandoc --lua-filter context/sections.lua -t context
```
</td></tr><tr><td>

```markdown
# Section
Text

## SubSection 1

### SubSubSection {-}
Text

## SubSection 2
Text
```

</td><td>

```tex
\startsection[title={Section}, reference={section}]
Text
\startsubsection[title={SubSection 1}, reference={subsection-1}]
\startsubsubsubject[title={SubSubSection}, reference={subsubsection}]
Text
\stopsubsubsubject
\stopsubsection
\startsubsection[title={SubSection 2}, reference={subsection-2}]
Text
\stopsubsection
\stopsection

```

</td></tr></table>

Usage
-----

```lua
package.path = package.path .. ";pandoc/?.lua"

local filters = require("filters")

filters.import("meta2header")
filters.import("context/bibliography")
filters.import("context/citations")
filters.import("context/sections")
filters.import("context/rawcontext")
filters.import("context/references")

return filters.all()

```
