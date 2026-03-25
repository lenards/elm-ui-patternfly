module PF6.ExpandableSection exposing
    ( ExpandableSection
    , expandableSection
    , withToggleText, withToggleTextCollapsed, withDetached
    , withWidth
    , toMarkup
    )

{-| PF6 ExpandableSection component

Expandable sections toggle the visibility of content.

See: <https://www.patternfly.org/components/expandable-section>


# Definition

@docs ExpandableSection


# Constructor

@docs expandableSection


# Modifiers

@docs withToggleText, withToggleTextCollapsed, withDetached


# Width

@docs withWidth


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque ExpandableSection type
-}
type ExpandableSection msg
    = ExpandableSection (Options msg)


type alias Options msg =
    { body : Element msg
    , isExpanded : Bool
    , onToggle : Bool -> msg
    , toggleTextExpanded : String
    , toggleTextCollapsed : String
    , isDetached : Bool
    , width : Element.Length
    }


{-| Construct an ExpandableSection

    expandableSection
        { body = Element.text "Hidden content here..."
        , isExpanded = model.expanded
        , onToggle = SetExpanded
        }

-}
expandableSection :
    { body : Element msg
    , isExpanded : Bool
    , onToggle : Bool -> msg
    }
    -> ExpandableSection msg
expandableSection config =
    ExpandableSection
        { body = config.body
        , isExpanded = config.isExpanded
        , onToggle = config.onToggle
        , toggleTextExpanded = "Show less"
        , toggleTextCollapsed = "Show more"
        , isDetached = False
        , width = Element.fill
        }


{-| Set the toggle button text when expanded
-}
withToggleText : String -> ExpandableSection msg -> ExpandableSection msg
withToggleText t (ExpandableSection opts) =
    ExpandableSection { opts | toggleTextExpanded = t }


{-| Set the toggle button text when collapsed
-}
withToggleTextCollapsed : String -> ExpandableSection msg -> ExpandableSection msg
withToggleTextCollapsed t (ExpandableSection opts) =
    ExpandableSection { opts | toggleTextCollapsed = t }


{-| Detached mode — toggle button is separate from the content
-}
withDetached : ExpandableSection msg -> ExpandableSection msg
withDetached (ExpandableSection opts) =
    ExpandableSection { opts | isDetached = True }


{-| Set explicit width
-}
withWidth : Element.Length -> ExpandableSection msg -> ExpandableSection msg
withWidth w (ExpandableSection opts) =
    ExpandableSection { opts | width = w }


toggleBtn : Theme -> Options msg -> Element msg
toggleBtn theme opts =
    let
        label =
            if opts.isExpanded then
                opts.toggleTextExpanded

            else
                opts.toggleTextCollapsed

        arrow =
            if opts.isExpanded then
                "▲ "

            else
                "▼ "
    in
    Input.button
        [ Font.size Tokens.fontSizeMd
        , Font.color (Theme.primary theme)
        ]
        { onPress = Just (opts.onToggle (not opts.isExpanded))
        , label = Element.text (arrow ++ label)
        }


{-| Render the ExpandableSection as an `Element msg`
-}
toMarkup : Theme -> ExpandableSection msg -> Element msg
toMarkup theme (ExpandableSection opts) =
    Element.column
        [ Element.width opts.width
        , Element.spacing Tokens.spacerSm
        ]
        (if opts.isDetached then
            [ toggleBtn theme opts
            , if opts.isExpanded then
                opts.body

              else
                Element.none
            ]

         else
            [ if opts.isExpanded then
                opts.body

              else
                Element.none
            , toggleBtn theme opts
            ]
        )
