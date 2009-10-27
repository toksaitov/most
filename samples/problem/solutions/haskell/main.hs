module Main where

main = do
        s <- getLine
        putStrLn $ show $ sum $ map read (words s)