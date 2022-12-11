{-# LANGUAGE ScopedTypeVariables #-}

import System.IO
import Control.Monad (forM_)
import Debug.Trace
import Data.List

-- Starting Items: [Int]
  -- Worry levels of all items
-- Operation: Int -> Int
  -- Transform the worry level of an item
-- Test: Int -> Int
  -- Takes an int and decides to which monkey to throw to (return value)
data Monkey = Monkey {
  items           :: [Int],
  operation       :: (Int -> Int),
  test            :: (Int -> Int),
  inspectionCount :: Int
}

-- Transform worry level with relief
relief :: Int -> Int
relief n = n `div` 3

appendInt :: [Int] -> Int -> [Int]
appendInt [] a = [a]
appendInt (x:xs) a = x : (appendInt xs a)

appendMonkey :: [Monkey] -> Monkey -> [Monkey]
appendMonkey [] a = [a]
appendMonkey (x:xs) a = x : (appendMonkey xs a)

-------------
-- Parsing --
-------------

-- https://stackoverflow.com/a/36220926/14874405
range :: Int -> Int -> [Int]
range start end = takeWhile (<=end) $ iterate (+1) start

-- https://stackoverflow.com/a/11746651/14874405
split :: Char -> [Char] -> [String]
split _ "" = []
split c s = firstWord : (split c rest)
    where firstWord = takeWhile (/=c) s
          rest = drop (length firstWord + 1) s

-- Gets the amount of monkeys - 1
monkeyCount :: [String] -> Int
monkeyCount strs = (countTrues (map isEndOfMonkey strs))
  where
  isEndOfMonkey str = str == "" -- startsWithChar '\n' str
  filterTrues boolList = filter (==True) boolList
  countTrues boolList = length (filterTrues boolList)

-- Takes in input as lines
parseMonkeys :: [String] -> [Monkey]
parseMonkeys lines = do
  let monkeyCnt = monkeyCount lines
  let monkeyRange = range 0 monkeyCnt
  map parseMonkey monkeyRange
  where
  parseMonkey :: Int -> Monkey
  parseMonkey i = do
    let startLine = i * 7; -- idx of the first line
    let monkeyLine = lines !! (startLine + 0)
    let startingItemsLine = lines !! (startLine + 1)
    let operationLine = lines !! (startLine + 2)
    let testLine = lines !! (startLine + 3)
    let ifTrueLine = lines !! (startLine + 4)
    let ifFalseLine = lines !! (startLine + 5)

    let startingItems = parseStartingItems startingItemsLine
    let operation = parseOperation operationLine
    let test = parseTest testLine ifTrueLine ifFalseLine

    Monkey {items=startingItems, operation=operation, test=test, inspectionCount=0}
    -- return Monkey

parseStartingItems :: String -> [Int]
parseStartingItems line = do
  let firstSplit = split ':' line
  let items = split ',' (firstSplit !! 1)
  map readItem items
  where
    readItem item = read item::Int

debug = flip trace

parseOperation :: String -> (Int -> Int)
parseOperation line = do
  let firstSplit = split ':' line
  let operation = split '=' (firstSplit !! 1)
  let operationSplit = split ' ' (operation !! 1)
  let operator = ((filter (/="") operationSplit) !! 1)
  let valString = ((filter (/="") operationSplit) !! 2)
  case (operator !! 0) of
    '+' -> (\x -> x + if (valString == "old") then x else (read valString::Int))
    '-' -> (\x -> x - if (valString == "old") then x else (read valString::Int))
    '*' -> (\x -> x * if (valString == "old") then x else (read valString::Int))
    '/' -> (\x -> x `div` if (valString == "old") then x else (read valString::Int))
    _ -> (\x -> -999999) -- error

-- Returns a function that returns the monkey it shoudl throw the item too it is passed to
parseTest :: String -> String -> String -> (Int -> Int)
parseTest testS ifTrueS ifFalseS = do
  let testSplit = filter (/="") (split ' ' testS)
  let testVal = read (testSplit !! 3)::Int
  let ifTrueSplit = filter (/="") (split ' ' ifTrueS)
  let ifTrueVal = read (ifTrueSplit !! 5)::Int
  let ifFalseSplit = filter (/="") (split ' ' ifFalseS)
  let ifFalseVal = read (ifFalseSplit !! 5)::Int
  (\x -> if x `rem` testVal == 0 then ifTrueVal else ifFalseVal)

monkeyNumber :: [Char] -> Int
monkeyNumber s = do
  let lineSplit = split ' ' s
  read (lineSplit !! 1)::Int

doRound :: [Monkey] -> (Int -> Int) -> [Monkey]
doRound monkeys reliefFn = do
  newMonkeysForMonkeyAt monkeys 0 (length monkeys) reliefFn
  
  where
    newMonkeysForMonkeyAt :: [Monkey] -> Int -> Int -> (Int -> Int) -> [Monkey]
    newMonkeysForMonkeyAt monkeys idx max reliefFn = do
      if (length (items (monkeys !! idx)) /= 0)
        then do 
          let item = ((take 1 (items (monkeys !! idx))) !! 0)
          -- apply on worry level
          let newItem = (operation (monkeys !! idx)) item
          -- worry level decreses as monkey gets bored
          let newItem2 = reliefFn newItem
          let throwsToMonkey = (test (monkeys !! idx)) newItem2 -- index of the monkey the item is thrown to

          let newMonkey = Monkey{
            items=(drop 1 (items (monkeys !! idx))),
            operation=(operation (monkeys !! idx)),
            test=(test (monkeys !! idx)),
            inspectionCount=((inspectionCount (monkeys !! idx)) + 1)}
          let newMonkeys = (appendMonkey (take idx monkeys) newMonkey) ++ (drop (idx + 1) monkeys)
          let newThrownToMonkey = Monkey{
            items=(appendInt (items (monkeys !! throwsToMonkey)) newItem2),
            operation=(operation (monkeys !! throwsToMonkey)),
            test=(test (monkeys !! throwsToMonkey)),
            inspectionCount=(inspectionCount (monkeys !! throwsToMonkey))}
          let newMonkeysAfterThrow = (appendMonkey (take throwsToMonkey newMonkeys) newThrownToMonkey) ++ (drop (throwsToMonkey + 1) newMonkeys)
          
          newMonkeysForMonkeyAt newMonkeysAfterThrow idx max reliefFn
        else
            if ((idx + 1) == max)
              then monkeys
              else newMonkeysForMonkeyAt monkeys (idx + 1) max reliefFn

-- Execute x amount of rounds
doRounds :: [Monkey] -> Int -> (Int -> Int) -> [Monkey]
doRounds monkeys x reliefFn = do
  if (x == 0)
    then monkeys
    else do 
      let newMonkeys = doRound monkeys reliefFn
      doRounds newMonkeys (x - 1) reliefFn

-- Returns 2 of the highest numbers in the inspectionCount
takeHighest2 :: [Monkey] -> [Int]
takeHighest2 a = do
  let mapped = map (\monkey -> inspectionCount monkey) a
  let sorted = sort mapped
  [(sorted !! ((length mapped) - 1)), (sorted !! ((length mapped) - 2))]
      

main = do
  handle <- openFile "../example.txt" ReadMode
  contents <- hGetContents handle
  let lines = split '\n' contents
  let monkeys :: [Monkey] = parseMonkeys lines

  -- Part 1
  let monkeys1 = doRounds monkeys 20 relief

  let highest2 = takeHighest2 (monkeys1)
  let monkeyBusiness = (highest2 !! 0) * (highest2 !! 1)

  print "Part 1:"
  print (show monkeyBusiness)

  -- why you no work? :(
  -- Part 2
  -- let monkeys2 = doRounds monkeys 1000 (\x -> x)

  -- let highest2_2 = takeHighest2 (monkeys2)
  -- let monkeyBusiness2 = (highest2_2 !! 0) * (highest2_2 !! 1)

  -- print "Part 2:"
  -- print (show monkeyBusiness2)

  -- DEBUG --
  -- Print items
  -- forM_ monkeys2 $ \s -> do
  --   print (items s)

  -- Check operations
  -- forM_ monkeys $ \s -> do
  --   print ((operation s) 2)

  -- Check tests
  -- forM_ monkeys $ \s -> do
  --   print ((test s) 17)

  -- Check inspection counts
  -- forM_ monkeys2 $ \s -> do
  --   print ((inspectionCount s))
