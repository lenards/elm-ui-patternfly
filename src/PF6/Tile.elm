module PF6.Tile exposing
    ( Tile
    , tile
    , withSelected, withDisabled, withIcon, withStacked
    , toMarkup
    )

{-| PF6 Tile component

A selectable card-like tile, used for option selection in forms and wizards.

See: <https://www.patternfly.org/components/tile>


# Definition

@docs Tile


# Constructor

@docs tile


# Modifiers

@docs withSelected, withDisabled, withIcon, withStacked


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


{-| Opaque Tile type
-}
type Tile msg
    = Tile (Options msg)


type alias Options msg =
    { title : String
    , onSelect : msg
    , isSelected : Bool
    , isDisabled : Bool
    , icon : Maybe (Element msg)
    , stacked : Bool
    }


{-| Construct a Tile

    tile { title = "Option A", onSelect = SelectOption "a" }

-}
tile : { title : String, onSelect : msg } -> Tile msg
tile { title, onSelect } =
    Tile
        { title = title
        , onSelect = onSelect
        , isSelected = False
        , isDisabled = False
        , icon = Nothing
        , stacked = False
        }


{-| Mark the tile as selected
-}
withSelected : Tile msg -> Tile msg
withSelected (Tile opts) =
    Tile { opts | isSelected = True }


{-| Disable the tile
-}
withDisabled : Tile msg -> Tile msg
withDisabled (Tile opts) =
    Tile { opts | isDisabled = True }


{-| Add an icon to the tile
-}
withIcon : Element msg -> Tile msg -> Tile msg
withIcon icon (Tile opts) =
    Tile { opts | icon = Just icon }


{-| Stack icon above title (default is side-by-side)
-}
withStacked : Tile msg -> Tile msg
withStacked (Tile opts) =
    Tile { opts | stacked = True }


{-| Render the Tile as an `Element msg`
-}
toMarkup : Theme -> Tile msg -> Element msg
toMarkup theme (Tile opts) =
    let
        borderColor =
            if opts.isSelected then
                Theme.primary theme

            else
                Theme.borderDefault theme

        borderWidth =
            if opts.isSelected then
                2

            else
                1

        bgColor =
            if opts.isDisabled then
                Theme.backgroundSecondary theme

            else if opts.isSelected then
                Element.rgb255 215 235 255

            else
                Theme.backgroundDefault theme

        textColor =
            if opts.isDisabled then
                Theme.textSubtle theme

            else
                Theme.text theme

        onPress =
            if opts.isDisabled then
                Nothing

            else
                Just opts.onSelect

        iconEl =
            opts.icon
                |> Maybe.map
                    (\i ->
                        Element.el
                            [ Font.size Tokens.fontSizeXl
                            , Font.color
                                (if opts.isSelected then
                                    Theme.primary theme

                                 else
                                    Theme.textSubtle theme
                                )
                            ]
                            i
                    )
                |> Maybe.withDefault Element.none

        titleEl =
            Element.el
                [ Font.size Tokens.fontSizeMd
                , Font.bold
                , Font.color textColor
                ]
                (Element.text opts.title)

        contentEl =
            case ( opts.icon, opts.stacked ) of
                ( Just _, True ) ->
                    Element.column
                        [ Element.spacing Tokens.spacerSm
                        , Element.centerX
                        ]
                        [ iconEl, titleEl ]

                ( Just _, False ) ->
                    Element.row
                        [ Element.spacing Tokens.spacerSm
                        , Element.centerY
                        ]
                        [ iconEl, titleEl ]

                _ ->
                    titleEl
    in
    Input.button
        [ Bg.color bgColor
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width borderWidth
        , Border.color borderColor
        , Element.padding Tokens.spacerMd
        , Element.width (Element.minimum 120 Element.shrink)
        ]
        { onPress = onPress
        , label = contentEl
        }
