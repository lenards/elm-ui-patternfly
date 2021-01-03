module Tests exposing (..)

import Expect
import Test exposing (..)
import Time



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


calcUnitsAgo :
    { createdOn : Time.Posix
    , now : Time.Posix
    }
    ->
        { number : Int
        , label : String
        }
calcUnitsAgo options =
    let
        createdMillis =
            Time.posixToMillis options.createdOn

        nowMillis =
            Time.posixToMillis options.now

        _ =
            Debug.log "now: " nowMillis

        _ =
            Debug.log "created: " createdMillis

        secondsDiff =
            nowMillis - createdMillis

        _ =
            Debug.log "diff: " secondsDiff
    in
    if secondsDiff > (24 * 60 * 60) then
        { number = secondsDiff // (24 * 60 * 60)
        , label = "days"
        }

    else if secondsDiff > (60 * 60) then
        { number = secondsDiff // (60 * 60)
        , label = "hours"
        }

    else
        { number = secondsDiff // 60
        , label = "minutes"
        }


all : Test
all =
    describe "Default Test Suite"
        [ test "Addition" <|
            \_ ->
                Expect.equal 10 (3 + 7)
        , test "String.left" <|
            \_ ->
                let
                    sample =
                        { createdOn = Time.millisToPosix 1609468521866
                        , now = Time.millisToPosix 1609468694666
                        }

                    expected =
                        { number = 2
                        , label = "days"
                        }
                in
                sample
                    |> calcUnitsAgo
                    |> Expect.equal expected
        ]
