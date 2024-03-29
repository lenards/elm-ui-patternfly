module PF4.Icons exposing
    ( hamburger
    , chevronDown, chevronDownRgb255, chevronRight, chevronRightRgb255, closeCircle, closeCircleRgb255, close, closeRgb255, info, infoRgb255, times, timesRgb255, nineBox, nineBoxRgb255
    )

{-| This library handles functions that will render `Svg` versions of
the icons used by the `PF4` library. This relieves folks from the
need to include a sprite sheet or other assets when using `PF4`.

Most icons has functions for a default color and `Rgb255` form.


# System Icons, no color variation

@docs hamburger


# Icons with default color and variation

@docs chevronDown, chevronDownRgb255, chevronRight, chevronRightRgb255, closeCircle, closeCircleRgb255, close, closeRgb255, info, infoRgb255, times, timesRgb255, nineBox, nineBoxRgb255

-}

import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes exposing (style)
import String
import Svg
import Svg.Attributes as SvgAttrs


toCssRgb : ( Int, Int, Int ) -> String
toCssRgb ( r, g, b ) =
    "rgb("
        ++ String.fromInt r
        ++ ", "
        ++ String.fromInt g
        ++ ", "
        ++ String.fromInt b
        ++ ")"


{-| -}
info : Element msg
info =
    infoRgb255 43 154 243


{-| -}
infoRgb255 : Int -> Int -> Int -> Element msg
infoRgb255 r g b =
    Html.div [ style "color" (( r, g, b ) |> toCssRgb) ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 512 512"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M256 8C119.043 8 8 119.083 8 256c0 136.997 111.043 248 248 248s248-111.003 "
                        , "248-248C504 119.083 392.957 8 256 8zm0 110c23.196 0 42 18.804 42 42s-18.804 "
                        , "42-42 42-42-18.804-42-42 18.804-42 42-42zm56 254c0 6.627-5.373 12-12 "
                        , "12h-88c-6.627 0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h12v-64h-12c-6.627 "
                        , "0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h64c6.627 0 12 5.373 12 "
                        , "12v100h12c6.627 0 12 5.373 12 12v24z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


{-| -}
close : Element msg
close =
    closeRgb255 106 110 115


{-| -}
closeRgb255 : Int -> Int -> Int -> Element msg
closeRgb255 r g b =
    Html.div [ style "color" (( r, g, b ) |> toCssRgb) ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 1792 1792"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M1490 1322q0 40-28 68l-136 136q-28 28-68 "
                        , "28t-68-28l-294-294-294 294q-28 28-68 "
                        , "28t-68-28l-136-136q-28-28-28-68t28-68l294-294-294-294q-28-28-28-68t28-68l136-136q28-28 "
                        , "68-28t68 28l294 294 294-294q28-28 68-28t68 "
                        , "28l136 136q28 28 28 68t-28 68l-294 294 294 "
                        , "294q28 28 28 68z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


{-| -}
closeCircle : Element msg
closeCircle =
    closeCircleRgb255 106 110 115


{-| -}
closeCircleRgb255 : Int -> Int -> Int -> Element msg
closeCircleRgb255 r g b =
    Html.div [ style "color" (( r, g, b ) |> toCssRgb) ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 512 512"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M256 8C119 8 8 119 8 256s111 248 248 248 "
                        , "248-111 248-248S393 8 256 8zm121.6 313.1c4.7 "
                        , "4.7 4.7 12.3 0 17L338 377.6c-4.7 4.7-12.3 "
                        , "4.7-17 0L256 312l-65.1 65.6c-4.7 4.7-12.3 "
                        , "4.7-17 0L134.4 338c-4.7-4.7-4.7-12.3 "
                        , "0-17l65.6-65-65.6-65.1c-4.7-4.7-4.7-12.3 "
                        , "0-17l39.6-39.6c4.7-4.7 12.3-4.7 17 0l65 65.7 "
                        , "65.1-65.6c4.7-4.7 12.3-4.7 17 0l39.6 39.6c4.7 "
                        , "4.7 4.7 12.3 0 17L312 256l65.6 65.1z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


{-| -}
times : Element msg
times =
    close


{-| -}
timesRgb255 : Int -> Int -> Int -> Element msg
timesRgb255 r g b =
    closeRgb255 r g b


{-| -}
hamburger : Element msg
hamburger =
    hamburgerRgb255 255 255 255


{-| -}
hamburgerRgb255 : Int -> Int -> Int -> Element msg
hamburgerRgb255 r g b =
    Html.div [ style "color" (( r, g, b ) |> toCssRgb) ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 448 512"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M16 132h416c8.837 0 16-7.163 "
                        , "16-16V76c0-8.837-7.163-16-16-16H16C7.163 60 "
                        , "0 67.163 0 76v40c0 8.837 7.163 16 16 16zm0 "
                        , "160h416c8.837 0 16-7.163 "
                        , "16-16v-40c0-8.837-7.163-16-16-16H16c-8.837 "
                        , "0-16 7.163-16 16v40c0 8.837 7.163 16 16 "
                        , "16zm0 160h416c8.837 0 16-7.163 "
                        , "16-16v-40c0-8.837-7.163-16-16-16H16c-8.837 "
                        , "0-16 7.163-16 16v40c0 8.837 7.163 16 16 16z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


chevron_ : Html msg
chevron_ =
    Svg.svg
        [ SvgAttrs.fill "currentColor"
        , SvgAttrs.height "1em"
        , SvgAttrs.width "1em"
        , SvgAttrs.viewBox "0 0 256 512"
        , SvgAttrs.style "vertical-align: -0.125em;"
        ]
        [ Svg.path
            [ SvgAttrs.d
                (String.concat
                    [ "M224.3 273l-136 136c-9.4 9.4-24.6 9.4-33.9 "
                    , "0l-22.6-22.6c-9.4-9.4-9.4-24.6 "
                    , "0-33.9l96.4-96.4-96.4-96.4c-9.4-9.4-9.4-24.6 "
                    , "0-33.9L54.3 103c9.4-9.4 24.6-9.4 33.9 0l136 "
                    , "136c9.5 9.4 9.5 24.6.1 34z"
                    ]
                )
            ]
            []
        ]


{-| -}
chevronDown : Element msg
chevronDown =
    chevronDownRgb255 106 110 115


{-| -}
chevronDownRgb255 : Int -> Int -> Int -> Element msg
chevronDownRgb255 r g b =
    Html.div
        [ style "color" (( r, g, b ) |> toCssRgb)
        , style "transform" "rotate(90deg)"
        , style "transition" ".2s ease-in 0s"
        ]
        [ chevron_ ]
        |> Element.html


{-| -}
chevronRight : Element msg
chevronRight =
    chevronRightRgb255 106 110 115


{-| -}
chevronRightRgb255 : Int -> Int -> Int -> Element msg
chevronRightRgb255 r g b =
    Html.div [ style "color" (( r, g, b ) |> toCssRgb) ]
        [ chevron_ ]
        |> Element.html


{-| -}
nineBox : Element msg
nineBox =
    nineBoxRgb255 106 110 115


{-| -}
nineBoxRgb255 : Int -> Int -> Int -> Element msg
nineBoxRgb255 r g b =
    Html.div [ style "color" (( r, g, b ) |> toCssRgb) ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            , SvgAttrs.viewBox "0 0 512 512"
            , style "vertical-align" "-0.125em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M149.333 56v80c0 13.255-10.745 24-24 24H24c-13.255 "
                        , "0-24-10.745-24-24V56c0-13.255 10.745-24 "
                        , "24-24h101.333c13.255 0 24 10.745 24 24zm181.334 "
                        , "240v-80c0-13.255-10.745-24-24-24H205.333c-13.255 "
                        , "0-24 10.745-24 24v80c0 13.255 10.745 24 24 "
                        , "24h101.333c13.256 0 24.001-10.745 "
                        , "24.001-24zm32-240v80c0 13.255 10.745 24 24 "
                        , "24H488c13.255 0 24-10.745 24-24V56c0-13.255-10.745-24-24-24H386.667c-13.255 "
                        , "0-24 10.745-24 24zm-32 80V56c0-13.255-10.745-24-24-24H205.333c-13.255 "
                        , "0-24 10.745-24 24v80c0 13.255 10.745 24 24 24h101.333c13.256 "
                        , "0 24.001-10.745 24.001-24zm-205.334 56H24c-13.255 0-24 "
                        , "10.745-24 24v80c0 13.255 10.745 24 24 24h101.333c13.255 0 "
                        , "24-10.745 24-24v-80c0-13.255-10.745-24-24-24zM0 376v80c0 "
                        , "13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 "
                        , "24-24v-80c0-13.255-10.745-24-24-24H24c-13.255 0-24 10.745-24 "
                        , "24zm386.667-56H488c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H386.667c-13.255 "
                        , "0-24 10.745-24 24v80c0 13.255 10.745 24 24 24zm0 160H488c13.255 "
                        , "0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H386.667c-13.255 "
                        , "0-24 10.745-24 24v80c0 13.255 10.745 24 24 24zM181.333 376v80c0 "
                        , "13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 "
                        , "24-24v-80c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 "
                        , "10.745-24 24z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html
