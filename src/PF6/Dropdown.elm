module PF6.Dropdown exposing
    ( Dropdown, DropdownItem
    , dropdown
    , dropdownItem, dropdownDivider, dropdownHeader
    , withText, withIcon, withPlain, withDisabledToggle
    , withAlignment, withUp
    , toMarkup
    )

{-| PF6 Dropdown component

Dropdowns present a list of actions or links in a constrained space.

See: <https://www.patternfly.org/components/menus/dropdown>


# Definition

@docs Dropdown, DropdownItem


# Constructor

@docs dropdown


# Item constructors

@docs dropdownItem, dropdownDivider, dropdownHeader


# Toggle modifiers

@docs withText, withIcon, withPlain, withDisabledToggle


# Position modifiers

@docs withAlignment, withUp


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


{-| Opaque Dropdown type
-}
type Dropdown msg
    = Dropdown (Options msg)


{-| A dropdown menu item
-}
type DropdownItem msg
    = ActionItem { label : String, icon : Maybe (Element msg), onClick : msg, isDisabled : Bool }
    | DividerItem
    | HeaderItem String


type Alignment
    = Left
    | Right


type alias Options msg =
    { toggleLabel : String
    , toggleIcon : Maybe (Element msg)
    , items : List (DropdownItem msg)
    , isOpen : Bool
    , onToggle : Bool -> msg
    , isPlain : Bool
    , isDisabled : Bool
    , alignment : Alignment
    , isUp : Bool
    }


{-| Construct a Dropdown

    dropdown
        { toggleLabel = "Actions"
        , isOpen = model.dropdownOpen
        , onToggle = DropdownToggled
        , items = [ dropdownItem "Edit" Edited, dropdownItem "Delete" Deleted ]
        }

-}
dropdown :
    { toggleLabel : String
    , isOpen : Bool
    , onToggle : Bool -> msg
    , items : List (DropdownItem msg)
    }
    -> Dropdown msg
dropdown config =
    Dropdown
        { toggleLabel = config.toggleLabel
        , toggleIcon = Nothing
        , items = config.items
        , isOpen = config.isOpen
        , onToggle = config.onToggle
        , isPlain = False
        , isDisabled = False
        , alignment = Left
        , isUp = False
        }


{-| Construct a dropdown action item
-}
dropdownItem : String -> msg -> DropdownItem msg
dropdownItem label onClick =
    ActionItem
        { label = label
        , icon = Nothing
        , onClick = onClick
        , isDisabled = False
        }


{-| Dropdown section divider
-}
dropdownDivider : DropdownItem msg
dropdownDivider =
    DividerItem


{-| Dropdown section header (non-interactive)
-}
dropdownHeader : String -> DropdownItem msg
dropdownHeader label =
    HeaderItem label


{-| Set toggle label text
-}
withText : String -> Dropdown msg -> Dropdown msg
withText t (Dropdown opts) =
    Dropdown { opts | toggleLabel = t }


{-| Add an icon to the toggle
-}
withIcon : Element msg -> Dropdown msg -> Dropdown msg
withIcon el (Dropdown opts) =
    Dropdown { opts | toggleIcon = Just el }


{-| Plain toggle (no border/background)
-}
withPlain : Dropdown msg -> Dropdown msg
withPlain (Dropdown opts) =
    Dropdown { opts | isPlain = True }


{-| Disable the toggle button
-}
withDisabledToggle : Dropdown msg -> Dropdown msg
withDisabledToggle (Dropdown opts) =
    Dropdown { opts | isDisabled = True }


{-| Align menu to the right
-}
withAlignment : Dropdown msg -> Dropdown msg
withAlignment (Dropdown opts) =
    Dropdown { opts | alignment = Right }


{-| Open menu upward instead of downward
-}
withUp : Dropdown msg -> Dropdown msg
withUp (Dropdown opts) =
    Dropdown { opts | isUp = True }


toggleEl : Theme -> Options msg -> Element msg
toggleEl theme opts =
    let
        toggleAttrs =
            if opts.isPlain then
                [ Font.color (Theme.text theme)
                , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                ]

            else
                [ Font.color (Theme.text theme)
                , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                , Border.solid
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                , Border.rounded Tokens.radiusMd
                , Bg.color (Theme.backgroundDefault theme)
                ]

        chevron =
            if opts.isOpen then
                if opts.isUp then
                    "▼"

                else
                    "▲"

            else if opts.isUp then
                "▲"

            else
                "▼"

        labelContent =
            Element.row [ Element.spacing Tokens.spacerXs ]
                ([ opts.toggleIcon |> Maybe.withDefault Element.none
                 , Element.text opts.toggleLabel
                 , Element.el [ Font.size Tokens.fontSizeSm ] (Element.text chevron)
                 ]
                    |> List.filter (\_ -> True)
                )
    in
    Input.button toggleAttrs
        { onPress =
            if opts.isDisabled then
                Nothing

            else
                Just (opts.onToggle (not opts.isOpen))
        , label = labelContent
        }


renderDropdownItem : Theme -> DropdownItem msg -> Element msg
renderDropdownItem theme di =
    case di of
        ActionItem { label, icon, onClick, isDisabled } ->
            Input.button
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Font.size Tokens.fontSizeMd
                , Font.color
                    (if isDisabled then
                        Theme.textSubtle theme

                     else
                        Theme.text theme
                    )
                , Element.mouseOver [ Bg.color (Theme.backgroundSecondary theme) ]
                ]
                { onPress =
                    if isDisabled then
                        Nothing

                    else
                        Just onClick
                , label =
                    case icon of
                        Just iconEl ->
                            Element.row [ Element.spacing Tokens.spacerSm ]
                                [ iconEl, Element.text label ]

                        Nothing ->
                            Element.text label
                }

        DividerItem ->
            Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 1)
                , Bg.color (Theme.borderDefault theme)
                , Element.paddingXY 0 0
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


menuEl : Theme -> Options msg -> Element msg
menuEl theme opts =
    Element.column
        [ Element.width (Element.minimum 180 Element.fill)
        , Bg.color (Theme.backgroundDefault theme)
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        , Border.rounded Tokens.radiusMd
        , Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 0.25rem 0.5rem rgba(3,3,3,0.12)")
        , Element.htmlAttribute (Html.Attributes.style "z-index" "200")
        ]
        (List.map (renderDropdownItem theme) opts.items)


{-| Render the Dropdown as an `Element msg`
-}
toMarkup : Theme -> Dropdown msg -> Element msg
toMarkup theme (Dropdown opts) =
    let
        above =
            opts.isUp && opts.isOpen

        below =
            not opts.isUp && opts.isOpen

        menuAttrs =
            if above then
                [ Element.above (menuEl theme opts) ]

            else if below then
                [ Element.below (menuEl theme opts) ]

            else
                []
    in
    Element.el
        menuAttrs
        (toggleEl theme opts)
