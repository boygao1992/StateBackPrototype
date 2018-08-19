Object-oriented: Vertex graph, directional edges (functions connecting two data-types) are second-class citizen that live inside vertices (data-types)

Function-oriented / Functional: Edge graph, but usually both data-types and functions are first-class citizen in FP languages, anonymous functions and data-types are allowed as well.

purpose anonymous functions and data / objects:
ontology / taxonomy that group similar constructs together into a class / named data-type (with data constructor function) is for reuse purpose.
Roughly, if an object is never used more than 3 times in a code base, then it doesn't worth to be generalized into a class.

# Inferface, Type class vs. Discriminated/Tagged Union

Inferface: open world assumption

union: closed world assumption

```typescript
interface Shape {}

inferface Square implements Shape {
    size : number
}

inferface Rectangle implements Shape {
    width: number
    height: number
}
```

```elm
type Shape
  = Square { size: Float }
  | Rectangle { width: Float, height: Float }
```

```purescript
class Shape s where
  
```

