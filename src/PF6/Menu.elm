module PF6.Menu exposing
    ( Menu, MenuItem
    , menu
    , menuItem, menuDivider, menuHeader
    , withItemIcon, withItemDescription, withItemSelected, withItemDisabled, withItemDanger
    , withSearchable, withMaxHeight
    , toMarkup
    )

{-| PF6 Menu component

A generic menu primitive with items, dividers, and section headers.

See: <https://www.patternfly.org/components/menus/menu>


# Definition

@docs Menu, MenuItem


# Constructor

@docs menu


# Item constructors

@docs menuItem, menuDivider, menuHeader


# Item modifiers

@docs withItemIcon, withItemDescription, withItemSelected, withItemDisabled, withItemDanger


# Menu modifiers

@docs withSearchable, withMaxHeight


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Menu type
-}
type Menu msg
    = Menu (Options msg)


{-| A menu item (action, divider, or header)
-}
type MenuItem msg
    = ActionItem (ActionOptions msg)
    | DividerItem
    | HeaderItem String


type alias ActionOptions msg =
    { label : String
    , onClick : msg
    , icon : Maybe (Element msg)
    , description : Maybe String
    , isSelected : Bool
    , isDisabled : Bool
    , isDanger : Bool
    }


type alias Options msg =
    { items : List (MenuItem msg)
    , search : Maybe { placeholder : String, onChange : String -> msg }
    , maxHeight : Maybe Int
    }


{-| Construct a Menu

    menu
        [ menuItem "Edit" EditClicked
        , menuDivider
        , menuItem "Delete" DeleteClicked |> withItemDanger
        ]

-}
menu : List (MenuItem msg) -> Menu msg
menu items =
    Menu
        { items = items
        , search = Nothing
        , maxHeight = Nothing
        }


{-| Construct a menu action item
-}
menuItem : String -> msg -> MenuItem msg
menuItem label onClick =
    ActionItem
        { label = label
        , onClick = onClick
        , icon = Nothing
        , description = Nothing
        , isSelected = False
        , isDisabled = False
        , isDanger = False
        }


{-| A horizontal divider between menu items
-}
menuDivider : MenuItem msg
menuDivider =
    DividerItem


{-| A non-interactive section header
-}
menuHeader : String -> MenuItem msg
menuHeader label =
    HeaderItem label


{-| Add an icon to a menu item
-}
withItemIcon : Element msg -> MenuItem msg -> MenuItem msg
withItemIcon icon item =
    case item of
        ActionItem opts ->
            ActionItem { opts | icon = Just icon }

        _ ->
            item


{-| Add a description line below the item label
-}
withItemDescription : String -> MenuItem msg -> MenuItem msg
withItemDescription desc item =
    case item of
        ActionItem opts ->
            ActionItem { opts | description = Just desc }

        _ ->
            item


{-| Mark a menu item as selected (shows a check indicator)
-}
withItemSelected : MenuItem msg -> MenuItem msg
withItemSelected item =
    case item of
        ActionItem opts ->
            ActionItem { opts | isSelected = True }

        _ ->
            item


{-| Disable a menu item
-}
withItemDisabled : MenuItem msg -> MenuItem msg
withItemDisabled item =
    case item of
        ActionItem opts ->
            ActionItem { opts | isDisabled = True }

        _ ->
            item


{-| Mark a menu item as danger (red text)
-}
withItemDanger : MenuItem msg -> MenuItem msg
withItemDanger item =
    case item of
        ActionItem opts ->
            ActionItem { opts | isDanger = True }

        _ ->
            item


{-| Add a search input at the top of the menu
-}
withSearchable : String -> (String -> msg) -> Menu msg -> Menu msg
withSearchable placeholder onChange (Menu opts) =
    Menu { opts | search = Just { placeholder = placeholder, onChange = onChange } }


{-| Set a maximum height in pixels (enables scrolling)
-}
withMaxHeight : Int -> Menu msg -> Menu msg
withMaxHeight h (Menu opts) =
    Menu { opts | maxHeight = Just h }


renderActionItem : Theme -> ActionOptions msg -> Element msg
renderActionItem theme opts =
    let
        textColor =
            if opts.isDisabled then
                Theme.textSubtle theme

            else if opts.isDanger then
                Theme.danger theme

            else
                Theme.text theme

        checkEl =
            if opts.isSelected then
                Element.el
                    [ Font.color (Theme.primary theme)
                    , Element.width (Element.px 20)
                    ]
                    (Element.text "\u{2713}")

            else
                Element.el [ Element.width (Element.px 20) ] Element.none

        iconEl =
            opts.icon
                |> Maybe.map
                    (\ic ->
                        Element.el [ Element.width (Element.px 20), Element.centerY ] ic
                    )
                |> Maybe.withDefault Element.none

        labelEl =
            Element.column [ Element.spacing 2 ]
                [ Element.el
                    [ Font.size Tokens.fontSizeMd
                    , Font.color textColor
                    ]
                    (Element.text opts.label)
                , opts.description
                    |> Maybe.map
                        (\d ->
                            Element.el
                                [ Font.size Tokens.fontSizeSm
                                , Font.color (Theme.textSubtle theme)
                                ]
                                (Element.text d)
                        )
                    |> Maybe.withDefault Element.none
                ]

        hoverAttrs =
            if opts.isDisabled then
                []

            else
                [ Element.mouseOver [ Bg.color (Theme.backgroundSecondary theme) ] ]
    in
    Input.button
        ([ Element.width Element.fill
         , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
         ]
            ++ hoverAttrs
        )
        { onPress =
            if opts.isDisabled then
                Nothing

            else
                Just opts.onClick
        , label =
            Element.row [ Element.spacing Tokens.spacerSm ]
                [ checkEl, iconEl, labelEl ]
        }


renderItem : Theme -> MenuItem msg -> Element msg
renderItem theme item =
    case item of
        ActionItem opts ->
            renderActionItem theme opts

        DividerItem ->
            Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 1)
                , Bg.color (Theme.borderDefault theme)
                ]
                Element.none

        HeaderItem label ->
            Element.el
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerXs
                , Font.size Tokens.fontSizeSm
                , Font.bold
                , Font.color (Theme.textSubtle theme)
                ]
                (Element.text (String.toUpper label))


{-| Render the Menu as an `Element msg`
-}
toMarkup : Theme -> Menu msg -> Element msg
toMarkup theme (Menu opts) =
    let
        searchEl =
            opts.search
                |> Maybe.map
                    (\s ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.paddingXY Tokens.spacerSm Tokens.spacerSm
                            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                            , Border.color (Theme.borderSubtle theme)
                            ]
                            (Input.text
                                [ Element.width Element.fill
                                , Border.rounded Tokens.radiusMd
                                , Border.solid
                                , Border.width 1
                                , Border.color (Theme.borderDefault theme)
                                , Element.padding Tokens.spacerSm
                                , Font.size Tokens.fontSizeMd
                                ]
                                { onChange = s.onChange
                                , text = ""
                                , placeholder =
                                    Just
                                        (Input.placeholder
                                            [ Font.color (Theme.textSubtle theme) ]
                                            (Element.text s.placeholder)
                                        )
                                , label = Input.labelHidden "Search"
                                }
                            )
                    )
                |> Maybe.withDefault Element.none

        itemsEl =
            Element.column
                [ Element.width Element.fill ]
                (List.map (renderItem theme) opts.items)

        maxHeightAttr =
            opts.maxHeight
                |> Maybe.map
                    (\h ->
                        [ Element.htmlAttribute (Html.Attributes.style "max-height" (String.fromInt h ++ "px"))
                        , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                        ]
                    )
                |> Maybe.withDefault []
    in
    Element.column
        ([ Element.width (Element.minimum 200 Element.fill)
         , Bg.color (Theme.backgroundDefault theme)
         , Border.solid
         , Border.width 1
         , Border.color (Theme.borderDefault theme)
         , Border.rounded Tokens.radiusMd
         , Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 0.25rem 0.5rem rgba(3,3,3,0.12)")
         , Element.paddingXY 0 Tokens.spacerXs
         ]
            ++ maxHeightAttr
        )
        [ searchEl
        , itemsEl
        ]
