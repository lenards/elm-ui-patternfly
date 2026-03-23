module PF6.Drawer exposing
    ( Drawer, Position
    , drawer
    , withPanel, withPanelHead, withPanelBody, withPanelFooter
    , withRight, withLeft, withBottom
    , withExpanded, withInline, withResizable
    , toMarkup
    )

{-| PF6 Drawer component

Drawers are sliding panels that provide supplemental content without leaving the page.

See: <https://www.patternfly.org/components/drawer>


# Definition

@docs Drawer, Position


# Constructor

@docs drawer


# Panel content modifiers

@docs withPanel, withPanelHead, withPanelBody, withPanelFooter


# Position modifiers

@docs withRight, withLeft, withBottom


# State modifiers

@docs withExpanded, withInline, withResizable


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Drawer type
-}
type Drawer msg
    = Drawer (Options msg)


{-| Panel position
-}
type Position
    = Right
    | Left
    | Bottom


type alias Options msg =
    { mainContent : Element msg
    , panelHead : Maybe (Element msg)
    , panelBody : Maybe (Element msg)
    , panelFooter : Maybe (Element msg)
    , position : Position
    , isExpanded : Bool
    , isInline : Bool
    , isResizable : Bool
    , panelWidth : Int
    }


{-| Construct a Drawer with main content

    drawer myPageContent

-}
drawer : Element msg -> Drawer msg
drawer mainContent =
    Drawer
        { mainContent = mainContent
        , panelHead = Nothing
        , panelBody = Nothing
        , panelFooter = Nothing
        , position = Right
        , isExpanded = False
        , isInline = False
        , isResizable = False
        , panelWidth = 400
        }


{-| Set the entire panel as a single element
-}
withPanel : Element msg -> Drawer msg -> Drawer msg
withPanel el (Drawer opts) =
    Drawer { opts | panelBody = Just el }


{-| Set the panel head section
-}
withPanelHead : Element msg -> Drawer msg -> Drawer msg
withPanelHead el (Drawer opts) =
    Drawer { opts | panelHead = Just el }


{-| Set the panel body section
-}
withPanelBody : Element msg -> Drawer msg -> Drawer msg
withPanelBody el (Drawer opts) =
    Drawer { opts | panelBody = Just el }


{-| Set the panel footer section
-}
withPanelFooter : Element msg -> Drawer msg -> Drawer msg
withPanelFooter el (Drawer opts) =
    Drawer { opts | panelFooter = Just el }


{-| Panel slides in from the right (default)
-}
withRight : Drawer msg -> Drawer msg
withRight (Drawer opts) =
    Drawer { opts | position = Right }


{-| Panel slides in from the left
-}
withLeft : Drawer msg -> Drawer msg
withLeft (Drawer opts) =
    Drawer { opts | position = Left }


{-| Panel slides up from the bottom
-}
withBottom : Drawer msg -> Drawer msg
withBottom (Drawer opts) =
    Drawer { opts | position = Bottom }


{-| Expand/show the drawer panel
-}
withExpanded : Bool -> Drawer msg -> Drawer msg
withExpanded expanded (Drawer opts) =
    Drawer { opts | isExpanded = expanded }


{-| Inline mode — panel pushes main content instead of overlaying
-}
withInline : Drawer msg -> Drawer msg
withInline (Drawer opts) =
    Drawer { opts | isInline = True }


{-| Allow user to resize the panel
-}
withResizable : Drawer msg -> Drawer msg
withResizable (Drawer opts) =
    Drawer { opts | isResizable = True }


panelEl : Options msg -> Element msg
panelEl opts =
    let
        headEl =
            opts.panelHead
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding Tokens.spacerMd
                            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                            , Border.color Tokens.colorBorderDefault
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        bodyEl =
            opts.panelBody
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.height Element.fill
                            , Element.padding Tokens.spacerMd
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        footerEl =
            opts.panelFooter
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding Tokens.spacerMd
                            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                            , Border.color Tokens.colorBorderDefault
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        [ Element.width
            (if opts.position == Bottom then
                Element.fill

             else
                Element.px opts.panelWidth
            )
        , Element.height
            (if opts.position == Bottom then
                Element.px 300

             else
                Element.fill
            )
        , Bg.color Tokens.colorBackgroundDefault
        , Border.solid
        , Border.width 1
        , Border.color Tokens.colorBorderDefault
        , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
        ]
        [ headEl, bodyEl, footerEl ]


{-| Render the Drawer as an `Element msg`
-}
toMarkup : Drawer msg -> Element msg
toMarkup (Drawer opts) =
    if not opts.isExpanded then
        opts.mainContent

    else
        case opts.position of
            Right ->
                Element.row
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    ]
                    [ Element.el
                        [ Element.width Element.fill
                        , Element.height Element.fill
                        ]
                        opts.mainContent
                    , panelEl opts
                    ]

            Left ->
                Element.row
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    ]
                    [ panelEl opts
                    , Element.el
                        [ Element.width Element.fill
                        , Element.height Element.fill
                        ]
                        opts.mainContent
                    ]

            Bottom ->
                Element.column
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    ]
                    [ Element.el
                        [ Element.width Element.fill
                        , Element.height Element.fill
                        ]
                        opts.mainContent
                    , panelEl opts
                    ]
