-- | Functions to create "pure" Halogen components.
module Halogen.Pure where

import Prelude

import Halogen as H

-- | Construct a component that renders as a pure function of it's input.
render
  :: forall surface query action slots input output m
   . (input -> surface (H.ComponentSlot surface slots m action) action)
  -> H.Component surface query input output m
render f = H.mkComponent
  { initialState: identity
  , render: f
  , eval: case _ of
    H.Receive i a -> H.modify_ (const i ) $> a
    x -> H.mkEval H.defaultEval x
  }

-- | Construct a component that renders constant HTML
-- |
-- | `html h = render $ const h` except without internally tracking the
-- | input as state.
html
  :: forall surface query action slots input output m
   . (surface (H.ComponentSlot surface slots m action) action)
  -> H.Component surface query input output m
html h = H.mkComponent
  { initialState: const unit
  , render: \_ -> h
  , eval: H.mkEval H.defaultEval
  }

-- | Pure render component with actions
renderAction
  :: forall surface query action slots input output m
   . (action -> H.HalogenM input action slots output m Unit)
  -> (input -> surface (H.ComponentSlot surface slots m action) action)
  -> H.Component surface query input output m
renderAction handleAction f = H.mkComponent
  { initialState: identity
  , render: f
  , eval: case _ of
    H.Receive i a -> H.modify_ (const i ) $> a
    x -> H.mkEval H.defaultEval { handleAction = handleAction } x
  }

-- | Render constant HTML, with an action handler
htmlAction
  :: forall surface query action slots input output m
   . (action -> H.HalogenM Unit action slots output m Unit)
  -> (surface (H.ComponentSlot surface slots m action) action)
  -> H.Component surface query input output m
htmlAction handleAction h = H.mkComponent
  { initialState: const unit
  , render: \_ -> h
  , eval: H.mkEval H.defaultEval { handleAction = handleAction }

  }

{- TODO: Can we avoid a newtype below?

-- https://github.com/purescript/documentation/blob/master/errors/CycleInTypeSynonym.md
-- type PlainAction state action slots output m a =
--   H.HalogenM state PlainAction slots output m a

-- | Action handler for plain old unwrapped actions
handlePlainAction
  :: forall action slots input output m
   . H.HalogenM input action slots output m Unit
  -> H.HalogenM input action slots output m Unit
handlePlainAction = identity

renderAction_ = renderAction handlePlainAction

htmlAction_ = htmlAction handlePlainAction

-}
