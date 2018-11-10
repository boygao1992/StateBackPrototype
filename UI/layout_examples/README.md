# Model

margin | border | padding | content | padding | border | margin

margin collapse
- rationale: margin (space) doesn't interact with the outline of another margin but borders
- with `display: flex` or `display: grid`, child nodes seem no longer have margin collapse
because the partition lines serve as an additional set of boundaries in-between previously collapsing margins (space)

# Default

## Default Display
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
- `h1`, `h2`, `h3`, `h4`, `h5`, `h6`
- `nav`
- `section`
- `form`
- `figure`
- `figcaption`
- `iframe`
- `html`
- `header`
- `body`

## Default Margin and Padding

| tag      | default                             |
| -----:   | :---------------------------------- |
| `body`   | `margin: 8px`                       |
| `form`   | `margin-top: 0em`                   |
| `h1`     | `margin: 0.67em 0`                  |
| `h2`     | `margin: 0.83em 0`                  |
| `h3`     | `margin: 1em 0`                     |
| `h4`     | `margin: 1.33em 0`                  |
| `h5`     | `margin: 1.67em 0`                  |
| `h6`     | `margin: 2.33em 0`                  |
| `p`      | `margin: 1em 0`                     |
| `ul`     | `margin: 1em 0, padding-left: 40px` |
| `figure` | `margin: 1em 40px`                  |

## Default spacing between `inline-block` elements

> [Fighting the Space Between Inline Block Elements](https://css-tricks.com/fighting-the-space-between-inline-block-elements/)
> The reason you get the spaces is because you have spaces between the elements
> (a line break and a few tabs counts as a space, just to be clear). 

for adjacent images (`<img>`, `display: inline-block` by default), lift them to `display: block`

# Positioning
`inline-block`
- `position: static`, non-positioned
  - row-wise sequential (total) ordering over the 2d pixel space
  - row height is determined by the tallest element in the row
- `position: relative`, positioned relative to its static position
  - visual translation (`top`, `right`, `bottom`, `left`) will not affect its original static position
  - `static` neighbors still interact with its static position
  - forms new stacking context when
    - `z-index` is not `auto`
    - or `opacity` is `< 1.0`
- `position: absolute`, positioned relative its static position in its nearest positioned ancestor
  - no size
  - visual translation (`top`, `right`, `bottom`, `left`) will not affect its original static position
  - forms new stacking context when
    - `z-index` is not `auto`
    - or `opacity` is `< 1.0`
- `position: fixed`, positioned relative to the document
  - `transform` property in parent will cause fixed element to become relative to the parent instead of the document
  - forms new stacking context (after Chrome 22, Firefox 44)
- `position: sticky` (`relative` + `fixed`)
  - forms new stacking context
  
# Stacking Order
when an element creates a new stacking context, all its child elements live in that stacking context

`z-index` only rearrange the stacking order of elements within the same stacking context

### 1.[MDN - The stacking context](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Positioning/Understanding_z_index/The_stacking_context)

### 2.[What No One Told You About Z-Index](https://philipwalton.com/articles/what-no-one-told-you-about-z-index/)

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

- primarily partition the space by ratio
- space allocation of grid items are constrained by border attachment or span

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

- `flex-grow`: distribute available space to flex items by ratio
- `flex-shrink`: re-allocated space from flex items by ratio when content space overflow the flex container

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

### 4.[Institute for Architectural Anthropology](https://i-f-aa.com/)

### 5.[Beaubois](http://www.beaubois.com/)

### 6.[Libratone](https://www.libratone.com/us/)

### 7.[Women's Business Maker](http://www.wbm.miami/)

### 8.[evomedia](https://www.evomedia.lt/en)

### 9.[Otto van den Toorn](https://www.ottografie.nl/)

### 10.[Linden Staub](https://lindenstaub.com/)


# Reference

### 1. [material design](https://material.io/design/)

[Responsive layout grid](https://material.io/design/layout/responsive-layout-grid.html#columns-gutters-margins)

[Component behavior](https://material.io/design/layout/component-behavior.html#)

[image lists](https://material.io/design/components/image-lists.html)

### 2. [Grid by Example](https://gridbyexample.com/examples/)
