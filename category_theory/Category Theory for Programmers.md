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

# Part One - 8. Functoriality
