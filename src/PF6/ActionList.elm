module PF6.ActionList exposing
    ( ActionList, ActionItem
    , actionList
    , actionItem, cancelItem, iconItem
    , withIcons, withIcons15em
    , toMarkup
    )

{-| PF6 ActionList component

An action list is a group of actions, controls, or buttons with set spacing.

See: <https://www.patternfly.org/components/action-list>


# Definition

@docs ActionList, ActionItem


# Constructor

@docs actionList


# Item constructors

@docs actionItem, cancelItem, iconItem


# Variant modifiers

@docs withIcons, withIcons15em


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import PF6.Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque ActionList type
-}
type ActionList msg
    = ActionList (Options msg)


{-| An action list item
-}
type ActionItem msg
    = ActionItem (Element msg)


type alias Options msg =
    { items : List (ActionItem msg)
    , isIcons : Bool
    , isIcons15em : Bool
    }


{-| Construct an ActionList from items
-}
actionList : List (ActionItem msg) -> ActionList msg
actionList items =
    ActionList
        { items = items
        , isIcons = False
        , isIcons15em = False
        }


{-| Wrap any element as an action item
-}
actionItem : Element msg -> ActionItem msg
actionItem el =
    ActionItem el


{-| A cancel-style action item (slightly separated)
-}
cancelItem : Element msg -> ActionItem msg
cancelItem el =
    ActionItem el


{-| An icon-only action item
-}
iconItem : Element msg -> ActionItem msg
iconItem el =
    ActionItem el


{-| Icons layout — smaller spacing for icon-only buttons
-}
withIcons : ActionList msg -> ActionList msg
withIcons (ActionList opts) =
    ActionList { opts | isIcons = True }


{-| Icons with 1.5em spacing
-}
withIcons15em : ActionList msg -> ActionList msg
withIcons15em (ActionList opts) =
    ActionList { opts | isIcons15em = True }


{-| Render the ActionList as an `Element msg`
-}
toMarkup : Theme -> ActionList msg -> Element msg
toMarkup _ (ActionList opts) =
    let
        spacing =
            if opts.isIcons || opts.isIcons15em then
                Tokens.spacerXs

            else
                Tokens.spacerSm
    in
    Element.row
        [ Element.spacing spacing ]
        (List.map (\(ActionItem el) -> el) opts.items)
