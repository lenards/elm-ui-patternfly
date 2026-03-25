module PF6.Hint exposing
    ( Hint
    , hint
    , withTitle, withActions, withFooter
    , toMarkup
    )

{-| PF6 Hint component

A contextual hint with lighter styling than an Alert. Used to provide
supplemental information or guidance without the urgency of an alert.

See: <https://www.patternfly.org/components/hint>


# Definition

@docs Hint


# Constructor

@docs hint


# Modifiers

@docs withTitle, withActions, withFooter


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Hint type
-}
type Hint msg
    = Hint (Options msg)


type alias Options msg =
    { body : String
    , title : Maybe String
    , actions : Maybe (Element msg)
    , footer : Maybe (Element msg)
    }


{-| Construct a Hint with body text

    hint "Try using the search bar to find items quickly."

-}
hint : String -> Hint msg
hint body =
    Hint
        { body = body
        , title = Nothing
        , actions = Nothing
        , footer = Nothing
        }


{-| Add a title above the hint body
-}
withTitle : String -> Hint msg -> Hint msg
withTitle t (Hint opts) =
    Hint { opts | title = Just t }


{-| Add action elements (e.g. buttons) to the hint
-}
withActions : Element msg -> Hint msg -> Hint msg
withActions el (Hint opts) =
    Hint { opts | actions = Just el }


{-| Add footer content below the hint body
-}
withFooter : Element msg -> Hint msg -> Hint msg
withFooter el (Hint opts) =
    Hint { opts | footer = Just el }


{-| Render the Hint as an `Element msg`
-}
toMarkup : Theme -> Hint msg -> Element msg
toMarkup theme (Hint opts) =
    let
        titleEl =
            opts.title
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.bold
                            , Font.size Tokens.fontSizeMd
                            , Font.color (Theme.text theme)
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none

        bodyEl =
            Element.paragraph
                [ Font.size Tokens.fontSizeMd
                , Font.color (Theme.textSubtle theme)
                ]
                [ Element.text opts.body ]

        actionsEl =
            opts.actions
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.paddingEach { top = Tokens.spacerSm, right = 0, bottom = 0, left = 0 } ]
                            el
                    )
                |> Maybe.withDefault Element.none

        footerEl =
            opts.footer
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.paddingEach { top = Tokens.spacerSm, right = 0, bottom = 0, left = 0 }
                            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                            , Border.color (Theme.borderSubtle theme)
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        [ Element.width Element.fill
        , Bg.color (Theme.backgroundSecondary theme)
        , Border.rounded Tokens.radiusMd
        , Element.padding Tokens.spacerMd
        , Element.spacing Tokens.spacerXs
        ]
        [ titleEl
        , bodyEl
        , actionsEl
        , footerEl
        ]
