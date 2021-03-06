module Printing.PPrint where

import Text.PrettyPrint

pretty  :: PPrint a => a -> String
pretty   = render . pprint

ppParen    :: Bool -> Doc -> Doc
ppParen t x = if t then parens x else x

class PPrint a where
  pprint    :: a -> Doc

  parPprint :: a -> Doc
  parPprint  = parens . pprint

  pplist    :: [a] -> Doc
  pplist    xs = brackets (fsep (punctuate comma (map pprint xs)))

instance PPrint a => PPrint [a] where
  pprint  = pplist

instance PPrint Char where
  pprint  = char
  pplist  = text

instance PPrint Integer where
  pprint  = integer

instance PPrint Int where
  pprint  = int

instance PPrint Float where
  pprint  = float

instance PPrint Double where
  pprint  = double

instance (PPrint a, PPrint b) => PPrint (a,b) where
  pprint (x,y) = parens (sep [pprint x <> comma, pprint y])

instance (PPrint a, PPrint b, PPrint c) => PPrint (a,b,c) where
  pprint (x,y,z) = parens (sep [pprint x <> comma,
                                pprint y <> comma,
                                pprint z])
