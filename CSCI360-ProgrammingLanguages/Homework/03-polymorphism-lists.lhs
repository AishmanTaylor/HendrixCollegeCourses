Module 03: Polymorphism and Lists
=================================

* Record your team members here:

In this module we will complete our initial exploration of the Haskell
programming language.  For today, choose whoever you wish to start as
the driver.

Maybe
-----

```{.haskell}
data Maybe a where
  Nothing :: Maybe a
  Just    :: a -> Maybe a
```

Note that the above definition of `Maybe` does not have bird tracks in
front of it since it is already defined in the standard library; I
just wanted to show you its definition.

> w :: Maybe Int
> w = Just 3
>
> x :: Maybe String
> x = Just "hello"
>
> y :: Maybe Char
> y = Nothing
>
> z :: Maybe (Maybe Int)
> z = Just Nothing
>
> safeDiv :: Integer -> Integer -> Maybe Integer
> safeDiv _ 0 = Nothing
> safeDiv x y = Just (x `div` y)
>
> showDiv :: Integer -> Integer -> String
> showDiv x y = case safeDiv x y of
>   Nothing -> "Division by zero"
>   Just z  -> "Result is " ++ show z

* Give two example values of type `Maybe Bool`.

* How many distinct values of type `Maybe (Maybe Bool)` are there?
  List all of them.

* How is `safeDiv` different from `div`?

* Try `showDiv` on some examples.  Describe in words what it does.

* What does the `a` in the definition of `Maybe` represent?

* What Java feature does the `a` remind you of?

* Write a function `plusMaybe :: Maybe Integer -> Maybe Integer ->
  Maybe Integer` which performs addition if both arguments are `Just`,
  and returns `Nothing` otherwise.

![](../images/stop.gif) **(You know the drill)** You should be
prepared to share your version of `plusMaybe` with another group.

Lists
-----

**ROTATE ROLES**

> ints :: [Integer]
> ints = [3, 5, 92]
>
> noInts :: [Integer]
> noInts = []
>
> moreInts :: [Integer]
> moreInts = 7 : ints
>
> yetMoreInts :: [Integer]
> yetMoreInts = 4 : 2 : ints
>
> someInts :: [Integer]
> someInts = 8 : 42 : noInts
>
> ints2 :: [Integer]
> ints2 = 3 : 5 : 92 : []

* Evaluate `length ints` and `length noInts`.

* Explain what `[]` means.

* Evaluate `moreInts` and `length moreInts`.

* Do the same for `yetMoreInts`.

* Now evaluate `ints`.  Has it changed?

* Write an expression `e` such that `length e` evaluates to `6`.

* Explain what the `(:)` operator does.

* What will `someInts` evaluate to?  How about `length someInts`?
  Write down your guesses *before* typing them into GHCi.

* Now check your guesses.

* Evaluate `ints2`.  What do you notice?

![](../images/stop.gif)

Strings
-------

**ROTATE ROLES**

> greeting :: String
> greeting = "Hello"
>
> greeting2 :: String
> greeting2 = ['H','e','l','l','o']
>
> greeting3 :: [Char]
> greeting3 = ['H','e','l','l','o']
>
> everyone :: String
> everyone = "world"

* Evaluate `greeting`, `greeting2`, and `greeting3`.  What
  differences do you notice?  What can you conclude? (Hint: try typing
  `:info String` at the GHCi prompt.)

* Try evaluating `greeting : everyone`.  What happens?

* Now try evaluating `greeting ++ everyone`.  What happens?

* Explain the difference between `(:)` and `(++)`.

* What are the types of `(:)` and `(++)`?  Do they match your
  explanation above?

* Explain the difference between `'a'` and `"a"`.

* Write an expression using `greeting` and `everyone` which evaluates
  to `"Hello, world!"`.

![](../images/stop.gif)

List pattern matching
---------------------

**ROTATE ROLES**

> listLength []     = 0 :: Integer
> listLength (_:xs) = 1 + listLength xs
>
> startsWith :: String -> String -> Bool
> startsWith []     _      = undefined
> startsWith (_:_)  []     = undefined
> startsWith (x:xs) (y:ys) = undefined

* What is the type of `listLength`? (Feel free to ask GHCi.)

* The type of `listLength` probably has a lowercase letter in it, like
  `t` or `a`.  Explain what the type of `listLength` means.

* Evaluate `startsWith "cat" "catastrophe"`.  What happens?

* Complete the definition of `startsWith` by replacing `undefined`
  with appropriate expressions.  `startsWith` should test whether the
  second argument has the first argument as a prefix.  For example:

    ```
    startsWith "cat" "catastrophe" -> True
    startsWith "car" "catastrophe" -> False
    startsWith "ban" "banana"      -> True
    startsWith ""    "dog"         -> True
    startsWith "at"  "catastrophe" -> False
    startsWith "dog" ""            -> False
    ```

* Write a function `contains :: String -> String -> Bool`, which tests
  whether the second argument contains the first argument as a
  (contiguous) substring.  For example,

    ```
    contains "cat" "catastrophe" -> True
    contains "cat" "concatenate" -> True
    contains "cat" "create"      -> False
    contains "fly" "old lady"    -> False
    ```

    Hint: use `startsWith`.

* Write a function `listReverse :: [a] -> [a]` which reverses a list.
  For example,

    ```
    listReverse []      -> []
    listReverse [1,2,3] -> [3,2,1]
    listReverse "Hello" -> "olleH"
    ```

    **DO NOT** look at any existing implementation of reverse.

