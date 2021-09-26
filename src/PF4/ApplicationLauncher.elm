module PF4.ApplicationLauncher exposing
    ( ApplicationLauncher
    , applicationLauncher
    , withActiveMenu
    , toMarkup
    )

{-| A component for encapsulating a utility menu allowing an individual to
launch the items in a new browser window.


# Definition

@docs ApplicationLauncher


# Constructor function

@docs applicationLauncher


# Configuration function(s)

@docs withActiveMenu


# Rendering element

@docs toMarkup

<https://www.patternfly.org/v4/components/application-launcher>

-}

import Element exposing (Element)
import Element.Events as Events
import PF4.Icons as Icons
import PF4.Menu as Menu exposing (Menu)


{-| Opaque `ApplicationLauncher` element that can produce `msg` messages
-}
type ApplicationLauncher msg
    = AppLauncher (Options msg)


type ElementId
    = None
    | Id_ String


type alias Options msg =
    { id : ElementId
    , onSelect : String -> msg
    , onToggle : msg
    , isOpen : Bool
    , menu : Menu msg
    }


{-| Construacts an `ApplicationLauncher` from the arguements
-}
applicationLauncher :
    { id : String
    , items : List { itemId : String, label : String }
    , onItemSelect : String -> msg
    , onClick : msg
    }
    -> ApplicationLauncher msg
applicationLauncher args =
    let
        menu =
            Menu.menu
                { id = args.id
                , items = args.items
                , onPressItem = args.onItemSelect
                }
    in
    AppLauncher
        { id = Id_ args.id
        , menu = menu
        , onSelect = args.onItemSelect
        , onToggle = args.onClick
        , isOpen = False
        }


{-| Configures the active menu identifier.

If the `id` of this element equals what `menuId` passed in, then the
launcher's menu will _pop_ open.

This has a `with` prefix but it's more of a setter.

NOTE: this PF4 component more to using `toMarkupFor` and an opaque
state when rendering.

Future Me apologizes in advance ...

-}
withActiveMenu : String -> ApplicationLauncher msg -> ApplicationLauncher msg
withActiveMenu menuId (AppLauncher options) =
    let
        updatedMenu =
            options.menu |> Menu.withActiveId menuId

        hasMenuOpen =
            options.menu |> Menu.isOpen
    in
    AppLauncher
        { options
            | menu = updatedMenu
            , isOpen = hasMenuOpen
        }


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : ApplicationLauncher msg -> Element msg
toMarkup (AppLauncher options) =
    Element.column
        [ Events.onClick options.onToggle ]
        [ Icons.nineBox
        , options.menu
            |> Menu.toMarkup
        ]
