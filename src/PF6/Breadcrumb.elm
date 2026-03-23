module PF6.Breadcrumb exposing
    ( Breadcrumb, BreadcrumbItem
    , breadcrumb
    , item, currentItem, dropdownItem
    , toMarkup
    )

{-| PF6 Breadcrumb component

Breadcrumbs provide users with a sense of location within a hierarchy.

See: <https://www.patternfly.org/components/breadcrumb>


# Definition

@docs Breadcrumb, BreadcrumbItem


# Constructor

@docs breadcrumb


# Item constructors

@docs item, currentItem, dropdownItem


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque Breadcrumb type
-}
type Breadcrumb msg
    = Breadcrumb (List (BreadcrumbItem msg))


{-| A single breadcrumb item
-}
type BreadcrumbItem msg
    = LinkItem { label : String, href : String }
    | CurrentItem String
    | DropdownItem { label : String, items : List { label : String, onClick : msg } }


{-| Construct a Breadcrumb from a list of items
-}
breadcrumb : List (BreadcrumbItem msg) -> Breadcrumb msg
breadcrumb items =
    Breadcrumb items


{-| A linked breadcrumb item
-}
item : { label : String, href : String } -> BreadcrumbItem msg
item config =
    LinkItem config


{-| The current page breadcrumb (not linked)
-}
currentItem : String -> BreadcrumbItem msg
currentItem label =
    CurrentItem label


{-| A dropdown breadcrumb item
-}
dropdownItem : { label : String, items : List { label : String, onClick : msg } } -> BreadcrumbItem msg
dropdownItem config =
    DropdownItem config


separatorEl : Element msg
separatorEl =
    Element.el
        [ Font.color Tokens.colorTextSubtle
        , Element.paddingXY Tokens.spacerXs 0
        ]
        (Element.text "/")


renderItem : BreadcrumbItem msg -> Element msg
renderItem bcItem =
    case bcItem of
        LinkItem { label } ->
            Element.el
                [ Font.size Tokens.fontSizeMd
                , Font.color Tokens.colorPrimary
                ]
                (Element.text label)

        CurrentItem label ->
            Element.el
                [ Font.size Tokens.fontSizeMd
                , Font.color Tokens.colorText
                , Font.bold
                ]
                (Element.text label)

        DropdownItem { label } ->
            Element.el
                [ Font.size Tokens.fontSizeMd
                , Font.color Tokens.colorPrimary
                ]
                (Element.text (label ++ " ▾"))


{-| Render the Breadcrumb as an `Element msg`
-}
toMarkup : Breadcrumb msg -> Element msg
toMarkup (Breadcrumb items) =
    let
        withSeparators =
            items
                |> List.map renderItem
                |> List.intersperse separatorEl
    in
    Element.row
        [ Element.spacing 0
        , Element.paddingXY 0 Tokens.spacerXs
        ]
        withSeparators
