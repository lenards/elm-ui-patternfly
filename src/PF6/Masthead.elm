module PF6.Masthead exposing
    ( Masthead
    , masthead
    , withBrand, withContent, withToolbar, withInset, withSticky
    , toMarkup
    )

{-| PF6 Masthead component

A standard top header bar used for branding, navigation, and toolbar actions.

See: <https://www.patternfly.org/components/masthead>


# Definition

@docs Masthead


# Constructor

@docs masthead


# Modifiers

@docs withBrand, withContent, withToolbar, withInset, withSticky


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Masthead type
-}
type Masthead msg
    = Masthead (Options msg)


type alias Options msg =
    { brand : Maybe (Element msg)
    , content : Maybe (Element msg)
    , toolbar : Maybe (Element msg)
    , inset : Bool
    , sticky : Bool
    }


{-| Construct a Masthead

    masthead
        |> withBrand (Brand.brand { src = "/logo.svg", alt = "App" } |> Brand.toMarkup)
        |> withToolbar toolbarEl
        |> toMarkup

-}
masthead : Masthead msg
masthead =
    Masthead
        { brand = Nothing
        , content = Nothing
        , toolbar = Nothing
        , inset = False
        , sticky = False
        }


{-| Add a brand/logo element to the masthead
-}
withBrand : Element msg -> Masthead msg -> Masthead msg
withBrand el (Masthead opts) =
    Masthead { opts | brand = Just el }


{-| Add main content to the masthead (between brand and toolbar)
-}
withContent : Element msg -> Masthead msg -> Masthead msg
withContent el (Masthead opts) =
    Masthead { opts | content = Just el }


{-| Add a toolbar element to the right side of the masthead
-}
withToolbar : Element msg -> Masthead msg -> Masthead msg
withToolbar el (Masthead opts) =
    Masthead { opts | toolbar = Just el }


{-| Add horizontal inset padding
-}
withInset : Masthead msg -> Masthead msg
withInset (Masthead opts) =
    Masthead { opts | inset = True }


{-| Make the masthead sticky (fixed to top of viewport)
-}
withSticky : Masthead msg -> Masthead msg
withSticky (Masthead opts) =
    Masthead { opts | sticky = True }


{-| Render the Masthead as an `Element msg`
-}
toMarkup : Theme -> Masthead msg -> Element msg
toMarkup theme (Masthead opts) =
    let
        brandEl =
            opts.brand |> Maybe.withDefault Element.none

        contentEl =
            opts.content
                |> Maybe.map
                    (\el ->
                        Element.el [ Element.width Element.fill, Element.centerY ] el
                    )
                |> Maybe.withDefault (Element.el [ Element.width Element.fill ] Element.none)

        toolbarEl =
            opts.toolbar |> Maybe.withDefault Element.none

        padding =
            if opts.inset then
                Element.paddingXY Tokens.spacerXl Tokens.spacerSm

            else
                Element.paddingXY Tokens.spacerLg Tokens.spacerSm

        stickyAttrs =
            if opts.sticky then
                [ Element.htmlAttribute (Html.Attributes.style "position" "sticky")
                , Element.htmlAttribute (Html.Attributes.style "top" "0")
                , Element.htmlAttribute (Html.Attributes.style "z-index" "100")
                ]

            else
                []
    in
    Element.row
        ([ Element.width Element.fill
         , Bg.color (Element.rgb255 21 21 21)
         , padding
         , Element.spacing Tokens.spacerMd
         , Font.color (Theme.textOnDark theme)
         ]
            ++ stickyAttrs
        )
        [ brandEl
        , contentEl
        , toolbarEl
        ]
