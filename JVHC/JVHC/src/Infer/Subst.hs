module Infer.Subst
  where

import CoreAST.Types

import Data.List(nub, union, intersect)


type Subst  = [(Tyvar, Type)]

nullSubst :: Subst
nullSubst = []

(+->)  :: Tyvar -> Type -> Subst
u +-> t = [(u,t)]

class Types t where
  apply :: Subst -> t -> t
  tv    :: t -> [Tyvar]

instance Types Char where
  apply _ c = c
  tv    _   = []

instance Types Type where
  apply s x@(TVar u) = case lookup u s of
                       Just t -> t
                       Nothing -> x
  apply s (TAp l r) = TAp (apply s l) (apply s r)
  apply _ t         = t

  tv (TVar u)       = [u]
  tv (TAp l r)      = (tv l) `union` (tv r)
  tv _              = []

instance Types Tyvar where
  apply s t = case lookup t s of
                Just (TVar x) -> x
                Just y        -> error $ "here: " ++ (show s) ++  (show y)
                Nothing -> t
  tv t = [t]

instance Types a => Types [a] where
  apply s = map (apply s)
  tv      = nub . (concatMap tv)

instance (Types a, Types b) => Types (a,b) where
  apply s (a,b) = (apply s a, apply s b)
  tv      (a,b) = tv a ++ tv b

instance (Types a, Types b, Types c) => Types (a,b,c) where
  apply s (a,b,c) = (apply s a, apply s b, apply s c)
  tv      (a,b,c) = tv a ++ tv b ++ tv c

applyTillNoChange :: (Types t, Eq t) => Subst -> t -> t
applyTillNoChange sub t = if change then applyTillNoChange sub t' else t'
  where t' = apply sub t
        change = t /= t'

infixr 4 @@
(@@)  :: Subst -> Subst -> Subst
s1 @@ s2 = [(u, s1 `apply` t) | (u,t) <- s2] ++ s1


merge :: (Monad m) => Subst -> Subst -> m Subst
merge s1 s2 = if agree then return merged else fail $ "subst merge failed " ++ (show s1) ++ ", " ++ (show s2)
  where
    domain = map fst
    merged = s1 ++ s2
    agree = all (\v -> apply s1 (TVar v) == apply s2 (TVar v))
                (domain s1 `intersect` domain s2)
