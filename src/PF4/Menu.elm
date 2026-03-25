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
    = Below


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


withActiveId : String -> Menu msg -> Menu msg
withActiveId rawId (Menu options) =
    Menu { options | activeMenu = Id_ rawId }


isOpen : Menu msg -> Bool
isOpen (Menu options) =
    options.id == options.activeMenu


itemMarkup : MenuItem msg -> Element msg
itemMarkup (MenuItem ( _, itemOptions )) =
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
                |> List.map itemMarkup
    in
    Element.el attrs_ <| Element.none


toMarkup : Menu msg -> Element msg
toMarkup (Menu options) =
    -- if options.id is None - what should we do?
    if options.id == options.activeMenu then
        menuMarkup options

    else
        Element.none
