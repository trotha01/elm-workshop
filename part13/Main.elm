module Main (..) where

import StartApp
import ElmHub exposing (..)
import Effects exposing (Effects)
import Task exposing (Task)
import Html exposing (Html)


main : Signal Html
main =
  app.html


app : StartApp.App Model
app =
  StartApp.start
    { view = view
    , update = unwrapUpdate
    , init = ( initialModel, Effects.task (searchFeed initialModel.query) )
    , inputs = []
    }

unwrapUpdate Action -> Maybe Model -> ( Maybe Model, Effects Action)
unwrapUpdate action maybeModel =
  case action of
    SetModel model ->
      ( Just model, Effects.none )

    someOtherAction ->
      case maybeModel of
        Nothing ->
          ( maybeModel, Effects.none )

        Just model ->
          let
            ( newModel, newEffects ) =
              update action model
          in
            ( Just newModel, newEffects)




port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks
