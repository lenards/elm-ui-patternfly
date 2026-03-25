module PF6.EmptyState exposing
    ( EmptyState
    , emptyState
    , withIcon, withTitleH1, withTitleH2, withBody, withPrimaryAction, withSecondaryActions
    , withSmallSize, withLargeSize, withFullHeight
    , toMarkup
    )

{-| PF6 EmptyState component

Empty states are used when there is no data to display in a component or page.

See: <https://www.patternfly.org/components/empty-state>


# Definition

@docs EmptyState


# Constructor

@docs emptyState


# Content modifiers

@docs withIcon, withTitleH1, withTitleH2, withBody, withPrimaryAction, withSecondaryActions


# Size modifiers

@docs withSmallSize, withLargeSize, withFullHeight


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque EmptyState type
-}
type EmptyState msg
    = EmptyState (Options msg)


type Size
    = Small
    | Default
    | Large


type alias Options msg =
    { icon : Maybe (Element msg)
    , title : Maybe String
    , titleLevel : Int
    , body : Maybe String
    , primaryAction : Maybe (Element msg)
    , secondaryActions : List (Element msg)
    , size : Size
    , isFullHeight : Bool
    }


{-| Construct an EmptyState
-}
emptyState : EmptyState msg
emptyState =
    EmptyState
        { icon = Nothing
        , title = Nothing
        , titleLevel = 2
        , body = Nothing
        , primaryAction = Nothing
        , secondaryActions = []
        , size = Default
        , isFullHeight = False
        }


{-| Add an icon element
-}
withIcon : Element msg -> EmptyState msg -> EmptyState msg
withIcon el (EmptyState opts) =
    EmptyState { opts | icon = Just el }


{-| Set the title at H1 level
-}
withTitleH1 : String -> EmptyState msg -> EmptyState msg
withTitleH1 t (EmptyState opts) =
    EmptyState { opts | title = Just t, titleLevel = 1 }


{-| Set the title at H2 level (default)
-}
withTitleH2 : String -> EmptyState msg -> EmptyState msg
withTitleH2 t (EmptyState opts) =
    EmptyState { opts | title = Just t, titleLevel = 2 }


{-| Set body description text
-}
withBody : String -> EmptyState msg -> EmptyState msg
withBody b (EmptyState opts) =
    EmptyState { opts | body = Just b }


{-| Set primary action element (usually a Button)
-}
withPrimaryAction : Element msg -> EmptyState msg -> EmptyState msg
withPrimaryAction el (EmptyState opts) =
    EmptyState { opts | primaryAction = Just el }


{-| Set secondary action elements
-}
withSecondaryActions : List (Element msg) -> EmptyState msg -> EmptyState msg
withSecondaryActions els (EmptyState opts) =
    EmptyState { opts | secondaryActions = els }


{-| Small variant
-}
withSmallSize : EmptyState msg -> EmptyState msg
withSmallSize (EmptyState opts) =
    EmptyState { opts | size = Small }


{-| Large variant
-}
withLargeSize : EmptyState msg -> EmptyState msg
withLargeSize (EmptyState opts) =
    EmptyState { opts | size = Large }


{-| Fill the full height of the container
-}
withFullHeight : EmptyState msg -> EmptyState msg
withFullHeight (EmptyState opts) =
    EmptyState { opts | isFullHeight = True }


titleFontSize : Int -> Size -> Int
titleFontSize level size =
    case ( level, size ) of
        ( 1, Large ) ->
            Tokens.fontSize4xl

        ( 1, _ ) ->
            Tokens.fontSize2xl

        ( 2, Large ) ->
            Tokens.fontSize2xl

        ( 2, _ ) ->
            Tokens.fontSizeXl

        _ ->
            Tokens.fontSizeLg


{-| Render the EmptyState as an `Element msg`
-}
toMarkup : Theme -> EmptyState msg -> Element msg
toMarkup theme (EmptyState opts) =
    let
        maxWidth =
            case opts.size of
                Small ->
                    400

                Default ->
                    500

                Large ->
                    625

        heightAttrs =
            if opts.isFullHeight then
                [ Element.height Element.fill ]

            else
                []

        iconEl =
            opts.icon
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.centerX
                            , Font.size Tokens.fontSize4xl
                            , Font.color (Theme.textSubtle theme)
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        titleEl =
            opts.title
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Element.centerX
                            , Font.bold
                            , Font.size (titleFontSize opts.titleLevel opts.size)
                            , Font.color (Theme.text theme)
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none

        bodyEl =
            opts.body
                |> Maybe.map
                    (\b ->
                        Element.paragraph
                            [ Element.centerX
                            , Font.size Tokens.fontSizeMd
                            , Font.color (Theme.textSubtle theme)
                            , Element.width Element.fill
                            ]
                            [ Element.text b ]
                    )
                |> Maybe.withDefault Element.none

        primaryEl =
            opts.primaryAction |> Maybe.withDefault Element.none

        secondaryEl =
            if List.isEmpty opts.secondaryActions then
                Element.none

            else
                Element.row
                    [ Element.centerX
                    , Element.spacing Tokens.spacerSm
                    ]
                    opts.secondaryActions
    in
    Element.el
        ([ Element.width Element.fill
         , Element.centerX
         ]
            ++ heightAttrs
        )
        (Element.column
            [ Element.centerX
            , Element.centerY
            , Element.width (Element.maximum maxWidth Element.fill)
            , Element.spacing Tokens.spacerMd
            , Element.padding Tokens.spacerXl
            ]
            [ iconEl
            , titleEl
            , bodyEl
            , Element.el [ Element.centerX ] primaryEl
            , secondaryEl
            ]
        )
