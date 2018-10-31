# Page Loading Speed

## Tool

### 1. [jasonslyvia/react-lazyload](https://github.com/jasonslyvia/react-lazyload)

## Reference

### 1. [PageSpeed Insights Rules - Google](https://developers.google.com/speed/docs/insights/rules)

> **Avoid landing page redirects**
>
> Redirects trigger an additional HTTP request-response cycle and delay page rendering.
>
> In the best case, each redirect will add a single roundtrip (HTTP request-response)
>
> In the worst it may result in
>
> - multiple additional roundtrips to perform the DNS lookup
> - TCP handshake
> - TLS negotiation in addition to the additional HTTP request-response cycle



> **Enable compression**
>
> - All modern browsers support and automatically negotiate `gzip` compression for all HTTP requests.

[Node Zlib](https://nodejs.org/api/zlib.html)

> **Improve server response time**
>
> reduce your server response time under 200ms
>
> - potential factors
>   - application logic
>   - database queries
>   - routing
>   - frameworks, libraries
>   - resource CPU or memory starvation
> - measures
>   - Gather and inspect existing performance and data
>   - Identify and fix top performance bottlenecks.
>   - Monitor and alert for any future performance regressions



> **Leverage browser caching**
>
> ?



> **Minify resources**
>
> use of minifiers
>
> - HTML
>   - [HTML Minifier](https://github.com/kangax/html-minifier)
> - CSS
>   - [CSSNano](https://github.com/ben-eb/cssnano)
>   - [csso](https://github.com/css/csso)
> - JS
>   - [UglifyJS](https://github.com/mishoo/UglifyJS2)
>   - [Closure Compiler](https://developers.google.com/closure/compiler)
>   - [babel-minify](https://github.com/babel/minify)

[webpack - Plugins](https://webpack.js.org/plugins/)

- [`BabelMinifyWebpackPlugin`](https://webpack.js.org/plugins/babel-minify-webpack-plugin)
- [`CompressionWebpackPlugin`](https://webpack.js.org/plugins/compression-webpack-plugin)
- [`MiniCssExtractPlugin`](https://webpack.js.org/plugins/mini-css-extract-plugin)
- [`UglifyjsWebpackPlugin`](https://webpack.js.org/plugins/uglifyjs-webpack-plugin)
- [`ZopfliWebpackPlugin`](https://webpack.js.org/plugins/zopfli-webpack-plugin)

> **Optimize images**
>
> dimensions
>
> - type of data  being encoded
> - image format capabilities
> - quality settings
> - resolution
>
> In addition, you need to consider
>
> - whether some images are best served in a vector format
> - if the desired effects can be achieved via  CSS
> - how to deliver appropriately scaled assets for each type of device.
>
> `GIF` and `PNG`
>
> - Always convert `GIF` to `PNG` unless the original is animated or tiny (less than a few hundred bytes).
> - For both `GIF` and `PNG`, remove alpha channel if all of the pixels are opaque. 
>
> `JPG`
>
> - Reduce quality to 85 if it was higher.
> - Reduce Chroma sampling to 4:2:0, because human visual system is less sensitive to colors as compared to luminance.
> - Use progressive format for images over 10k bytes.
> - Use grayscale color space if the image is black and white.
>
> ImageMagick
>
>  `convert INPUT.jpg -sampling-factor 4:2:0 -strip [-resize WxH][-quality N] [-interlace JPEG][-colorspace Gray/sRGB] OUTPUT.jpg`
>
> e.g. `convert puzzle.jpg -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB puzzle_converted.jpg`



> - [Optimize CSS Delivery](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery)
> - [Prioritize visible content](https://developers.google.com/speed/docs/insights/PrioritizeVisibleContent)
> - [Remove render-blocking JavaScript](https://developers.google.com/speed/docs/insights/BlockingJS)


### 2.[Web Performance 101](https://3perf.com/talks/web-perf-101/)

### 3.[Case study: analyzing the Walmart site performance](https://iamakulov.com/notes/walmart/)
