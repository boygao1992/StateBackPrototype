# text: 1D, total order

when we humans perceives a chunk of text, we don't memorize it word by word following the sequential ordering but need further transformation of this data into a "smaller" partial-order set.
e.g. Tree

so there is a distance between what's presented on screen and what's gonna be stored in mind

maybe, organize paragraph in trees?

# geometry/layout: 1D, 2D, 3D (higher-dimension space is out of the scope of visualization)

[Ordered vector space](https://en.wikipedia.org/wiki/Ordered_vector_space)
> `R^2` is an ordered vector space with the `≤` relation defined in any of the following ways
> - `(a,b) ≤ (c,d)` if and only if `(a < c and b < d)` or `(a = c and b = d)`: partial order

idea:
- a partial order description of visual component layout based on two relation (`onTheLeft`, `onTopOf`)
- project to pixel space representation (floating components) or DOM representation
