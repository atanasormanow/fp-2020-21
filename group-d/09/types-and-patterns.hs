{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
-- cover all cases!
{-# OPTIONS_GHC -fwarn-unused-matches #-}
-- use all your pattern matches!
{-# OPTIONS_GHC -fwarn-missing-signatures #-}
-- write all your toplevel signatures!
{-# OPTIONS_GHC -fwarn-name-shadowing #-}
-- use different names!
{-# OPTIONS_GHC -fwarn-incomplete-uni-patterns #-}
-- no incomplete patterns in lambdas!

import Prelude hiding (map, reverse, filter, foldl, zip)

-- THROWBACK
-- - декларации/дефиниции на функции
-- - прилагане на функции и операции
-- - частично прилагане на функции и currying
-- - if <cond> then <expr> else <expr>
-- - (\x y -> 2 * x + y)
-- - ghci commands:
--    - :l(oad)
--    - :r(eload)
--    - :q(uit)
--    - :t(ype)
--    - :i(info)


-- разглеждане на случаи - guards
-- мислете си за cond от scheme
fib :: Int -> Int
fib n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = fib (n - 1) + fib (n - 2)


-- Типовете които може мда дефинираме с ключовата дума type
-- не са много интересни
type Vector3 = (Int, Int, Int)

-- Всъщност това ни служи когато искаме да дадем
-- нещо като всевдоним на някой тип.
-- Когато пуснем програмата тези имена изчезват и програмата ни
-- вместо Vector3 ще вижда просто (Int, Int, Int)
sumV3 :: Vector3 -> Vector3 -> Vector3
sumV3 (x1,y1,z1) (x2,y2,z2) = (x1+x2,y1+y2,z1+z2)



-- Дефинираме алгебричен тип данни по следния начин:
-- Пример за нещо което бихме постигнали с "enum" в други езици
data Color
  = Red
  | Green
  | Blue
  deriving Show

-- Алгебричните типове данни описват структурарта на елементите.
-- Да си спомним дефиницията на списък в Scheme
-- 1) '()
-- 2) (cons h . t), t е списък

-- Нека си дефинираме списък
data List a
  = Nil
  | Cons a (List a)
  deriving Show
-- Виждаме че има някакво "a" тук.
-- Това е просто елемент от тип "a", така функцията ни ще е полиморфична
-- и ще можем да заместим "a" с произволен тип
-- списък с елементи от тип Int би имал следната дефиниция
-- data List Int = Nil | Cons Int (List Int)
-- TODO: нещата от дясно са конструктори
-- TODO: конструкторите са просто тагове
-- TODO: sum and product in ADTs

-- * Типовете и конструкторите трябва да започват с главна буква

-- pattern matching (споставяне на образци)
-- видове образци:
-- - литерал - съвпада с конкретна стойност
-- - променлива - съвпада с произволна стойност, свързва я с име
-- - анонимен образец - съвпада с произволна стойност, не я свързва с име

-- Можем да дефинираме функции като поредица от равенства.
-- Все едно дефинираме функцията по различен начин за различните входни данни.
-- А вида на входните данни подбираме чрез образци.
-- Важно е да покрием всички случаи!

-- Примери:
fact :: Int -> Int
fact 0 = 1  -- получили сме 0 и директно връщаме 1
fact n = n * fact (n - 1)
-- получили сме някакво число и му даваме името "n".
-- със сигурност не е 0, защото проверката на дефинициите се случва отгоре надолу.
-- Тук ако подадем отрицателно число ще зациклим,
-- но целта ни е функцията да е дефинирана над естествени числа.

listLength :: List a -> Int
listLength Nil = 0  -- съпоставяме [] (конкретна стойност)
listLength (Cons _ t) = 1 + listLength t
-- Тук се вижда че можем да използваме конструкторите на алгебричен тип
-- и да ги съпоставяме както бихме правили с литерали
-- (все пак те са просто низове)
-- Тоест получили сме списък от вида (Cons h t),
-- където "h" е главата а "t" опашката
-- Дали сме име на опашката и можем да използваме променливата отдясно на равното.
-- Обаче главата не ни трябва да я свързваме с име затова вместо "h" пишем "_"
-- Така казваме че има някакъв елемент на това място,
-- но не ни трябва да знаем какъв е.

-- * няма унификация на имената на променливите (трябва да са различни)

-- TODO: Prelude list definition

-- именовани образци
headPlusLen :: [Int] -> Int
headPlusLen [] = 0
headPlusLen (x:xs) = x + length (x:xs)

-- в случея не е много но не можем ли да си спестим "x:xs" частта
headPlusLen' :: [Int] -> Int
headPlusLen' [] = 0
headPlusLen' r@(x:_) = x + length r
-- Тук опашката на списъка не ни трябва

-- * Ползвайте guard-ове само когато наистина ви се налага
-- * Тоест дефинирайте си функциите с pattern matching когато можете


data Nat -- от Natural number (естествено число)
  = Zero
  | Succ Nat
  deriving Show

-- ЗАДАЧИ

-- За дадено n връща (n - 1)
-- predNat от 0 е 0
predNat :: Nat -> Nat
predNat = undefined

-- Превръщане на Integer в Nat
integerToNat :: Integer -> Nat
integerToNat = undefined

-- Превръщане на Nat в Integer
natToInteger :: Nat -> Integer
natToInteger = undefined

-- Събиране
plus :: Nat -> Nat -> Nat
plus = undefined

-- Умножение
mult :: Nat -> Nat -> Nat
mult = undefined

-- Имплементирайте някой познати функции за списъци
-- (стандартните списъци в Prelude)

map :: (a -> b) -> [a] -> [b]
map = undefined

-- Hint: операция за конкатенация на списъци: ++
reverse :: [a] -> [a]
reverse = undefined

filter :: [a] -> (a -> Bool) -> [a]
filter = undefined

-- типовете на елементите на списъка и акумулатора са различни
-- както ако в Scheme правите foldl върху списък от числа,
-- но с предикат и логическа връзка (and, or) натрупвате булева стойност
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl = undefined

-- За дадени два списъка връща списък от двойки на съответните елементи от списъка.
zip :: [a] -> [b] -> [(a,b)]
zip = undefined

-- Прилага поелементно функцията върху двата списъка едновременно.
-- Връща списък от резултатите
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith = undefined

-- Връща най-големия префикс на списък, такъв че даденият предикат е изпълнен за всичките му елементи
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile = undefined
