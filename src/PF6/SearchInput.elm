module PF6.SearchInput exposing
    ( SearchInput
    , searchInput
    , withPlaceholder, withAriaLabel
    , withSubmitMsg, withClearMsg
    , withHints
    , toMarkup
    )

{-| PF6 SearchInput component

SearchInput provides a text field for search with clear and submit actions.

See: <https://www.patternfly.org/components/search-input>


# Definition

@docs SearchInput


# Constructor

@docs searchInput


# Content modifiers

@docs withPlaceholder, withAriaLabel


# Action modifiers

@docs withSubmitMsg, withClearMsg


# Suggestions

@docs withHints


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


{-| Opaque SearchInput type
-}
type SearchInput msg
    = SearchInput (Options msg)


type alias Options msg =
    { value : String
    , onChange : String -> msg
    , placeholder : String
    , ariaLabel : String
    , onSubmit : Maybe msg
    , onClear : Maybe msg
    , hints : List String
    }


{-| Construct a SearchInput

    searchInput { value = model.query, onChange = QueryChanged }

-}
searchInput : { value : String, onChange : String -> msg } -> SearchInput msg
searchInput { value, onChange } =
    SearchInput
        { value = value
        , onChange = onChange
        , placeholder = "Search..."
        , ariaLabel = "Search"
        , onSubmit = Nothing
        , onClear = Nothing
        , hints = []
        }


{-| Set placeholder text
-}
withPlaceholder : String -> SearchInput msg -> SearchInput msg
withPlaceholder p (SearchInput opts) =
    SearchInput { opts | placeholder = p }


{-| Set accessible label
-}
withAriaLabel : String -> SearchInput msg -> SearchInput msg
withAriaLabel l (SearchInput opts) =
    SearchInput { opts | ariaLabel = l }


{-| Send a message on submit (enter key / search button click)
-}
withSubmitMsg : msg -> SearchInput msg -> SearchInput msg
withSubmitMsg msg (SearchInput opts) =
    SearchInput { opts | onSubmit = Just msg }


{-| Send a message when clear is clicked
-}
withClearMsg : msg -> SearchInput msg -> SearchInput msg
withClearMsg msg (SearchInput opts) =
    SearchInput { opts | onClear = Just msg }


{-| Show type-ahead hint strings below the input
-}
withHints : List String -> SearchInput msg -> SearchInput msg
withHints hints (SearchInput opts) =
    SearchInput { opts | hints = hints }


{-| Render the SearchInput as an `Element msg`
-}
toMarkup : Theme -> SearchInput msg -> Element msg
toMarkup theme (SearchInput opts) =
    let
        searchIcon =
            Element.el
                [ Font.color (Theme.textSubtle theme)
                , Element.paddingXY Tokens.spacerSm 0
                ]
                (Element.text "🔍")

        clearBtn =
            if String.isEmpty opts.value then
                Element.none

            else
                case opts.onClear of
                    Just msg ->
                        Input.button
                            [ Font.color (Theme.textSubtle theme)
                            , Element.paddingXY Tokens.spacerSm 0
                            ]
                            { onPress = Just msg
                            , label = Element.text "×"
                            }

                    Nothing ->
                        Element.none

        searchBtn =
            case opts.onSubmit of
                Just msg ->
                    Input.button
                        [ Bg.color (Theme.backgroundSecondary theme)
                        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 1 }
                        , Border.color (Theme.borderDefault theme)
                        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                        , Font.size Tokens.fontSizeSm
                        , Font.color (Theme.text theme)
                        ]
                        { onPress = Just msg
                        , label = Element.text "Search"
                        }

                Nothing ->
                    Element.none

        inputEl =
            Input.text
                [ Element.width Element.fill
                , Border.width 0
                , Element.padding Tokens.spacerXs
                , Font.size Tokens.fontSizeMd
                , Bg.color (Theme.backgroundDefault theme)
                ]
                { onChange = opts.onChange
                , text = opts.value
                , placeholder =
                    Just
                        (Input.placeholder
                            [ Font.color (Theme.textSubtle theme) ]
                            (Element.text opts.placeholder)
                        )
                , label = Input.labelHidden opts.ariaLabel
                }

        hintsEl =
            if List.isEmpty opts.hints || String.isEmpty opts.value then
                Element.none

            else
                Element.column
                    [ Element.width Element.fill
                    , Bg.color (Theme.backgroundDefault theme)
                    , Border.solid
                    , Border.width 1
                    , Border.color (Theme.borderDefault theme)
                    , Border.rounded Tokens.radiusMd
                    ]
                    (List.map
                        (\hint ->
                            Input.button
                                [ Element.width Element.fill
                                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                                , Font.size Tokens.fontSizeMd
                                , Font.color (Theme.text theme)
                                , Element.mouseOver [ Bg.color (Theme.backgroundSecondary theme) ]
                                ]
                                { onPress = Just (opts.onChange hint)
                                , label = Element.text hint
                                }
                        )
                        opts.hints
                    )
    in
    Element.column
        [ Element.width Element.fill ]
        [ Element.row
            [ Element.width Element.fill
            , Border.rounded Tokens.radiusMd
            , Border.solid
            , Border.width 1
            , Border.color (Theme.borderDefault theme)
            , Bg.color (Theme.backgroundDefault theme)
            ]
            [ searchIcon
            , inputEl
            , clearBtn
            , searchBtn
            ]
        , Element.el [ Element.width Element.fill, Element.below hintsEl ] Element.none
        ]
