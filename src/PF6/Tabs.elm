module PF6.Tabs exposing
    ( Tabs, Tab, Variant
    , tabs
    , tab, withTabIcon, withTabDisabled
    , withBox, withVertical, withFilled
    , withSecondary
    , toMarkup
    )

{-| PF6 Tabs component

Tabs allow users to navigate between views within the same context.

See: <https://www.patternfly.org/components/tabs>


# Definition

@docs Tabs, Tab, Variant


# Constructor

@docs tabs


# Tab item constructors

@docs tab, withTabIcon, withTabDisabled


# Variant modifiers

@docs withBox, withVertical, withFilled


# Secondary tabs

@docs withSecondary


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque Tabs type
-}
type Tabs msg
    = Tabs (Options msg)


{-| A single tab definition
-}
type Tab msg
    = Tab (TabOptions msg)


{-| Tab display variant
-}
type Variant
    = Default
    | Box
    | Vertical
    | Filled


type alias TabOptions msg =
    { label : String
    , key : String
    , icon : Maybe (Element msg)
    , isDisabled : Bool
    }


type alias Options msg =
    { tabs : List (Tab msg)
    , activeKey : String
    , onSelect : String -> msg
    , variant : Variant
    , isSecondary : Bool
    }


{-| Construct a Tabs component

    tabs
        { activeKey = model.activeTab
        , onSelect = TabSelected
        , tabs = [ tab "overview" "Overview", tab "details" "Details" ]
        }

-}
tabs :
    { activeKey : String
    , onSelect : String -> msg
    , tabs : List (Tab msg)
    }
    -> Tabs msg
tabs config =
    Tabs
        { tabs = config.tabs
        , activeKey = config.activeKey
        , onSelect = config.onSelect
        , variant = Default
        , isSecondary = False
        }


{-| Construct a tab with a key and label
-}
tab : String -> String -> Tab msg
tab key label =
    Tab
        { label = label
        , key = key
        , icon = Nothing
        , isDisabled = False
        }


{-| Add an icon to a tab
-}
withTabIcon : Element msg -> Tab msg -> Tab msg
withTabIcon icon (Tab opts) =
    Tab { opts | icon = Just icon }


{-| Disable a tab
-}
withTabDisabled : Tab msg -> Tab msg
withTabDisabled (Tab opts) =
    Tab { opts | isDisabled = True }


{-| Box variant — tabs have a box/card appearance
-}
withBox : Tabs msg -> Tabs msg
withBox (Tabs opts) =
    Tabs { opts | variant = Box }


{-| Vertical layout
-}
withVertical : Tabs msg -> Tabs msg
withVertical (Tabs opts) =
    Tabs { opts | variant = Vertical }


{-| Filled variant — tabs stretch to fill the width
-}
withFilled : Tabs msg -> Tabs msg
withFilled (Tabs opts) =
    Tabs { opts | variant = Filled }


{-| Secondary tabs (smaller, for sub-navigation)
-}
withSecondary : Tabs msg -> Tabs msg
withSecondary (Tabs opts) =
    Tabs { opts | isSecondary = True }


tabItemEl : Options msg -> Tab msg -> Element msg
tabItemEl opts (Tab tabOpts) =
    let
        isActive =
            tabOpts.key == opts.activeKey

        textColor =
            if tabOpts.isDisabled then
                Tokens.colorTextSubtle

            else if isActive then
                Tokens.colorPrimary

            else
                Tokens.colorText

        borderAttrs =
            if isActive then
                [ Border.widthEach { top = 0, right = 0, bottom = 3, left = 0 }
                , Border.color Tokens.colorPrimary
                ]

            else
                [ Border.widthEach { top = 0, right = 0, bottom = 3, left = 0 }
                , Border.color (Element.rgba 0 0 0 0)
                ]

        fontSize =
            if opts.isSecondary then
                Tokens.fontSizeSm

            else
                Tokens.fontSizeMd

        paddingVal =
            if opts.isSecondary then
                Element.paddingXY Tokens.spacerSm Tokens.spacerXs

            else
                Element.paddingXY Tokens.spacerMd Tokens.spacerSm

        labelContent =
            case tabOpts.icon of
                Just icon ->
                    Element.row [ Element.spacing Tokens.spacerXs ]
                        [ icon, Element.text tabOpts.label ]

                Nothing ->
                    Element.text tabOpts.label
    in
    Input.button
        ([ paddingVal
         , Font.size fontSize
         , Font.color textColor
         , Bg.color Tokens.colorBackgroundDefault
         ]
            ++ borderAttrs
        )
        { onPress =
            if tabOpts.isDisabled then
                Nothing

            else
                Just (opts.onSelect tabOpts.key)
        , label = labelContent
        }


{-| Render the Tabs as an `Element msg`
-}
toMarkup : Tabs msg -> Element msg
toMarkup (Tabs opts) =
    let
        tabEls =
            List.map (tabItemEl opts) opts.tabs

        tabRow =
            case opts.variant of
                Vertical ->
                    Element.column
                        [ Element.spacing 0
                        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
                        , Border.color Tokens.colorBorderDefault
                        ]
                        tabEls

                Filled ->
                    Element.row
                        [ Element.width Element.fill
                        , Element.spacing 0
                        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                        , Border.color Tokens.colorBorderDefault
                        ]
                        (List.map (\t -> Element.el [ Element.width Element.fill ] t) tabEls)

                _ ->
                    Element.row
                        [ Element.spacing 0
                        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                        , Border.color Tokens.colorBorderDefault
                        ]
                        tabEls
    in
    tabRow
