# Part One - 2. Types and Functions

## Who Needs Types?
## Types Are About Composability

> It seems that, in the commercial setting, the pressure to fix bugs is applied only up to a certain quality level, which has everything to do with *the economics of software development* and *the tolerance of the end user*, and **very little to do with the programming language or methodology**.
> A better criterion would be to measure how many projects fall behind schedule or are delivered with drastically reduced functionality.

> Unit testing may catch some of the mismatches, but testing is almost always a probabilistic rather than a deterministic process.
> Testing is a poor substitute for proof.

## What Are Types?

> Set is a very special category, because we can actually peek inside its objects and get a lot of intuitions from doing that.
> - empty set
> - one-element set
> - function
>   - maps each element of a set to elements of another set
>   - can map two elements to one, but not one element to two
> - identity function: maps each element of a set to itself

> In the ideal world we would just say that Haskell types are sets 
> and Haskell functions are mathematical functions between sets.

> there are some calculations that involve recursion, and those might never terminate.
> distinguishing between terminating and non-terminating functions is undecidable — the famous halting problem
> solution: to extend every type by one more special value called the **bottom** and denoted by `_|_`, or Unicode `⊥`
> corresponds to a **non-terminating** computation.
> once you accept the bottom as part of the type system, it is convenient to treat every **runtime error** as a bottom, and even allow functions to return the bottom explicitly (using the expression `undefined`)
> Functions that may return bottom are called **partial**, as opposed to **total** functions, which return valid results for every possible argument.
> Because of the bottom, you’ll see the category of Haskell types and functions referred to as **Hask** rather than Set.

## Why Do We Need a Mathematical Model?

operational semantics

> The semantics of industrial languages, such as C++, is usually described using **informal operational reasoning**, often in terms of an “abstract machine.”
> The problem is that it’s very **hard to prove** things about programs using **operational semantics**.
> To show a property of a program you essentially have to “run it” through the idealized interpreter.

> We think that the code we write will perform certain actions that will produce desired results.
> That means we do reason about programs we write, and we usually do it by running an interpreter in our heads.
> It’s just really hard to keep track of all the variables.
> Computers are good at running programs — humans are not! If we were, we wouldn’t need computers.

denotational semantics

> But there is an alternative. It’s called **denotational semantics** and it’s based on math.
> In denotational semantics every programing construct is given its **mathematical interpretation**.
> With that, if you want to **prove a property of a program**, you just prove a mathematical theorem.
> - the fact is that we humans have been building up mathematical methods for thousands of years, so there is a wealth of accumulated knowledge to tap into.
> - as compared to the kind of theorems that professional mathematicians prove, **the problems that we encounter in programming are usually quite simple**, if not trivial.

> It seemed like denotational semantics wasn’t the best fit for a considerable number of important tasks that were essential for writing useful programs, and which could be easily tackled by operational semantics.
> The breakthrough came from **category theory**.
> **Eugenio Moggi** discovered that **computational effect** can be mapped to **monads**.

> One of the important advantages of having a mathematical model for programming is that it’s possible to perform **formal proofs of correctness of software**.
> This might not seem so important when you’re writing consumer software, but there are areas of programming **where the price of failure may be exorbitant**, or where human life is at stake.


## Pure and Dirty Functions
## Examples of Types


# Part One - 3. Categories Great and Small 

## No Objects

## Simple Graphs

## Orders

## Monoid as Set

## Monoid as Category

> the second interpretation of the type signature of `mappend` as `m->(m->m)`.
> `mappend` maps an element of a monoid set to a function acting on that set.

> Every monoid can be described as a single object category with a set of morphisms that follow appropriate rules of composition.

addition and multiplication of integers are commutative

- addition commutes for any `Semiring`
- multiplication commutes only for a `CommutativeRing` (=> `Ring` => `Semiring`)

`Int` is an instance of `CommutativeRing` type class


> String concatenation is an interesting case, because we have a choice of defining right appenders and left appenders (or prependers, if you will).
> The composition tables of the two models are a mirror reverse of each other.

concatenation of `String` is not commutative

e.g. `"Foo" ++ "Bar" = "FooBar"`, `"Bar" ++ "Foo" = "BarFoo"`

the same for multiplication of `Matrix` (or more generally `Tensor`)

> every categorical monoid — a one-object category — defines a unique set-with-binary-operator monoid.
> the set of morphisms — the hom-set M(m, m) of the single object m in the category M.
> We can easily define a binary operator in this set: 
> The monoidal product of two set-elements (`f`, `g`) is the element corresponding to the composition (`g ∘ f`) of the corresponding morphisms.

e.g. `f = (+1)`, `g = (+2)`, `g ∘ f = (+2).(+1) = (+3)`

> The composition always exists, because the source and the target for these morphisms are the same object.
> And it’s associative by the rules of category.
> The identity morphism is the neutral element of this product.

e.g. `(+0)`

> So we can always recover a set monoid from a category monoid.


> There is just one little nit for mathematicians to pick: **morphisms don’t have to form a set**. 
> In the world of categories there are things larger than sets. 
> A category in which morphisms between any two objects form a set is called **locally small**.

# Part One - 4. Kleisli Categories

## Composition of Logs

## The Writer Category

## Writer in Haskell

## Kleisli Categories

> It's an example of the so called Kleisli category — a category based on a monad.
> For our limited purposes, a Kleisli category has
> - objects: the types of the underlying programming language
> - morphisms: from type A to type B are functions that go from A to a type derived from B using the particular embellishment

`speechCollection > Programming > 11. A Categorical View of Computational Effects`:
a T-program from type `A` to type `B`: `A -> T(B)`,
 where `T(B)` is a T-computation of type `B`
 
> The particular monad that I used as the basis of the category in this post is called the *writer monad* and it’s used for logging or tracing the execution of functions. 

> Here we have extended this model to a category where morphisms are represented by embellished functions,
> and their composition does more than just pass the output of one function to the input of another.
> We have one more degree of freedom to play with: the composition itself.

before passing the output to another function, some additional logic needs to be handled

# Part one - 5. Products and Coproducts 

## Follow the Arrows

>The Ancient Greek playwright Euripides once said: “Every man is like the company he is wont to keep.”
> We are defined by our relationships.
> Nowhere is this more true than in category theory.

> If we want to single out a particular object in a category, we can only do this by describing its pattern of relationships with other objects (and itself).
> These relationships are defined by morphisms.

> There is a common construction in category theory called the **universal construction** for defining objects in terms of their relationships.
> One way of doing this is to pick a **pattern**, a particular shape constructed from objects and morphisms, and look for all its occurrences in the category.
> If it’s a common enough pattern, and the category is large, chances are you’ll have lots and lots of hits.
> The trick is to establish some kind of **ranking** among those hits, and pick what could be considered **the best fit**.

## Initial Object

> pattern: a single object
> ranking: object a is “more initial” than object b if there is an arrow (a morphism) going from a to b

> Obviously there is no guarantee that such an object exists, and that’s okay.
> A bigger problem is that there may be too many such objects

> The solution is to take a hint from ordered categories — they allow at most one arrow between any two objects:
> there is only one way of being less-than or equal-to another object.

> The **initial object** is the object that has one and only one morphism going to any object in the category.

> However, even that doesn’t guarantee the uniqueness of the initial object (if one exists).
> But it guarantees the next best thing: **uniqueness up to isomorphism**.

> The initial object in a partially ordered set (often called a poset) is its least element.
> Some posets don’t have an initial object — like the set of all integers, positive and negative, with less-than-or-equal relation for morphisms.

> In the category of sets and functions, the initial object is the empty set. 
> an empty set corresponds to the Haskell type `Void` (there is no corresponding type in C++)
> the unique polymorphic function from `Void` to any other type:
> ```haskell
> absurd :: Void -> a
> ```

no function definition because it cannot be evaluated, or so called uncallable.

## Terminal Object

> pattern: a single object
> ranking: object a is “more terminal” than object b if there is an arrow (a morphism) going from b to a

> The **terminal object** is the object with one and only one morphism coming to it from any object in the category.

> In a poset, the terminal object, if it exists, is the biggest object.

> In the category of sets, the terminal object is a singleton.
> they correspond to the `void` type in C++ and the unit type `()` in Haskell.
> there is one and only one pure function from any type to the unit type:
> ```haskell
> unit :: a -> ()
> unit _ = ()
> ```

> Notice that in this example **the uniqueness condition is crucial**,
> because there are other sets (actually, all of them, except for the empty set) that have incoming morphisms from every set.

> Boolean (`Bool`)
> a Boolean-valued polymorphic function:
> ```haskell
> yes :: a -> Bool
> yes _ = True
> ```
> But `Bool` is not a terminal object.
> There is at least one more `Bool`-valued function from every type:
```
no :: a -> Bool
no _ = False
```

## Duality

> notice the symmetry between the way we defined the initial object and the terminal object.
> The only difference between the two was the direction of morphisms.

> for any category C we can define the opposite category C^{op} just by reversing all the arrows.
> The opposite category automatically satisfies all the requirements of a category, as long as we simultaneously redefine composition:
> - C: `f :: a -> b`, `g :: b -> c`, `h = g ∘ f` then `h :: a -> c`
> - C^op: `f^op :: b -> a`, `g :: c -> b`, `h^op = f^op ∘ g^op` then `h^op = c -> a`

- the initial object in C is the terminal object in C^op
- the terminal object in C is the initial object in C^op

> **Duality is a very important property of categories** because it doubles the productivity of every mathematician working in category theory.
> For **every construction** you come up with, **there is its opposite**; and for every theorem you prove, you get one for free.

## Isomorphisms

> You’d think that mathematicians would have figured out the meaning of equality, but they haven’t.
> They have the same problem of multiple competing definitions for equality:
> - propositional equality
> - intensional equality
> - extensional equality
> - equality as a path in homotopy type theory
> And then there are the weaker notions of isomorphism, and even weaker of equivalence.

> An isomorphism is an invertible morphism; or a pair of morphisms, one being the inverse of the other.

> We understand the inverse in terms of composition and identity:
> Morphism `g` is the inverse of morphism `f` if their composition is the identity morphism.

```
f :: a -> b
g :: b -> a

f . g :: a -> a
f . g = id_a

g . f :: b -> b
g . f = id_b
```
> When I said that the initial (terminal) object was unique up to isomorphism, I meant that any two initial (terminal) objects are **isomorphic**.
> proof:
> The composition `g∘f` must be a morphism from `a` to `a`.
> But `a` is initial so there can only be one morphism going from `a` to `a`.
> Since we are in a category, we know that there is an `identity` morphism from `a` to `a`, and since there is room for only one, that must be it.
> Therefore `g∘f` is equal to `identity`. 

> in this proof we used the uniqueness of the morphism from the initial object to itself.
> Without that we couldn’t prove the “up to isomorphism” part.
> Because not only is the initial object unique up to isomorphism, it is unique up to unique isomorphism.
> In principle, there could be more than one isomorphism between two objects, but that’s not the case here.

> This “**uniqueness up to unique isomorphism**” is the important property of **all universal constructions**.

## Product

> given any type `c` with two projections `p` and `q`, there is a unique `m` from `c` to the cartesian product `(a, b)` that factorizes them.
> In fact, it just combines `p` and `q` into a pair.
```haskell
p :: c -> a
q :: c -> b

m :: c -> (a, b)
m x = (p x, q x)
```

> A **product** of two objects `a` and `b` is the object `c` equipped with two projections such that for any other object `c`’ equipped with two projections there is a unique morphism `m` from `c`’ to `c` that factorizes those projections.

> A (higher order) function that produces the factorizing function `m` from two candidates is sometimes called the factorizer.
> In our case, it would be the function:
```haskell
factorizer :: (c -> a) -> (c -> b) -> (c -> (a, b))
factorizer p q = \x -> (p x, q x)
```

## CoProduct

# Part One - 8. Functoriality
