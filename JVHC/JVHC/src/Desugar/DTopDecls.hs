module Desugar.DTopDecls where

import CoreAST.Types

import Parsing.ParsingAST

import Infer.TIMain
import Infer.Assumption

import Infer.BuildInTypes as BIT

import Infer.BuildInFunctionTypes

import Desugar.DDataDecl
import Desugar.DTypes
import Desugar.DMain
import Desugar.DExpr

import Control.Monad

import Debug.Trace

dTopDecls :: Monad m => Body -> m (BindGroup, [DataType])
dTopDecls (TTopDecls decls) =
  do let (dd,decl) = splitTopDecls decls
     dataTypes     <- dDataDecls dd
     let context   = splitDataType (dataTypes ++ BIT.types)
     let context'  = (fst context, snd context ++ buildInAssumptions)
     bg            <- dDecl (dataTypes ++ BIT.types) context' decl
     return (bg,dataTypes)

splitTopDecls :: [TopDecl] -> ([TDataDecl],[Decl])
splitTopDecls td = driver td [] []
  where
    driver []               dds decl = (dds,decl)
    driver ((TData dd):xs)  dds decl = driver xs (dd:dds) decl
    driver ((TDecl dcl):xs) dds decl = driver xs dds      (dcl:decl)

splitDataType :: [DataType] -> (TypeList,[Assumption])
splitDataType dt = (tl,assump)
  where assump = concatMap (\(DT { dConstrs = d }) -> d) dt
        tl     = map  (\(DT { dTName = name, dKind = kind }) -> (name, Tycon name kind)) dt

