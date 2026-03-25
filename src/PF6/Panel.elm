module PF6.Panel exposing
    ( Panel
    , panel
    , withHeader, withFooter, withRaised, withBordered, withScrollable
    , toMarkup
    )

{-| PF6 Panel component

A simple bordered container for grouping content.

See: <https://www.patternfly.org/components/panel>


# Definition

@docs Panel


# Constructor

@docs panel


# Modifiers

@docs withHeader, withFooter, withRaised, withBordered, withScrollable


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Panel type
-}
type Panel msg
    = Panel (Options msg)


type alias Options msg =
    { body : Element msg
    , header : Maybe (Element msg)
    , footer : Maybe (Element msg)
    , raised : Bool
    , bordered : Bool
    , scrollable : Bool
    }


{-| Construct a Panel with body content

    panel (Element.text "Panel content")

-}
panel : Element msg -> Panel msg
panel body =
    Panel
        { body = body
        , header = Nothing
        , footer = Nothing
        , raised = False
        , bordered = False
        , scrollable = False
        }


{-| Add a header above the panel body
-}
withHeader : Element msg -> Panel msg -> Panel msg
withHeader el (Panel opts) =
    Panel { opts | header = Just el }


{-| Add a footer below the panel body
-}
withFooter : Element msg -> Panel msg -> Panel msg
withFooter el (Panel opts) =
    Panel { opts | footer = Just el }


{-| Add a raised box shadow to the panel
-}
withRaised : Panel msg -> Panel msg
withRaised (Panel opts) =
    Panel { opts | raised = True }


{-| Add a visible border to the panel
-}
withBordered : Panel msg -> Panel msg
withBordered (Panel opts) =
    Panel { opts | bordered = True }


{-| Make the panel body scrollable
-}
withScrollable : Panel msg -> Panel msg
withScrollable (Panel opts) =
    Panel { opts | scrollable = True }


{-| Render the Panel as an `Element msg`
-}
toMarkup : Theme -> Panel msg -> Element msg
toMarkup theme (Panel opts) =
    let
        borderAttrs =
            if opts.bordered then
                [ Border.solid
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                ]

            else
                []

        shadowAttrs =
            if opts.raised then
                [ Element.htmlAttribute
                    (Html.Attributes.style "box-shadow"
                        "0 0.25rem 0.5rem 0rem rgba(3,3,3,0.12), 0 0 0.25rem 0 rgba(3,3,3,0.06)"
                    )
                ]

            else
                []

        scrollAttrs =
            if opts.scrollable then
                [ Element.scrollbarY
                , Element.height (Element.maximum 300 Element.fill)
                ]

            else
                []

        headerEl =
            opts.header
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding Tokens.spacerMd
                            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                            , Border.color (Theme.borderSubtle theme)
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        bodyEl =
            Element.el
                ([ Element.width Element.fill
                 , Element.padding Tokens.spacerMd
                 ]
                    ++ scrollAttrs
                )
                opts.body

        footerEl =
            opts.footer
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding Tokens.spacerMd
                            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                            , Border.color (Theme.borderSubtle theme)
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        ([ Element.width Element.fill
         , Bg.color (Theme.backgroundDefault theme)
         , Border.rounded Tokens.radiusMd
         ]
            ++ borderAttrs
            ++ shadowAttrs
        )
        [ headerEl
        , bodyEl
        , footerEl
        ]
