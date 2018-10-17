[Learn CSS Layout](http://learnlayout.com/)

[purescript-css | A type-safe library for describing, manipulating, and rendering CSS.](https://pursuit.purescript.org/packages/purescript-css/)

a type-safe and modular way to compose inline CSS using purescript-css

`./dist/index.html`

# Concept Mapping

## Selector

`purescript-css/src/CSS/Selector.purs`

- latest documentation version: `3.4.0`
- current package version: `4.0.0`
- the API is incomplete in current version, missing a lot of constructors, check out [`master` branch](https://github.com/slamdata/purescript-css/blob/master/src/CSS/Selector.purs)

```haskell
-- | see also purescript-css/src/CSS/Render.purs/predicate (line 177)
data Predicate
  = Id String -- #id
  | Class String -- .class
  | Attr String -- [attribute]
  | AttrVal String String -- [attribute='value']
  | AttrBegins String String -- [attribute^='val']
  | AttrEnds String String -- [attribute$='val']
  | AttrContains String String -- [attribute*='val']
  | AttrSpace String String -- [attribute~='val1 val2']
  | AttrHyph String String -- [attribute|='val1-val2']
  | Pseudo String -- :pseudo-class, ':hover'
  | PseudoFunc String (Array String) -- :pseudo-function(arguments), currently no instance built around this abstraction yet

-- | see also purescript-css/src/CSS/Render.purs/selector'' (line 144)
data Path f
  = Star -- *
  | Elem String -- A
  | PathChild f f -- A > B
  | Deep f f -- A B (space in-between)
  | Adjacent f f -- A + B
  | Combined f f -- AB (no space in-between), e.g. A.classB, 'p.small'
```


# Organization

- Colors : `src/Colors.purs`
- Styles : `src/Styles.purs`
- CSS : `src/CSSModule.purs`
completed missing API (constructors for id selector and class selector)
