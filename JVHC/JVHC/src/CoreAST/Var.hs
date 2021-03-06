{-# LANGUAGE DeriveGeneric #-}

module CoreAST.Var where

import GHC.Generics
import Control.DeepSeq

import CoreAST.Types
import CoreAST.TScheme

data Var = MkVar  { varName :: String,  varType :: TScheme }
         | MkTVar { tvarName :: Type }
    deriving (Show, Generic)

instance Eq Var where
  (==) (MkVar  {varName  = n1}) (MkVar  {varName  = n2}) = n1 == n2
  (==) (MkTVar {tvarName = t1}) (MkTVar {tvarName = t2}) = t1 == t2

instance NFData Var
