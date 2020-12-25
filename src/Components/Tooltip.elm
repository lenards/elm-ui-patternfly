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
    10.2


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


triangleShape : Position -> Element msg
triangleShape direction =
    let
        ( dir, pos, ( xp, yp ) ) =
            case direction of
                Top ->
                    ( "left", "bottom", ( "-50%", "50%" ) )

                Right ->
                    ( "top", "left", ( "-50%", "-50%" ) )

                Bottom ->
                    ( "left", "top", ( "-50%", "-50%" ) )

                Left ->
                    ( "top", "right", ( "50%", "-50%" ) )

        translateAttr xp_ yp_ =
            Element.htmlAttribute
                (style
                    "transform"
                    ("translateX("
                        ++ xp_
                        ++ ") translateY("
                        ++ yp_
                        ++ ") rotate(45deg)"
                    )
                )

        directionAttr dir_ =
            Element.htmlAttribute
                (style dir_ "50%")

        absoluteAttr pos_ =
            Element.htmlAttribute
                (style pos_ "0")
    in
    Element.el
        [ Bg.color <| Element.rgb255 21 21 21
        , Element.width <| Element.px 20
        , Element.height <| Element.px 20
        , Element.htmlAttribute
            (style "position" "absolute")
        , translateAttr xp yp
        , directionAttr dir
        , absoluteAttr pos
        , Element.centerY
        ]
        Element.none


determinePlacement :
    Tooltip
    ->
        { direction : Element.Attr decorative msg
        , centerAxis : Element.Attribute msg
        , parentEl :
            List (Element.Attribute msg)
            -> Element msg
        }
determinePlacement (Tooltip options) =
    let
        triangleEl pos =
            Element.el
                [ Element.htmlAttribute
                    (style "position" "relative")
                ]
                (triangleShape pos)

        bodyEl attrs =
            Element.el attrs <| Element.text options.text
    in
    case options.position of
        Top ->
            { direction = Element.moveUp options.moveOffset
            , centerAxis = Element.centerX
            , parentEl =
                \attrs ->
                    Element.column [] <|
                        [ bodyEl attrs
                        , triangleEl Top
                        ]
            }

        Right ->
            { direction = Element.moveRight options.moveOffset
            , centerAxis = Element.centerY
            , parentEl =
                \attrs ->
                    Element.row [] <|
                        [ triangleEl Right
                        , bodyEl attrs
                        ]
            }

        Bottom ->
            { direction = Element.moveDown options.moveOffset
            , centerAxis = Element.centerX
            , parentEl =
                \attrs ->
                    Element.column [] <|
                        [ triangleEl Bottom
                        , bodyEl attrs
                        ]
            }

        Left ->
            { direction = Element.moveLeft options.moveOffset
            , centerAxis = Element.centerY
            , parentEl =
                \attrs ->
                    Element.row [] <|
                        [ bodyEl attrs
                        , triangleEl Left
                        ]
            }


tooltipContent : Tooltip -> Element msg
tooltipContent (Tooltip options) =
    let
        { direction, centerAxis, parentEl } =
            determinePlacement (Tooltip options)

        attrs_ =
            [ Bg.color options.background
            , Font.color options.foreground
            , Element.padding 16
            , Border.rounded 5
            , Font.size 14
            , Border.shadow
                { offset = ( 0, 3 )
                , blur = 6
                , size = 0
                , color = Element.rgba 0 0 0 0.32
                }
            ]
    in
    Element.el
        [ direction, centerAxis ]
        (parentEl attrs_)


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
