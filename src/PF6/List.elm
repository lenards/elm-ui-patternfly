module PF6.List exposing
    ( PFList, ListVariant
    , pFList
    , withPlain, withOrdered, withInlined, withIconed
    , withLarge
    , toMarkup
    )

{-| PF6 List component

Lists display items in a simple list format with optional styling.

See: <https://www.patternfly.org/components/list>


# Definition

@docs PFList, ListVariant


# Constructor

@docs pFList


# Variant modifiers

@docs withPlain, withOrdered, withInlined, withIconed


# Size modifiers

@docs withLarge


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque PFList type

Named PFList to avoid conflict with Elm's built-in List type.

-}
type PFList msg
    = PFList (Options msg)


{-| List display variant
-}
type ListVariant
    = Bulleted
    | Ordered
    | Plain
    | Inlined
    | Iconed


type alias Options msg =
    { items : List (Element msg)
    , variant : ListVariant
    , isLarge : Bool
    }


{-| Construct a List from items

    pFList [ Element.text "First", Element.text "Second" ]

-}
pFList : List (Element msg) -> PFList msg
pFList items =
    PFList
        { items = items
        , variant = Bulleted
        , isLarge = False
        }


{-| Plain list — no bullets, no indentation
-}
withPlain : PFList msg -> PFList msg
withPlain (PFList opts) =
    PFList { opts | variant = Plain }


{-| Ordered (numbered) list
-}
withOrdered : PFList msg -> PFList msg
withOrdered (PFList opts) =
    PFList { opts | variant = Ordered }


{-| Inline list — items displayed in a row
-}
withInlined : PFList msg -> PFList msg
withInlined (PFList opts) =
    PFList { opts | variant = Inlined }


{-| Icon list — items prefixed with icons
-}
withIconed : PFList msg -> PFList msg
withIconed (PFList opts) =
    PFList { opts | variant = Iconed }


{-| Large font size
-}
withLarge : PFList msg -> PFList msg
withLarge (PFList opts) =
    PFList { opts | isLarge = True }


bullet : Theme -> String -> Element msg
bullet theme b =
    Element.el
        [ Font.color (Theme.textSubtle theme)
        , Element.paddingEach { top = 0, right = Tokens.spacerXs, bottom = 0, left = 0 }
        ]
        (Element.text b)


renderBulletItem : Theme -> Bool -> Int -> Element msg -> Element msg
renderBulletItem theme isLarge _ content =
    Element.row
        [ Element.spacing Tokens.spacerXs
        , Font.size
            (if isLarge then
                Tokens.fontSizeLg

             else
                Tokens.fontSizeMd
            )
        ]
        [ bullet theme "•"
        , content
        ]


renderOrderedItem : Theme -> Bool -> Int -> Element msg -> Element msg
renderOrderedItem theme isLarge index content =
    Element.row
        [ Element.spacing Tokens.spacerXs
        , Font.size
            (if isLarge then
                Tokens.fontSizeLg

             else
                Tokens.fontSizeMd
            )
        ]
        [ bullet theme (String.fromInt (index + 1) ++ ".")
        , content
        ]


renderPlainItem : Theme -> Bool -> Element msg -> Element msg
renderPlainItem theme isLarge content =
    Element.el
        [ Font.size
            (if isLarge then
                Tokens.fontSizeLg

             else
                Tokens.fontSizeMd
            )
        , Font.color (Theme.text theme)
        ]
        content


{-| Render the PFList as an `Element msg`
-}
toMarkup : Theme -> PFList msg -> Element msg
toMarkup theme (PFList opts) =
    case opts.variant of
        Bulleted ->
            Element.column
                [ Element.spacing Tokens.spacerXs ]
                (List.indexedMap (renderBulletItem theme opts.isLarge) opts.items)

        Ordered ->
            Element.column
                [ Element.spacing Tokens.spacerXs ]
                (List.indexedMap (renderOrderedItem theme opts.isLarge) opts.items)

        Plain ->
            Element.column
                [ Element.spacing Tokens.spacerXs ]
                (List.map (renderPlainItem theme opts.isLarge) opts.items)

        Inlined ->
            Element.wrappedRow
                [ Element.spacing Tokens.spacerMd ]
                (List.map (renderPlainItem theme opts.isLarge) opts.items)

        Iconed ->
            Element.column
                [ Element.spacing Tokens.spacerXs ]
                (List.map (renderPlainItem theme opts.isLarge) opts.items)
