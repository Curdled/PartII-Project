{-# LANGUAGE DeriveGeneric #-}

module CoreAST.TScheme where

import GHC.Generics
import Control.DeepSeq

import CoreAST.Types

data TScheme = TScheme [Type] Type
  deriving (Show,Eq, Generic)

emptyTS :: Type -> TScheme
emptyTS = TScheme []

instance NFData TScheme
