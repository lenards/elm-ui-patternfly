module PF6.Navigation exposing
    ( Navigation, NavItem, NavGroup
    , navigation
    , navItem, navGroup
    , withHorizontal, withHorizontalScrollable
    , withDark
    , toMarkup
    )

{-| PF6 Navigation component

Navigation links users to other parts of the application.

See: <https://www.patternfly.org/components/navigation>


# Definition

@docs Navigation, NavItem, NavGroup


# Constructor

@docs navigation


# Item constructors

@docs navItem, navGroup


# Variant modifiers

@docs withHorizontal, withHorizontalScrollable


# Theme modifiers

@docs withDark


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Navigation type
-}
type Navigation msg
    = Navigation (Options msg)


{-| A single navigation item
-}
type NavItem msg
    = NavLink { label : String, href : String, isActive : Bool }
    | NavGroupItem (NavGroup msg)


{-| A group of navigation items with a section header
-}
type NavGroup msg
    = NavGroup { title : String, items : List (NavItem msg) }


type Orientation
    = Vertical
    | Horizontal
    | HorizontalScrollable


type alias Options msg =
    { items : List (NavItem msg)
    , orientation : Orientation
    , isDark : Bool
    }


{-| Construct a Navigation component
-}
navigation : List (NavItem msg) -> Navigation msg
navigation items =
    Navigation
        { items = items
        , orientation = Vertical
        , isDark = False
        }


{-| Create a nav link item
-}
navItem : { label : String, href : String, isActive : Bool } -> NavItem msg
navItem config =
    NavLink config


{-| Create a nav group with a title
-}
navGroup : { title : String, items : List (NavItem msg) } -> NavItem msg
navGroup config =
    NavGroupItem (NavGroup config)


{-| Horizontal orientation
-}
withHorizontal : Navigation msg -> Navigation msg
withHorizontal (Navigation opts) =
    Navigation { opts | orientation = Horizontal }


{-| Horizontal scrollable orientation
-}
withHorizontalScrollable : Navigation msg -> Navigation msg
withHorizontalScrollable (Navigation opts) =
    Navigation { opts | orientation = HorizontalScrollable }


{-| Dark theme
-}
withDark : Navigation msg -> Navigation msg
withDark (Navigation opts) =
    Navigation { opts | isDark = True }


renderNavItem : Theme -> Options msg -> NavItem msg -> Element msg
renderNavItem theme opts navItem_ =
    let
        textColor =
            if opts.isDark then
                Theme.textOnDark theme

            else
                Theme.text theme

        activeColor =
            Theme.primary theme

        isHorizontal =
            opts.orientation /= Vertical
    in
    case navItem_ of
        NavLink { label, isActive } ->
            Element.el
                ([ Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                 , Font.size Tokens.fontSizeMd
                 , Font.color
                    (if isActive then
                        activeColor

                     else
                        textColor
                    )
                 ]
                    ++ (if isActive && not isHorizontal then
                            [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
                            , Border.color activeColor
                            , Bg.color (Element.rgba255 0 102 204 0.1)
                            ]

                        else if isActive then
                            [ Border.widthEach { top = 0, right = 0, bottom = 3, left = 0 }
                            , Border.color activeColor
                            ]

                        else
                            []
                       )
                )
                (Element.text label)

        NavGroupItem (NavGroup { title, items }) ->
            Element.column
                [ Element.width Element.fill ]
                [ Element.el
                    [ Font.size Tokens.fontSizeSm
                    , Font.bold
                    , Font.color (Theme.textSubtle theme)
                    , Element.paddingXY Tokens.spacerMd Tokens.spacerXs
                    ]
                    (Element.text (String.toUpper title))
                , Element.column
                    [ Element.width Element.fill ]
                    (List.map (renderNavItem theme opts) items)
                ]


{-| Render the Navigation as an `Element msg`
-}
toMarkup : Theme -> Navigation msg -> Element msg
toMarkup theme (Navigation opts) =
    let
        bg =
            if opts.isDark then
                Element.rgb255 21 21 21

            else
                Theme.backgroundDefault theme

        itemEls =
            List.map (renderNavItem theme opts) opts.items
    in
    case opts.orientation of
        Vertical ->
            Element.column
                [ Element.width Element.fill
                , Bg.color bg
                ]
                itemEls

        Horizontal ->
            Element.row
                [ Element.width Element.fill
                , Bg.color bg
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderDefault theme)
                ]
                itemEls

        HorizontalScrollable ->
            Element.row
                [ Element.width Element.fill
                , Bg.color bg
                , Element.scrollbarX
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderDefault theme)
                ]
                itemEls
