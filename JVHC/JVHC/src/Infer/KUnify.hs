module Infer.KUnify where

import CoreAST.Kind
import Infer.KSubst

kmgu :: Monad m => Kind -> Kind -> m KSubst
kmgu (Kfun l r) (Kfun l' r') =
  do s1 <- kmgu l l'
     s2 <- kmgu (applyK s1 r) (applyK s1 r')
     return (s2 ++ s1)

kmgu (KVar k) kvvar    = kBind k kvvar
kmgu kvar     (KVar k) = kBind k kvar
kmgu Star     Star     = return kemptySubst
kmgu k        k'       = fail $ "cannot unify kinds " ++ (show k) ++ " and " ++ (show k')

kBind :: Monad m => KVar -> Kind -> m KSubst
kBind v k | k == KVar v    = return kemptySubst
          | v `elem` (kv k)= fail $ "occurs check between " ++  (show v) ++ " and "++ (show k)
          | otherwise      = return (v ++-> k)

kmatch :: Monad m => Kind -> Kind -> m KSubst
kmatch Star Star = return kemptySubst
kmatch (KVar k) k' = return (k ++-> k')
kmatch (Kfun l r) (Kfun l' r') =
  do sl <- kmatch l l'
     sr <- kmatch r r'
     merge sl sr
kmatch k1 k2 = fail $ "cannot match " ++ (show k1) ++ " and " ++ (show k2)
