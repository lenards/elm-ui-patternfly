module PF6.HelperText exposing
    ( HelperText, Variant
    , helperText
    , withDefault, withError, withWarning, withSuccess, withIndeterminate
    , withIcon, withDynamic
    , toMarkup
    )

{-| PF6 HelperText component

Helper text provides contextual information below form controls.

See: <https://www.patternfly.org/components/helper-text>


# Definition

@docs HelperText, Variant


# Constructor

@docs helperText


# Variant modifiers

@docs withDefault, withError, withWarning, withSuccess, withIndeterminate


# Content modifiers

@docs withIcon, withDynamic


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque HelperText type
-}
type HelperText msg
    = HelperText (Options msg)


{-| Helper text variant
-}
type Variant
    = Default
    | Error
    | Warning
    | Success
    | Indeterminate


type alias Options msg =
    { items : List (HelperItem msg) }


type HelperItem msg
    = HelperItem
        { text : String
        , variant : Variant
        , icon : Maybe (Element msg)
        , isDynamic : Bool
        }


{-| Construct a HelperText with a single message
-}
helperText : String -> HelperText msg
helperText text =
    HelperText
        { items =
            [ HelperItem
                { text = text
                , variant = Default
                , icon = Nothing
                , isDynamic = False
                }
            ]
        }


applyToLast : (HelperItem msg -> HelperItem msg) -> HelperText msg -> HelperText msg
applyToLast f (HelperText opts) =
    let
        updated =
            case List.reverse opts.items of
                [] ->
                    []

                last :: rest ->
                    List.reverse (f last :: rest)
    in
    HelperText { opts | items = updated }


{-| Default (gray) variant
-}
withDefault : HelperText msg -> HelperText msg
withDefault =
    applyToLast (\(HelperItem i) -> HelperItem { i | variant = Default })


{-| Error (red) variant
-}
withError : HelperText msg -> HelperText msg
withError =
    applyToLast (\(HelperItem i) -> HelperItem { i | variant = Error })


{-| Warning (yellow) variant
-}
withWarning : HelperText msg -> HelperText msg
withWarning =
    applyToLast (\(HelperItem i) -> HelperItem { i | variant = Warning })


{-| Success (green) variant
-}
withSuccess : HelperText msg -> HelperText msg
withSuccess =
    applyToLast (\(HelperItem i) -> HelperItem { i | variant = Success })


{-| Indeterminate (loading) variant
-}
withIndeterminate : HelperText msg -> HelperText msg
withIndeterminate =
    applyToLast (\(HelperItem i) -> HelperItem { i | variant = Indeterminate })


{-| Add an icon to the last item
-}
withIcon : Element msg -> HelperText msg -> HelperText msg
withIcon icon =
    applyToLast (\(HelperItem i) -> HelperItem { i | icon = Just icon })


{-| Mark the last item as dynamic (for screen reader live regions)
-}
withDynamic : HelperText msg -> HelperText msg
withDynamic =
    applyToLast (\(HelperItem i) -> HelperItem { i | isDynamic = True })


variantColor : Theme -> Variant -> Element.Color
variantColor theme variant =
    case variant of
        Default ->
            Theme.textSubtle theme

        Error ->
            Theme.danger theme

        Warning ->
            Theme.warning theme

        Success ->
            Theme.success theme

        Indeterminate ->
            Theme.info theme


renderItem : Theme -> HelperItem msg -> Element msg
renderItem theme (HelperItem i) =
    let
        color =
            variantColor theme i.variant

        iconEl =
            i.icon
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Font.color color
                            , Element.paddingEach { top = 0, right = Tokens.spacerXs, bottom = 0, left = 0 }
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none
    in
    Element.row
        [ Font.size Tokens.fontSizeSm
        , Font.color color
        , Element.spacing Tokens.spacerXs
        ]
        [ iconEl
        , Element.text i.text
        ]


{-| Render the HelperText as an `Element msg`
-}
toMarkup : Theme -> HelperText msg -> Element msg
toMarkup theme (HelperText opts) =
    Element.column
        [ Element.spacing Tokens.spacerXs ]
        (List.map (renderItem theme) opts.items)
