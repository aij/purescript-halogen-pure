module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Data.Const (Const)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Pure as Pure

hello :: forall m. H.Component HH.HTML (Const Void) Unit Void m
hello = Pure.html $ HH.text "Hello world!"

helloYou :: forall m. H.Component HH.HTML (Const Void) String Void m
helloYou = Pure.render $ \name -> HH.text ("Hello "<>name<>"!")

main :: Effect Unit
main = do
  log "You should add more tests."
