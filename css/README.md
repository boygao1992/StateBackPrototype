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
- `position: absolute`, positioned relative to its nearest positioned ancestor
  - no static position
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

# Organization

`Literals/`
- `ClassNames.purs`
- `IDs.purs`
- `Urls.purs`

`CSS/`
- `Colors.purs`
- `Styles.purs` -- global styles and reusable style functions
- `Position.purs` -- reusable positioning functions
- `Selectors.purs`
- `CSSRoot.purs`
- `CSS<module_name>.purs`

# Markup

> [`:root`](https://developer.mozilla.org/en-US/docs/Web/CSS/:root)
> matches the root element of a tree representing the document. In HTML, :root represents the <html> element and is identical to the selector html, except that its specificity is higher.

# Reference

### 1. [Learn CSS Layout](http://learnlayout.com/)

