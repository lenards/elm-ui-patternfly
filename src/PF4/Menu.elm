module PF4.Menu exposing (..)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events


{-| Opaque `Menu` element that can produce `msg` messages
-}
type Menu msg
    = Menu (Options msg)


type alias Options msg =
    { id : MenuId
    , activeMenu : MenuId
    , items : List (MenuItem msg)
    , selectedItem : Maybe (MenuItem msg)
    , position : Position
    , backgroundColor : Element.Color
    , onMouseEnter : Maybe msg
    , onMouseLeave : Maybe msg
    }


type MenuId
    = None
    | Id_ String


type Position
    = Above
    | Below


type MenuItem msg
    = MenuItem ( Int, ItemOptions msg )


type alias ItemOptions msg =
    { itemId : String
    , name : String
    , onPress : Maybe msg
    }


menu :
    { id : String
    , items : List { itemId : String, label : String }
    , onPressItem : String -> msg
    }
    -> Menu msg
menu args =
    let
        menuItems =
            args.items
                |> List.indexedMap Tuple.pair
                |> List.map
                    (\( idx, { itemId, label } ) ->
                        MenuItem
                            ( idx
                            , { itemId = itemId
                              , name = label
                              , onPress =
                                    Just (args.onPressItem itemId)
                              }
                            )
                    )
    in
    Menu
        { id = Id_ args.id
        , activeMenu = None
        , items = menuItems
        , selectedItem = Nothing
        , position = Below
        , onMouseEnter = Nothing
        , onMouseLeave = Nothing
        , backgroundColor = Element.rgb255 255 255 255
        }


withId : String -> Menu msg -> Menu msg
withId rawId (Menu options) =
    Menu { options | id = Id_ rawId }


withActiveId : String -> Menu msg -> Menu msg
withActiveId rawId (Menu options) =
    Menu { options | activeMenu = Id_ rawId }


withOnMouseEnter : msg -> Menu msg -> Menu msg
withOnMouseEnter msg (Menu options) =
    Menu { options | onMouseEnter = Just msg }


withOnMouseLeave : msg -> Menu msg -> Menu msg
withOnMouseLeave msg (Menu options) =
    Menu { options | onMouseLeave = Just msg }


withBackgroundColor : Element.Color -> Menu msg -> Menu msg
withBackgroundColor bgColor (Menu options) =
    Menu { options | backgroundColor = bgColor }


withPositionAbove : Menu msg -> Menu msg
withPositionAbove (Menu options) =
    Menu <| setPosition Above options


withPositionBelow : Menu msg -> Menu msg
withPositionBelow (Menu options) =
    Menu <| setPosition Below options


setPosition : Position -> Options msg -> Options msg
setPosition newPosition options =
    { options | position = newPosition }


isOpen : Menu msg -> Bool
isOpen (Menu options) =
    options.id == options.activeMenu


itemMarkup : Options msg -> MenuItem msg -> Element msg
itemMarkup _ (MenuItem ( _, itemOptions )) =
    let
        rowAttrs =
            [ Element.width Element.fill
            , Element.paddingXY 16 8
            , Element.mouseOver
                [ Background.color <| Element.rgb255 240 240 240 ]
            , Element.pointer
            ]

        attrs_ =
            [ Element.alignLeft ]
    in
    Element.row rowAttrs [ Element.el attrs_ <| Element.text itemOptions.name ]


andAppend : Maybe a -> (a -> b) -> List b -> List b
andAppend maybe func list =
    maybe
        |> Maybe.map (\a -> func a :: list)
        |> Maybe.withDefault list


menuMarkup : Options msg -> Element msg
menuMarkup options =
    let
        menuPositionF =
            case options.position of
                Above ->
                    Element.above

                Below ->
                    Element.below

        combineAttrs_ =
            menuPositionF menuEl

        menuAttrs_ =
            [ Background.color options.backgroundColor
            , Border.glow
                (Element.rgba255 3 3 3 0.12)
                3
            , Element.paddingXY 0 12
            ]
                |> andAppend
                    options.onMouseEnter
                    Events.onMouseEnter
                |> andAppend
                    options.onMouseLeave
                    Events.onMouseLeave

        menuEl =
            Element.column menuAttrs_ itemsEl

        attrs_ =
            [ Element.inFront (Element.el [ combineAttrs_ ] Element.none)
            ]

        itemsEl =
            options.items
                |> List.map (itemMarkup options)
    in
    Element.el attrs_ <| Element.none


toMarkup : Menu msg -> Element msg
toMarkup (Menu options) =
    -- if options.id is None - what should we do?
    if options.id == options.activeMenu then
        menuMarkup options

    else
        Element.none
