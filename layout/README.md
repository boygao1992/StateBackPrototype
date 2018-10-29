# Default
inline
- `a`
- `button`
- `canvas`
- `code`
- `span`
- `strong`

inline-block
- `img`

block
- `div`
- `p`
- `ul`
- `ol`
- `nav`
- `section`
- `iframe`
- `html`
- `header`
- `body`

# Display

display-outside features
- size (control over properties related to `width` and `height`)
  - `inline` vs rest
- line-break
  - `inline*` vs rest

display-inside
- `flex` (`block` by default)
- `grid`
- `table`

inline-level (no line-break)
- `inline` (no size)
- `inline-block`
- `inline-flex` (from `block` to `inline-block`)
- `inline-grid`
- `inline-table`

block-level (with line-break)
- `block`
- `flex`
- `grid`
- `table`

> `p` cannot contain block-level elements.


# Float

- `left` (space on the right is available for inline-level elements)
- `right` (space on the left is available for inline-level elements)

> As float implies the use of the block layout, it modifies the computed value of the display values, in some cases:

push elements from inline-level to block-level (from `inline*` to `block`) if not already at

# CSS Multiple Columns

- `column-count` (~ `grid-template-columns: repeat(_, <column-width>)`)
- `column-width`
- `column-gap` (~ `grid-column-gap`)
- `column-rule` (~ `border` on grid items)
  - `column-rule-width`
  - `column-rule-style`
  - `column-rule-color`

# CSS Grid

column > row

grid system
- global
- local

grid layout
- `grid` (~ `grid-template` or `row / column`)
  - `grid-template`, explicit
    - `grid-template-rows`
    - `grid-template-columns`
    - `grid-template-area`, identified by unique names
  - implicit
    - `grid-auto-rows`
    - `grid-auto-columns`
    - `grid-auto-flow` (like `flex-direction`)
      - value: `row` or `column` or `row dense` or `column dense`

gap
- `grid-column-gap`
- `grid-row-gap`

grid constraints on item
- `grid-column`
  - `grid-column-start`, `x1`
  - `grid-column-end`, `x2`
    - default = `x1` + 1
- `grid-row`
  - `grid-row-start`, `y1`
  - `grid-row-end`, `y2`
    - default = `y1` + 1
- top-left corner: `(x1, y1)`
- bottom-right corner: `(x2, y2)`

`fr` - proportional distribution over the unfixed pixels
```css
.grid {
  width: 1100px;
  grid-template-column: 1fr 200px 2fr; /* = 300px 200px 600px */
}
```

# CSS Flexbox

# Examples

- [Awwwards](https://www.awwwards.com/)
- [CSS Design Awards](https://www.cssdesignawards.com/)

### 1.[Unlabel](https://unlabel.us/)

- default scrolling disabled
- vertical scrolling is entirely simulated by dynamic control over CSS transform, `translate3d(0, y, 0)`, in JS
, thus different elements can be assigned different scrolling speeds to distinguish foreground (slow) and background (fast)

### 2.[Susanne Kaufmann](https://www.susannekaufmann.com/en)

- responsive layout sorely by CSS `float: left`

### 3.[Erudito](https://erudi.to/)

# Reference

### 1. [material design](https://material.io/design/)

[Responsive layout grid](https://material.io/design/layout/responsive-layout-grid.html#columns-gutters-margins)

[Component behavior](https://material.io/design/layout/component-behavior.html#)

[image lists](https://material.io/design/components/image-lists.html)

### 2. [Grid by Example](https://gridbyexample.com/examples/)
