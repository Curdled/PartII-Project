module ParserTest.TestDeclParser(tests)
  where

import Parsing.Lexer
import Parsing.Parser (decl)
import Parsing.ParsingAST
import CoreAST.Literal
import Test.HUnit

tests = test [test1,test2]

test1 = "tdecl f x = 2" ~: decl [Varid "f",Varid "x",ReservedOP Equal,Literal (LitInt 2)] ~=? TFunDecl (TFundecl (TVarPat "f" ["x"]) (TELiteral (LitInt 2)))

test2 = "tdecl f x y = E" ~: decl [Varid "f",Varid "x",Varid "y",ReservedOP Equal,Conid "E"] ~=? TFunDecl (TFundecl (TVarPat "f" ["x","y"]) (TEConstr "E"))

