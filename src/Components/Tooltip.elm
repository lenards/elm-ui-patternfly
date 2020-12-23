module Components.Tooltip exposing
    ( Tooltip
    , toMarkup
    , tooltip
    , withMoveOffset
    , withPositionBottom
    , withPositionLeft
    , withPositionRight
    , withPositionTop
    )

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (style)


type Tooltip
    = Tooltip Options


type Position
    = Top
    | Right
    | Bottom
    | Left


type alias Options =
    { text : String
    , position : Position
    , moveOffset : Float
    , background : Element.Color
    , foreground : Element.Color
    }


defaultMoveOffset : Float
defaultMoveOffset =
    8.2


tooltip : String -> Tooltip
tooltip text =
    Tooltip
        { text = text
        , position = Top
        , moveOffset = defaultMoveOffset
        , background = Element.rgb255 21 21 21
        , foreground = Element.rgb255 255 255 255
        }


withPositionTop : Tooltip -> Tooltip
withPositionTop (Tooltip options) =
    Tooltip { options | position = Top }


withPositionRight : Tooltip -> Tooltip
withPositionRight (Tooltip options) =
    Tooltip { options | position = Right }


withPositionBottom : Tooltip -> Tooltip
withPositionBottom (Tooltip options) =
    Tooltip { options | position = Bottom }


withPositionLeft : Tooltip -> Tooltip
withPositionLeft (Tooltip options) =
    Tooltip { options | position = Left }


withMoveOffset : Float -> Tooltip -> Tooltip
withMoveOffset offset (Tooltip options) =
    Tooltip { options | moveOffset = offset }


tooltipContent : Tooltip -> Element msg
tooltipContent (Tooltip options) =
    let
        direction =
            case options.position of
                Top ->
                    Element.moveUp options.moveOffset

                Right ->
                    Element.moveRight options.moveOffset

                Bottom ->
                    Element.moveDown options.moveOffset

                Left ->
                    Element.moveLeft options.moveOffset
    in
    Element.el
        [ Bg.color options.background
        , Font.color options.foreground
        , Element.padding 4
        , Border.rounded 5
        , Font.size 14
        , Border.shadow
            { offset = ( 0, 3 )
            , blur = 6
            , size = 0
            , color = Element.rgba 0 0 0 0.32
            }
        , direction
        ]
        (Element.text options.text)


noPointerEventsAttr : Element.Attribute msg
noPointerEventsAttr =
    Element.htmlAttribute (style "pointerEvents" "none")


createTooltip : (Element msg -> Element.Attribute msg) -> Element Never -> Element.Attribute msg
createTooltip convertF tooltipEl =
    Element.inFront <|
        Element.el
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.transparent True
            , Element.mouseOver [ Element.transparent False ]
            , (convertF << Element.map never) <|
                Element.el [ noPointerEventsAttr ] tooltipEl
            ]
            Element.none


toMarkup : Tooltip -> Element.Attribute msg
toMarkup ((Tooltip options) as tt) =
    let
        asNearby =
            case options.position of
                Top ->
                    Element.above

                Right ->
                    Element.onRight

                Bottom ->
                    Element.below

                Left ->
                    Element.onLeft
    in
    createTooltip
        asNearby
        (tt
            |> tooltipContent
        )
