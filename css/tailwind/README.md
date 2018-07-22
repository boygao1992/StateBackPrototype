# Padding

> Class name: `.p{side?}-{size}`

# Screen Size
break points between different screen sizes

> Class name: `.{screen}:{utility}`

``` javascript
  screens: { 
    // default: (0, 576)
    sm: '576px', // (576, 768)
    md: '768px', // (768, 992)
    lg: '992px', // (992, 1200)
    xl: '1200px', // (1200, +infinty)
    range: { min: '500px', max: '700px' }, // (500, 700)
    skip: [{ max: '700px' }, { min: '900px' }] // skip (700, 900)
  }
```

# State Variants

> Currently supported variants:
>   - responsive
>   - hover
>   - focus
>   - active
>   - group-hover

## group-hover
> By default, group hover variants are not generated for any utilities.
> You can customize this in the modules section of your configuration file.

hovering over any ancestor with `group` in its class name will trigger the decorated utility

