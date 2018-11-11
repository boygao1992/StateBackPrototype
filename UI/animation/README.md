`animation-timing-function`
- `linear`, constant speed
- `cubic-bezier-timing-function`
  - `ease-in`, from slow to fast
  - `ease-out`, from fast to slow
  - `ease-in-out`, start slow, accelerate to maximum speed and then slow down
  - `cubic-bezier(x,y,z,w) :: Number -> Number -> Number -> Number -> TimingFunc`
- `step-timing-function`
  - `step-start`
  - `step-end`
  - `steps(x, [ start | end ])`
- `frames-timing-function`
  - `frames(x) :: Int -> TimingFunc`
  
(2018.11) for performance reason, limit transition to the following types
- opacity
- scale
- translate
- rotate

### 1.[Animate.css](https://daneden.github.io/animate.css/)

> - Shake
> - Bounce
> - Fade
> - Slide
> - Flip
> - Rotate
> - Zoom

### 2.[Easing functions cheat sheet](https://easings.net/)

nice looking curves to visualize the speed (slope) over time
