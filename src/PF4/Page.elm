module PF4.Page exposing (..)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import PF4.Icons as Icons
import PF4.Navigation as Navigation exposing (Navigation)



--import Element.Input as Input
--import Element.Region exposing (navigation)


type Page msg
    = Page (Options msg)


type alias Options msg =
    { header : PageHeader msg
    , sidebar : Maybe (PageSidebar msg)
    , sections : List (PageSection msg)
    }


type PageHeader msg
    = PageHeader (HeaderOptions msg)


type alias HeaderOptions msg =
    { title : String
    , onNavToggle : Maybe msg
    }


type PageSidebar msg
    = PageSidebar (SidebarOptions msg)


type alias SidebarOptions msg =
    { isOpen : Bool
    , nav : Navigation.Navigation msg
    }


type PageSection msg
    = PageSection (SectionOptions msg)


type SectionVariant
    = Default
    | Light
    | Dark
    | Darker


type alias SectionOptions msg =
    { children : List (Element msg)
    , variant : SectionVariant
    }


defaultNavToggleIcon : Element msg
defaultNavToggleIcon =
    Icons.hamburger


defaultSection : List (Element msg) -> PageSection msg
defaultSection children =
    PageSection { children = children, variant = Default }


page :
    { title : String
    , nav : Navigation msg
    , body : List (Element msg)
    }
    -> Page msg
page { title, nav, body } =
    Page
        { header =
            pageHeader title Nothing
        , sidebar =
            Just <|
                PageSidebar
                    { isOpen = True
                    , nav = nav
                    }
        , sections =
            sections body
        }


pageHeader : String -> Maybe msg -> PageHeader msg
pageHeader title toggleMsg =
    PageHeader
        { title = title
        , onNavToggle = toggleMsg
        }


sections : List (Element msg) -> List (PageSection msg)
sections elements =
    elements
        |> List.map
            (\e ->
                [ e ] |> defaultSection
            )


headerMarkup : PageHeader msg -> Element msg
headerMarkup (PageHeader options) =
    let
        attrs_ =
            [ Bg.color <| Element.rgb255 21 21 21
            , Font.color <| Element.rgb255 255 255 255
            , Element.width Element.fill
            , Element.padding 18
            ]
    in
    Element.row attrs_ <|
        [ Input.button
            [ Element.moveDown 2.0 ]
            { onPress = options.onNavToggle
            , label = defaultNavToggleIcon
            }
        , Element.el [ Element.paddingXY 8 0 ] <|
            Element.text options.title
        ]


sectionMarkup : PageSection msg -> Element msg
sectionMarkup (PageSection options) =
    let
        attrs_ =
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
    in
    Element.column attrs_ options.children


sectionsMarkup : List (PageSection msg) -> List (Element msg)
sectionsMarkup sections_ =
    sections_
        |> List.map sectionMarkup


sidebarMarkup : Maybe (PageSidebar msg) -> Element msg
sidebarMarkup maybeSidebar =
    maybeSidebar
        |> Maybe.map
            (\(PageSidebar options) ->
                if options.isOpen then
                    options.nav
                        |> Navigation.toMarkup

                else
                    Element.none
            )
        |> Maybe.withDefault Element.none


toMarkup : Page msg -> Element msg
toMarkup (Page options) =
    let
        attrs_ =
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
    in
    Element.column attrs_ <|
        [ options.header
            |> headerMarkup
        , Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ options.sidebar
                |> sidebarMarkup
            , Element.column
                [ Element.padding 10
                , Element.width Element.fill
                , Element.alignTop
                , Region.mainContent
                ]
                (options.sections
                    |> sectionsMarkup
                )
            ]
        ]
