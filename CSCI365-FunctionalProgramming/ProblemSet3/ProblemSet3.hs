module ProblemSet3 where

type Coords = (Double, Double)

data Shape where
    Circle :: Coords -> Double -> Shape
    Rect :: Coords -> Coords -> Shape
    Square :: Coords -> Double -> Shape

{- Problem 2 -}
perimeter :: Shape -> Double
perimeter (Circle _ r) = 2 * pi * r
perimeter (Rect (x1, y1) (x2, y2)) = 2 * (abs (x2-x1) + abs (y2-y1))
perimeter (Square _ a) = 4*a

translateX :: Double -> Shape -> Shape
translateX mov (Circle (x, y) r) = Circle (x+mov, y+mov) r
translateX mov (Rect (x1, y1) (x2, y2)) = Rect (x1+mov, y1+mov) (x2+mov, y2+mov)
translateX mov (Square (x, y) a) = Square (x+mov, y+mov) a

{- Problem Set 3 -}
data Prop where
    T :: Prop
    F :: Prop
    Not :: Prop -> Prop
    And :: Prop -> Prop -> Prop
    Or :: Prop -> Prop -> Prop

eval :: Prop -> Bool
eval T = True
eval F = False
eval (Not p) = not (eval p)
eval (And p q) = eval p && eval q
eval (Or p q) = eval p || eval q

{- Problem Set 4 -}
add :: Maybe Int -> Maybe Int -> Maybe Int
add (Just x) (Just y) = Just(x + y)
add _ _ = Nothing

divide :: Integer -> Integer -> Maybe Integer
divide _ 0 = Nothing
divide x y = Just (div x y)

collapse :: Maybe (Maybe a) -> Maybe a 
collapse (Just(Just a)) = Just a
collapse (Just Nothing) = Nothing
collapse Nothing = Nothing

{- Problem Set 5 -}
pairEither :: (a, Either b c) -> Either (a, b) (a, c)
pairEither (a, Left b) = Left (a, b)
pairEither (a, Right c) = Right (a, c)

