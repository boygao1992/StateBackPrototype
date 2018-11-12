# Size

## Absolute

- `px`, in pixels
- `pt`, in points (1`pt` = 1/72 of 1`in`)

## Relative

- `pct` (`%`), percentage relative to parent node
- font-size-related
  - `em`, with hierarchical compounding
    - `font-size` using `em`, relative to `font-size` of parent node.
    - other properties using `em`, relative to `font-size` of current node.
      - Using `em` on properties like `margin` and `padding` is good for text containers to maintain the text and space ratio.
    - not resilient to reorganization of DOM node hierarchy so the root node of a reusable component better use `rem` or absolute size, unless it's designed to be attachment of other components
  - `rem` (root `em`), always relative to `font-size` of `<html>`
- viewport-related
  - `vw`, percentage relative to viewport width
    - auto-adjust `font-size` for large titles in responsive layout
  - `vh`, percentage relative to viewport height
  - `vmin`, min(`vh`, `vw`)
  - `vmax`, max(`vh`, `vw`)

# List

`list-style`
- `list-style-type`
- `list-style-image`
- `list-style-position`
