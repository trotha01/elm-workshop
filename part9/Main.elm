module Main exposing (main)

import ElmHub exposing (Model, Msg)
import Html


main : Program Never Model Msg
main =
    Html.program
        { view = ElmHub.view
        , update = ElmHub.update
        , init = ElmHub.init
        , subscriptions = ElmHub.subscriptions
        }
