module PF6.Page exposing
    ( Page
    , page
    , withMasthead, withSidebar, withBreadcrumb, withNotificationDrawer
    , withSidebarWidth
    , toMarkup
    )

{-| PF6 Page component

The Page component is used to define the basic layout of a page with either
vertical or horizontal navigation.

See: <https://www.patternfly.org/components/page>


# Definition

@docs Page


# Constructor

@docs page


# Layout modifiers

@docs withMasthead, withSidebar, withBreadcrumb, withNotificationDrawer


# Dimension modifiers

@docs withSidebarWidth


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import PF6.Tokens as Tokens


{-| Opaque Page type
-}
type Page msg
    = Page (Options msg)


type alias Options msg =
    { masthead : Maybe (Element msg)
    , sidebar : Maybe (Element msg)
    , breadcrumb : Maybe (Element msg)
    , mainContent : Element msg
    , notificationDrawer : Maybe (Element msg)
    , sidebarWidth : Int
    }


{-| Construct a Page with main content
-}
page : Element msg -> Page msg
page mainContent =
    Page
        { masthead = Nothing
        , sidebar = Nothing
        , breadcrumb = Nothing
        , mainContent = mainContent
        , notificationDrawer = Nothing
        , sidebarWidth = 270
        }


{-| Set the masthead (top header bar)
-}
withMasthead : Element msg -> Page msg -> Page msg
withMasthead el (Page opts) =
    Page { opts | masthead = Just el }


{-| Set the sidebar (left navigation panel)
-}
withSidebar : Element msg -> Page msg -> Page msg
withSidebar el (Page opts) =
    Page { opts | sidebar = Just el }


{-| Set a breadcrumb above the main content
-}
withBreadcrumb : Element msg -> Page msg -> Page msg
withBreadcrumb el (Page opts) =
    Page { opts | breadcrumb = Just el }


{-| Set a notification drawer (right panel)
-}
withNotificationDrawer : Element msg -> Page msg -> Page msg
withNotificationDrawer el (Page opts) =
    Page { opts | notificationDrawer = Just el }


{-| Set sidebar width in pixels (default: 270)
-}
withSidebarWidth : Int -> Page msg -> Page msg
withSidebarWidth px (Page opts) =
    Page { opts | sidebarWidth = px }


mastheadEl : Maybe (Element msg) -> Element msg
mastheadEl mEl =
    case mEl of
        Nothing ->
            Element.none

        Just el ->
            Element.el
                [ Element.width Element.fill
                , Bg.color (Element.rgb255 21 21 21)
                , Element.padding Tokens.spacerSm
                ]
                el


{-| Render the Page as an `Element msg`
-}
toMarkup : Page msg -> Element msg
toMarkup (Page opts) =
    let
        sidebarEl =
            case opts.sidebar of
                Nothing ->
                    Element.none

                Just el ->
                    Element.el
                        [ Element.width (Element.px opts.sidebarWidth)
                        , Element.height Element.fill
                        , Bg.color Tokens.colorBackgroundDefault
                        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
                        , Border.color Tokens.colorBorderDefault
                        ]
                        el

        breadcrumbEl =
            case opts.breadcrumb of
                Nothing ->
                    Element.none

                Just el ->
                    Element.el
                        [ Element.width Element.fill
                        , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                        , Border.color Tokens.colorBorderDefault
                        ]
                        el

        notificationEl =
            case opts.notificationDrawer of
                Nothing ->
                    Element.none

                Just el ->
                    Element.el
                        [ Element.width (Element.px 300)
                        , Element.height Element.fill
                        , Bg.color Tokens.colorBackgroundDefault
                        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 1 }
                        , Border.color Tokens.colorBorderDefault
                        ]
                        el

        mainArea =
            Element.column
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
                [ breadcrumbEl
                , Element.el
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    , Element.padding Tokens.spacerMd
                    , Bg.color Tokens.colorBackgroundSecondary
                    ]
                    opts.mainContent
                ]

        bodyRow =
            Element.row
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
                [ sidebarEl
                , mainArea
                , notificationEl
                ]
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ mastheadEl opts.masthead
        , bodyRow
        ]
