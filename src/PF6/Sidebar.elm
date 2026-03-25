module PF6.Sidebar exposing
    ( Sidebar
    , sidebar
    , withPanelRight, withSticky, withGutter, withPanelWidth
    , toMarkup
    )

{-| PF6 Sidebar component

A layout container with a sidebar panel and main content area.

See: <https://www.patternfly.org/components/sidebar>


# Definition

@docs Sidebar


# Constructor

@docs sidebar


# Modifiers

@docs withPanelRight, withSticky, withGutter, withPanelWidth


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html.Attributes
import PF6.Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Sidebar type
-}
type Sidebar msg
    = Sidebar (Options msg)


type alias Options msg =
    { content : Element msg
    , panel : Element msg
    , panelRight : Bool
    , sticky : Bool
    , gutter : Bool
    , panelWidth : Int
    }


{-| Construct a Sidebar layout

    sidebar
        { content = mainContent
        , panel = sidePanel
        }

-}
sidebar : { content : Element msg, panel : Element msg } -> Sidebar msg
sidebar { content, panel } =
    Sidebar
        { content = content
        , panel = panel
        , panelRight = False
        , sticky = False
        , gutter = False
        , panelWidth = 250
        }


{-| Place the panel on the right side (default is left)
-}
withPanelRight : Sidebar msg -> Sidebar msg
withPanelRight (Sidebar opts) =
    Sidebar { opts | panelRight = True }


{-| Make the panel sticky (stays visible while scrolling)
-}
withSticky : Sidebar msg -> Sidebar msg
withSticky (Sidebar opts) =
    Sidebar { opts | sticky = True }


{-| Add a gutter (gap) between the panel and content
-}
withGutter : Sidebar msg -> Sidebar msg
withGutter (Sidebar opts) =
    Sidebar { opts | gutter = True }


{-| Set the panel width in pixels
-}
withPanelWidth : Int -> Sidebar msg -> Sidebar msg
withPanelWidth w (Sidebar opts) =
    Sidebar { opts | panelWidth = w }


{-| Render the Sidebar as an `Element msg`
-}
toMarkup : Theme -> Sidebar msg -> Element msg
toMarkup _ (Sidebar opts) =
    let
        stickyAttrs =
            if opts.sticky then
                [ Element.htmlAttribute (Html.Attributes.style "position" "sticky")
                , Element.htmlAttribute (Html.Attributes.style "top" "0")
                , Element.htmlAttribute (Html.Attributes.style "align-self" "flex-start")
                ]

            else
                []

        panelEl =
            Element.el
                ([ Element.width (Element.px opts.panelWidth)
                 , Element.height Element.fill
                 ]
                    ++ stickyAttrs
                )
                opts.panel

        contentEl =
            Element.el
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
                opts.content

        spacing =
            if opts.gutter then
                Element.spacing Tokens.spacerMd

            else
                Element.spacing 0

        children =
            if opts.panelRight then
                [ contentEl, panelEl ]

            else
                [ panelEl, contentEl ]
    in
    Element.row
        [ Element.width Element.fill
        , Element.height Element.fill
        , spacing
        ]
        children
