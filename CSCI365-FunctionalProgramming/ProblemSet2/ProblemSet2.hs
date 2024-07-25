{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE GADTSyntax #-}

module ProblemSet2 where
import Data.Char (isAsciiLower)

{- Problem Three -}
nand :: Bool -> Bool -> Bool
nand True True = False
nand False False = True
nand _ _ = True

{- Problem Four-}
offSet :: Int
offSet = fromEnum 'a' - fromEnum 'A'

isDigit :: Char -> Bool
isDigit ch
    | isAsciiLower ch = True
    | otherwise = False

toUpperDIY :: Char -> Char
toUpperDIY ch
    | isDigit ch = toEnum (fromEnum ch - offSet)
    | otherwise = ch

stringConvert :: String -> String
stringConvert = map toUpperDIY

{- Problem Five -}
dup :: Integer -> (Integer, Integer)
dup x = (x, x)

add :: (Integer, Integer) -> Integer
add (x, y) = x + y

doubleFst :: (Integer, Integer) -> (Integer, Integer)
doubleFst (x, y) = (2 * x, y)

{- Problem Six -}
numberNDroots :: Float -> Float -> Float -> Integer
numberNDroots a b c
    | b**2 > 4*a*c = 2
    | b**2 == 4*a*c = 1
    | otherwise = 0

numberRoots :: Float -> Float -> Float -> Integer
numberRoots a b c
    | a /= 0.0 = numberNDroots a b c
    | b /= 0.0 = 1
    | b /= 0.0 && c /= 0.0 = 0
    | otherwise = 3

{- Problem Seven -}
roman :: Integer -> String
roman n
  | n <= 0    = error "Input must be a positive integer"
  | n > 3999  = error "Input must be less than or equal to 3999"
  | otherwise = convertToRoman n
  where
    romanNumerals = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
      ]

    convertToRoman :: Integer -> String
    convertToRoman 0 = ""
    convertToRoman num =
      let (value, numeral) = head $ dropWhile (\(v, _) -> v > num) romanNumerals
      in numeral ++ convertToRoman (num - value)

{- Problem Eight -}
isqrt :: Integer -> Integer
isqrt n
  | n < 0     = error "Negative input"
  | n < 2     = n
  | otherwise = binarySearch 1 n
  where
    binarySearch :: Integer -> Integer -> Integer
    binarySearch low high
      | low > high = high
      | mid * mid > n = binarySearch low (mid - 1)
      | otherwise     = binarySearch (mid + 1) high
      where
        mid = (low + high) `div` 2

{- Problem Ten -}
swap :: (Integer, Integer) -> (Integer, Integer)
swap (x, y) = (y, x)

double :: Integer -> Integer
double = add . dup