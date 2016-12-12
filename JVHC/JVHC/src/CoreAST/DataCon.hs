module CoreAST.DataCon where

import CoreAST.Types

import CoreAST.TScheme

data TyCon = MkTyCon { mtyCon :: Tycon }
 deriving (Show,Eq)

data DataCon = MkDataCon { dName :: String, conType :: TScheme }
  deriving (Show,Eq)
