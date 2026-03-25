module PF6.ToggleGroup exposing
    ( ToggleGroup, ToggleItem
    , toggleGroup, toggleItem
    , withItemIcon, withItemDisabled
    , withCompact
    , toMarkup
    )

{-| PF6 ToggleGroup component

A group of toggle buttons where one or more items can be selected.

See: <https://www.patternfly.org/components/toggle-group>


# Definition

@docs ToggleGroup, ToggleItem


# Constructors

@docs toggleGroup, toggleItem


# Item modifiers

@docs withItemIcon, withItemDisabled


# Group modifiers

@docs withCompact


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque ToggleGroup type
-}
type ToggleGroup msg
    = ToggleGroup (Options msg)


{-| Opaque ToggleItem type
-}
type ToggleItem msg
    = ToggleItem (ItemOptions msg)


type alias ItemOptions msg =
    { label : String
    , isSelected : Bool
    , onToggle : msg
    , icon : Maybe (Element msg)
    , isDisabled : Bool
    }


type alias Options msg =
    { items : List (ToggleItem msg)
    , compact : Bool
    }


{-| Construct a ToggleGroup

    toggleGroup
        { items =
            [ toggleItem { label = "Month", isSelected = True, onToggle = SetView Month }
            , toggleItem { label = "Week", isSelected = False, onToggle = SetView Week }
            ]
        }

-}
toggleGroup : { items : List (ToggleItem msg) } -> ToggleGroup msg
toggleGroup { items } =
    ToggleGroup
        { items = items
        , compact = False
        }


{-| Construct a toggle item
-}
toggleItem : { label : String, isSelected : Bool, onToggle : msg } -> ToggleItem msg
toggleItem { label, isSelected, onToggle } =
    ToggleItem
        { label = label
        , isSelected = isSelected
        , onToggle = onToggle
        , icon = Nothing
        , isDisabled = False
        }


{-| Add an icon to a toggle item
-}
withItemIcon : Element msg -> ToggleItem msg -> ToggleItem msg
withItemIcon icon (ToggleItem opts) =
    ToggleItem { opts | icon = Just icon }


{-| Disable a toggle item
-}
withItemDisabled : ToggleItem msg -> ToggleItem msg
withItemDisabled (ToggleItem opts) =
    ToggleItem { opts | isDisabled = True }


{-| Use compact styling with reduced padding
-}
withCompact : ToggleGroup msg -> ToggleGroup msg
withCompact (ToggleGroup opts) =
    ToggleGroup { opts | compact = True }


itemMarkup : Theme -> Bool -> ToggleItem msg -> Element msg
itemMarkup theme isCompact (ToggleItem opts) =
    let
        bgColor =
            if opts.isSelected then
                Theme.primary theme

            else
                Theme.backgroundDefault theme

        textColor =
            if opts.isDisabled then
                Theme.textSubtle theme

            else if opts.isSelected then
                Theme.textOnDark theme

            else
                Theme.text theme

        onPress =
            if opts.isDisabled then
                Nothing

            else
                Just opts.onToggle

        padding =
            if isCompact then
                Element.paddingXY Tokens.spacerSm Tokens.spacerXs

            else
                Element.paddingXY Tokens.spacerMd Tokens.spacerSm

        iconEl =
            opts.icon |> Maybe.withDefault Element.none

        labelContent =
            case opts.icon of
                Just _ ->
                    Element.row [ Element.spacing Tokens.spacerXs ]
                        [ iconEl, Element.text opts.label ]

                Nothing ->
                    Element.text opts.label
    in
    Input.button
        [ Bg.color bgColor
        , Font.color textColor
        , Font.size
            (if isCompact then
                Tokens.fontSizeSm

             else
                Tokens.fontSizeMd
            )
        , padding
        , Border.solid
        , Border.width 1
        , Border.color
            (if opts.isSelected then
                Theme.primary theme

             else
                Theme.borderDefault theme
            )
        ]
        { onPress = onPress
        , label = labelContent
        }


{-| Render the ToggleGroup as an `Element msg`
-}
toMarkup : Theme -> ToggleGroup msg -> Element msg
toMarkup theme (ToggleGroup opts) =
    Element.row
        [ Border.rounded Tokens.radiusMd
        , Element.clip
        ]
        (List.map (itemMarkup theme opts.compact) opts.items)
