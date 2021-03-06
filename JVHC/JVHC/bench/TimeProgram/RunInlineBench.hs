module TimeProgram.RunInlineBench where

import Control.Monad

import Printing.CSVPrint

import TimeProgram.RunProgram

import SampleProg.InlineProg
import SampleProg.ProgMaker

import Pipeline.Compiler

import TimeProgram.TimeRunningParser

runBenchmark = varyTestInline numb

saveBenchmark :: FilePath -> IO ()
saveBenchmark path =
  do out <- (liftM toCSV $ runBenchmark)
     putStr out
     writeFile path out


varyTestInline :: Fractional a =>  [Int] -> IO [(IsOp String,[a])]
varyTestInline enum =
  do opt  <- mapM (runTestInline normalOpt) enum
     putStrLn "50%"
     nOpt <- mapM (runTestInline noOpt)     enum
     return $ opt ++ nOpt

runTestInline :: Fractional a => OptimizeParams -> Int -> IO (IsOp String,[a])
runTestInline op n =
  do let src = buildProg n
     putStrLn (show n)
     res <- liftM (map fromIntegral) $  runN 50 src False op "-Xss400m" parseTime
     return ((inlineTimes op == 1 , show  n),res)

buildProg :: Int -> String
buildProg times = functionsToProg [mkPutIntMainMethod times "testN", testProg ]

numb :: [Int]
numb = 50 : map ( (\x -> x -10000 ) . floor . (*) 40000 . log . log) [4,6..80]

