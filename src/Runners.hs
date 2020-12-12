{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns -Wno-unused-imports #-}

module Runners where

import Block
import Control.Monad
import Data.Char
import Data.Foldable (toList)
import Data.List
import Data.List.Split
import Data.Map (Map)
import Data.Map qualified as M
import Data.Maybe
import Data.Sequence qualified as Q
import Data.Set (Set)
import Data.Set qualified as S
import Data.Vector qualified as V
import Debug.Trace
import Lib
import Linear hiding (E)
import Parse
import Text.Megaparsec

data Dir = N | E | S | W | F | L | R
  deriving (Show)

go x y wx wy [] = (x, y)
go x y wx wy ((N, n) : t) = go x y wx (wy + n) t
go x y wx wy ((S, n) : t) = go x y wx (wy - n) t
go x y wx wy ((E, n) : t) = go x y (wx + n) wy t
go x y wx wy ((W, n) : t) = go x y (wx - n) wy t
--
go x y wx wy ((L, 90) : t) = go x y (- wy) wx t
go x y wx wy ((L, 180) : t) = go x y (- wx) (- wy) t
go x y wx wy ((L, 270) : t) = go x y wy (- wx) t
go x y wx wy ((R, 90) : t) = go x y wy (- wx) t
go x y wx wy ((R, 180) : t) = go x y (- wx) (- wy) t
go x y wx wy ((R, 270) : t) = go x y (- wy) wx t
--
go x y wx wy ((F, n) : t) = go (x + n * wx) (y + n * wy) wx wy t

parseD :: String -> (Dir, Int)
parseD ('N' : n) = (N, read n)
parseD ('S' : n) = (S, read n)
parseD ('E' : n) = (E, read n)
parseD ('W' : n) = (W, read n)
parseD ('R' : n) = (R, read n)
parseD ('L' : n) = (L, read n)
parseD ('F' : n) = (F, read n)

day12 :: IO ()
day12 = do
  input <- fmap parseD . lines <$> readFile "input/day12.txt"
  let (x, y) = go 0 0 10 1 input
  print $ abs x + abs y

--- 2228
--- 42908
