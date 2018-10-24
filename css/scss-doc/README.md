# 4. CSS Extensions

## 1. Nested Rules

### Example 1
```scss
#main p {
  color: #00ff00;
  width: 97%;
  
  .redbox {
    background-color: #ff0000;
    color: #000000;
  }
}
```

```purescript
-- | IDs.purs

main :: String
main = "main"

-- | ClassNames.purs

redbox :: String
redbox = "redbox"

-- | Colors.purs

lime :: Color
lime = CSS.safeFromHexString "#00ff00"

red :: Color
red = CSS.safeFromHexString "#ff0000"

black :: Color
black = CSS.safeFromHexString "#000000"

-- | Styles.purs

nestedRules1 :: CSS
nestedRules1 =
  (CSS.id_ ID.main |* CSS.p) ? do
    CSS.color Colors.lime
    CSS.width (CSS.pct 97.0)

    (CSS.class_ CN.redbox) ? do
      CSS.backgroundColor Colors.red
      CSS.color Colors.black
```

### Example 2
```scss
#main {
  width: 97%;

  p, div {
    font-size: 2em;
    a { font-weight: bold; }
  }

  pre { font-size: 3em; }
}
```

```purescript
nestedRules2 :: CSS
nestedRules2 =
  (CSS.id_ ID.main) ? do
    CSS.width (CSS.pct 97.0)

  (CSS.p ++ CSS.div) ? do
    CSS.fontSize (CSS.em 2.0)
    CSS.a ? do
      CSS.fontWeight CSS.bold

  CSS.pre ? do
    CSS.fontSize (CSS.em 3.0)
```

## 2. Referencing Parent Selectors: &

### Example 1

- SCSS

```scss
a {
  font-weight: bold;
  text-decoration: none;
  &:hover { text-decoration: underline; }
  body.firefox & { font-weight: normal; }
}
```

- purescript-css

```purescript
-- a function that substitutes variable `selector` (`&` in SCSS) with a Selector
-- no magic. all by native abstractions
linkStyle :: Selector -> CSS
linkStyle selector = do
  CSS.fontWeight CSS.bold
  CSS.textDecoration CSS.noneTextDecoration

  (selector & CSS.hover) ? do
    CSS.textDecoration CSS.underline

  (CSS.body & CSS.byClass CN.firefox |* selector) ? do
    CSS.fontWeight CSS.normal

refParentSelectors1 :: CSS
refParentSelectors1 = linkStyle CSS.a -- CSS.a :: Selector, represents HTML a tag
```

Output:

- SCSS

```css
a {
  font-weight: bold;
  text-decoration: none; }
  a:hover {
    text-decoration: underline; }
  body.firefox a {
    font-weight: normal; }
```

- purescript-css

```css
a {
  font-weight: bold;
  text-decoration: none
}

a:hover {
  text-decoration: underline
}

body.firefox a {
  font-weight: normal
}
```



### Example 2

```scss
#main {
  color: black;
  a {
    font-weight: bold;
    &:hover { color: red; }
  }
}
```

```purescript
linkStyle :: Selector -> CSS
linkStyle selector = do
  selector ? do
    CSS.fontWeight CSS.bold

  (selector & CSS.hover) ? do
    CSS.color Colors.red

refParentSelectors2 :: CSS
refParentSelectors2 = do
  (CSS.id_ IDs.main) ? do
    CSS.color Colors.black
    linkStyle CSS.a
```

Output:

- SCSS

```css
#main {
  color: black; }
  #main a {
    font-weight: bold; }
    #main a:hover {
      color: red; }
```

- purescript-css

```css
#main {
  color: hsl(0.0, 0.0%, 0.0%)
}

#main a {
  font-weight: bold
}

#main a:hover {
  color: hsl(4.11, 89.62%, 58.43%)
}
```



### Example 3

```scss
#main {
  color: black;
  &-sidebar { border: 1px solid; }
}
```

```purescript
-- | Colors.purs

transparent :: Color
transparent = rgba 255 255 255 0.0

-- | Styles.purs

suffixStyle :: String -> CSS
suffixStyle id = do
  (CSS.id_ id) ? do
    CSS.color Colors.black

  (CSS.id_ (id <> "-sidebar")) ? do -- TODO: add Monoid instance for Selector
    CSS.border CSS.solid (CSS.px 1.0) Colors.transparent

refParentSelectors3 :: CSS
refParentSelectors3 = suffixStyle IDs.main
```

Output

- SCSS

```css
#main {
  color: black; }
  #main-sidebar {
    border: 1px solid; }
```

- purescript-css

```css
#main {
  color: hsl(0.0, 0.0%, 0.0%)
}

#main-sidebar {
  border: solid 1.0px hsla(0.0, 0.0%, 100.0%, 0.0)
}
```



## 3. Nested Properties

```scss
.funky {
  font: {
    family: fantasy;
    size: 30em;
    weight: bold;
  }
}
```

```purescript
-- | CSSFonts.purs

fantasy :: GenericFontFamily
fantasy = GenericFontFamily $ fromString "fantasy"

-- | Styles.purs

nestedProperties :: CSS
nestedProperties =
  (CSS.id_ "funky") ? do
    CSS.fontFamily [] (NonEmpty.singleton CSS.fantasy)
    CSS.fontSize (CSS.em 30.0)
    CSS.fontWeight CSS.bold
```

## 7. @-Rules and Directives

### 1. @import

```scss
// _colors.scss
$colors-red = "#D64078"

// _styles.scss
@import "colors"
a {
  color: $colors-red;
}
```

```purescript
-- | Colors.purs
red :: Color
red = CSS.safeFromHexString "#D64078"

-- | Syltes.purs
import Colors as Colors

link_normal :: CSS
link_normal =
  CSS.a ? do
    CSS.color Colors.red
```

### 3. @extend
```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.error.intrusion {
  background-image: url("/image/hacked.png");
}
.seriousError {
  @extend .error;
  border-width: 3px;
}
```

```purescript
-- | Urls.purs
hacked :: String
hacked = "/image/hacked.png"

-- | ClassNames.purs
intrusion :: String
intrusion = "intrusion"

error :: String
error = "error"

seriousError :: String
seriousError = "seriousError"

-- | Styles.purs
errorStyle :: CSS
errorStyle = do
  CSS.border CSS.solid (CSS.px 1.0) Colors.red
  CSS.backgroundColor Colors.pink

  (CSS.class_ CN.intrusion) ? do
    CSS.backgroundImage (CSS.url Urls.hacked)

error :: CSS
error =
  (CSS.class_ CN.error) ? errorStyle

seriousError :: CSS
seriousError =
  (CSS.class_ CN.seriousError) ? do
    errorStyle
    CSS.borderWidth (CSS.px 3.0)
```

Output:
- SCSS
```css
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd; }

.error.intrusion, .seriousError.intrusion {
  background-image: url("/image/hacked.png"); }

.seriousError {
  border-width: 3px; }
```

- purescript-css
```css
.error {
  border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
  background-color: hsl(0.0, 100.0%, 93.33%)
}

.error .intrusion {
  background-image: url("/image/hacked.png")
}

.seriousError {
    border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
    background-color: hsl(0.0, 100.0%, 93.33%); border-width: 3.0px
}

.seriousError .intrusion {
  background-image: url("/image/hacked.png")
}
```

### 3.2 Multiple Extends
```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.attention {
  font-size: 3em;
  background-color: #ff0;
}
.seriousError {
  @extend .error;
  @extend .attention;
  border-width: 3px;
}
```

```purescript
errorStyle :: CSS
errorStyle = do
  CSS.border CSS.solid (CSS.px 1.0) Colors.red
  CSS.backgroundColor Colors.pink

attentionStyle :: CSS
attentionStyle = do
  CSS.fontSize (CSS.em 3.0)
  CSS.backgroundColor Colors.red

error :: CSS
error =
  (CSS.class_ CN.error) ? errorStyle

attention :: CSS
attention =
  (CSS.class_ CN.attention) ? attentionStyle

seriousError :: CSS
seriousError =
  (CSS.class_ CN.seriousError) ? do
    errorStyle
    attentionStyle
    CSS.borderWidth (CSS.px 3.0)
```

Output:
- SCSS
```css
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd; }

.attention, .seriousError {
  font-size: 3em;
  background-color: #ff0; }

.seriousError {
  border-width: 3px; }
```

- purescript-css
```css
.error {
  border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
  background-color: hsl(0.0, 100.0%, 93.33%)
}
.attention {
  font-size: 3.0em;
  background-color: hsl(0.0, 100.0%, 50.0%)
}
.seriousError {
  border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
  background-color: hsl(0.0, 100.0%, 93.33%);
  font-size: 3.0em;
  background-color: hsl(0.0, 100.0%, 50.0%);
  border-width: 3.0px
}
```

### 3.3 Chaining Extends

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  @extend .error;
  border-width: 3px;
}
.criticalError {
  @extend .seriousError;
  position: fixed;
  top: 10%;
  bottom: 10%;
  left: 10%;
  right: 10%;
}
```

```purescript
errorStyle :: CSS
errorStyle = do
  CSS.border CSS.solid (CSS.px 1.0) Colors.red
  CSS.backgroundColor Colors.pink

seriousErrorStyle :: CSS
seriousErrorStyle = do
  errorStyle
  CSS.borderWidth (CSS.px 3.0)

error :: CSS
error =
  (CSS.class_ CN.error) ? errorStyle

seriousError :: CSS
seriousError =
  (CSS.class_ CN.seriousError) ? seriousErrorStyle

criticalError :: CSS
criticalError =
  (CSS.class_ CN.criticalError) ? do
    seriousErrorStyle
    CSS.position CSS.fixed
    CSS.top (CSS.pct 10.0)
    CSS.bottom (CSS.pct 10.0)
    CSS.left (CSS.pct 10.0)
    CSS.right (CSS.pct 10.0)
```

Output:
- SCSS
```css
.error, .seriousError, .criticalError {
  border: 1px #f00;
  background-color: #fdd; }

.seriousError, .criticalError {
  border-width: 3px; }

.criticalError {
  position: fixed;
  top: 10%;
  bottom: 10%;
  left: 10%;
  right: 10%; }
```

- purescript-css
```css
.error {
  border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
  background-color: hsl(0.0, 100.0%, 93.33%)
}

.seriousError {
  border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
  background-color: hsl(0.0, 100.0%, 93.33%);
  border-width: 3.0px 
}

.criticalError {
  border: solid 1.0px hsl(0.0, 100.0%, 50.0%) ;
  background-color: hsl(0.0, 100.0%, 93.33%);
  border-width: 3.0px;
  position: fixed;
  top: 10.0%;
  bottom: 10.0%;
  left: 10.0%;
  right: 10.0%
}
```

### 3.4 Selector Sequences

```scss
#fake-links .link {
  @extend a;
}

a {
  color: blue;
  &:hover {
    text-decoration: underline;
  }
}
```

```purescript
linkStyle :: Selector -> CSS
linkStyle sel = do
  sel ? do
    CSS.color Colors.blue
  (sel & CSS.hover) ? do
    CSS.textDecoration CSS.underline

hyperLink :: CSS
hyperLink = linkStyle CSS.a

fakeLinks :: CSS
fakeLinks = linkStyle (CSS.id_ IDs.fakeLinks |* CSS.class_ CN.link)
```

Output:
- SCSS
```css
a, #fake-links .link {
  color: blue; }
  a:hover, #fake-links .link:hover {
    text-decoration: underline; }
```

- purscript-css
```css
a {
  color: hsl(206.57, 89.74%, 54.12%)
}

a:hover {
  text-decoration: underline
}

#fake-links .link {
  color: hsl(206.57, 89.74%, 54.12%)
}

#fake-links .link:hover {
  text-decoration: underline
}
```

# 6. SassScript

Purescript itself is a strict-type Turing-complete language.
