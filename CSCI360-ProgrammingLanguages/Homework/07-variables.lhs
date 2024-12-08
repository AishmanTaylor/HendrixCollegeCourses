Module 07: Variables
====================

* Write your team names here:

In this module, we will explore how to support a language with
*variables*.

We'll start with the familiar Arith language.

> {-# LANGUAGE GADTSyntax #-}
>
> import Prelude hiding ((<$>), (<$), (<*>), (<*), (*>))
> import Parsing
>
> data Arith where
>   Lit :: Integer -> Arith
>   Bin :: Op -> Arith -> Arith -> Arith
>   deriving (Show)
>
> data Op where
>   Plus  :: Op
>   Minus :: Op
>   Times :: Op
>   deriving (Show, Eq)
>
> interpArith :: Arith -> Integer
> interpArith (Lit i)           = i
> interpArith (Bin Plus e1 e2)  = interpArith e1 + interpArith e2
> interpArith (Bin Minus e1 e2) = interpArith e1 - interpArith e2
> interpArith (Bin Times e1 e2) = interpArith e1 * interpArith e2
>
> lexer :: TokenParser u
> lexer = makeTokenParser $ emptyDef
>   { reservedNames = ["let", "in"] }
>     -- tell the lexer that "let" and "in" are reserved keywords
>     -- which may not be used as variable names
>
> parens :: Parser a -> Parser a
> parens     = getParens lexer
>
> reservedOp :: String -> Parser ()
> reservedOp = getReservedOp lexer
>
> reserved :: String -> Parser ()
> reserved = getReserved lexer
>
> integer :: Parser Integer
> integer    = getInteger lexer
>
> whiteSpace :: Parser ()
> whiteSpace = getWhiteSpace lexer
>
> identifier :: Parser String
> identifier = getIdentifier lexer
>
> parseArithAtom :: Parser Arith
> parseArithAtom = (Lit <$> integer) <|> parens parseArith
>
> parseArith :: Parser Arith
> parseArith = buildExpressionParser table parseArithAtom
>   where
>     table = [ [ Infix (Bin Times <$ reservedOp "*") AssocLeft ]
>             , [ Infix (Bin Plus  <$ reservedOp "+") AssocLeft
>               , Infix (Bin Minus <$ reservedOp "-") AssocLeft
>               ]
>             ]
>
> arith :: Parser Arith
> arith = whiteSpace *> parseArith <* eof
>
> eval :: String -> Maybe Integer
> eval s = case parse arith s of
>   Left _  -> Nothing
>   Right e -> Just (interpArith e)

We will now add *variables* to this language.  In particular, we're
going to add *let-expressions*, which look something like this:

```
 >>> let x = 4*12 in x*x + 3-x
 2259
```
This locally defines `x` as a name for the value of `4*12` within the
expression `x*x + 3-x`.  Substituting `48` for each occurrence of `x`
and evaluating the result yields the final value of `2259`.

Haskell has let-expressions too, so you can try typing the above
expression at a GHCi prompt.

Syntax
------

* Choose a driver and write their name here:

We need to make two changes to the syntax of the language.

- Arith expressions may now contain variables, represented as
  `String`s.

- Arith expressions may now contain let-expressions, which have the
   concrete syntax
    ```
    'let' <var> '=' <arith> 'in' <arith>
    ```

  where `<var>` is a variable name (a `String`) and the two
  occurrences of `<arith>` are Arith expressions.


* Add two new constructors to the definition of the `Arith` data type
  to represent these two new syntactic forms.  (Of course, since
  `Arith` represents *abstract* syntax, you do not need to worry
  about storing specific pieces of concrete syntax such as the words
  `let` or `in`; for a `let` expression you need only store the
  variable name and two `Arith` expressions.)

* Modify the parser to parse the given concrete syntax.  A few hints:

    - You can use the provided `identifier :: Parser String` to parse
      a variable name.
    - You can use the provided `reserved :: String -> Parser ()` to
      parse the keywords `let` and `in`.  Notice how these keywords
      are specified as "reserved names" in the lexer, which means they
      may not be used as variable names.
    - You should extend the definition of `parseArithAtom` with two
      new cases, corresponding to the two new constructors of
      `Arith`. To keep the code a bit cleaner, you may want to create
      a new auxiliary definition called `parseLet` to parse a
      let-expression; or you can simply inline it into the definition
      of `parseArithAtom`.

* Be sure to test your parser on some sample inputs!  For example, you
  might try things like

    - `x+y-foo`
    - `let x = 4*48 in x*x + x-3`
    - `let x = 3 in let y = x*x in let z = y*y*x*x in z*z*y*y*x*x`
    - `(let baz = 19 in baz*baz) - (let foo = 12 in foo*foo)`

    but you should make up your own examples to try as well.
    All of these should parse successfully.

![](../images/stop.gif)

Semantics
---------

* **ROTATE ROLES** and write the name of the new driver here:

Now we will extend the interpreter appropriately.  The presence of
variables introduces two new wrinkles to our interpreter:

1. The interpreter will need to keep track of the current values of
   variables, so that when we encounter a variable we can substitute
   its value.
2. Variables introduce the possibility of runtime errors.  For
   example, `let x = 2 in x + y` will generate a runtime error, since
   `y` is undefined.

For now, you should deal with undefined variables simply by calling
the `error` function with an appropriate error message, which will
make the interpreter crash.  In a later section we will explore a
better way to handle runtime errors.

To keep track of the values of variables, we will use a mapping from
variable names to values, called an *environment*.  To represent such
a mapping, we can use the [`Data.Map`
module](https://hackage.haskell.org/package/containers-0.6.7/docs/Data-Map-Lazy.html),
which works similarly to Python dictionaries or Java's `Map`
interface.  Add the following line to the imports at the top of this
file:

```
import qualified Data.Map as M
```

You can now refer to things from `Data.Map` by prefixing them with
`M.`, for example, `M.empty`, `M.insert`, `M.lookup`. (The reason for
prefixing with `M` like this is that otherwise there would be
conflicts with functions from the `Prelude`.)

* Define an environment as a map from variable names to values:
    ```
    type Env = M.Map String Integer
    ```

* Now add an extra `Env` parameter to `interpArith` which keeps track
  of the current values of variables.

* Extend `interpArith` to interpret variables and let-expressions.
  You will probably find the `M.insert` and `M.lookup` functions
  useful.  See the
  [`Data.Map` documentation](https://hackage.haskell.org/package/containers-0.6.7/docs/Data-Map-Lazy.html)
  for information on these (and other) functions.

* **(Optional, just for fun)**: try to write down an expression which evaluates to
  an integer which is longer than the expression.  What is the shortest
  expression you can write with this property?

![](../images/stop.gif)
