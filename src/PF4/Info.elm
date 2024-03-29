module PF4.Info exposing
    ( Info
    , info
    , withTitle, withDefaultIcon
    , toMarkup
    )

{-| An informational text element

#Defintion

@docs Info


# Constructor function

@docs info


# Configuration functions

@docs withTitle, withDefaultIcon


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import PF4.Icons as Icons


{-| Opaque `Info` element that includes information text content
-}
type Info msg
    = Info (Options msg)


type alias Options msg =
    { title : Maybe String
    , text : String
    , icon : Maybe (Element msg)
    }


defaultIcon : Element msg
defaultIcon =
    Icons.info


{-| Constructs an `Info` element
-}
info : String -> Info msg
info text =
    Info
        { title = Nothing
        , text = text
        , icon = Nothing
        }


{-| Configures the `Info` element appear with title text above the content.

By default, `Info` has no title text.

-}
withTitle : String -> Info msg -> Info msg
withTitle title_ (Info options) =
    Info { options | title = Just title_ }


{-| Configures the `Info` element to appear with the default icon.

By default, `Info` will not render an icon.

-}
withDefaultIcon : Info msg -> Info msg
withDefaultIcon (Info options) =
    Info
        { options
            | icon = Just defaultIcon
        }


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Info msg -> Element msg
toMarkup (Info options) =
    let
        parentEl =
            case options.icon of
                Just icon ->
                    \attrs child ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding 4
                            ]
                            (Element.row attrs
                                [ Element.el
                                    [ Element.width <| Element.px 24
                                    , Element.centerX
                                    , Element.alignTop
                                    , Element.moveDown 15.5
                                    , Element.paddingEach
                                        { top = 0
                                        , right = 0
                                        , bottom = 0
                                        , left = 10
                                        }
                                    ]
                                    icon
                                , child
                                ]
                            )

                Nothing ->
                    \attrs child ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding 4
                            ]
                            (Element.el attrs child)

        attrs_ =
            [ Bg.color <| Element.rgb255 231 241 250
            , Border.color <| Element.rgb255 43 154 243
            , Border.solid
            , Border.widthEach
                { top = 2
                , right = 0
                , left = 0
                , bottom = 0
                }
            , Element.paddingEach
                { top = 4
                , right = 0
                , bottom = 4
                , left = 0
                }
            , Element.width Element.fill
            ]

        columnAttrs_ =
            [ Element.padding 16
            , Element.spacingXY 0 4
            , Element.width Element.fill
            , Element.alignLeft
            ]

        titleAttrs_ =
            [ Region.heading 4
            , Font.color <| Element.rgb255 0 41 82
            ]

        contentAttrs_ =
            [ Font.alignLeft ]
    in
    parentEl attrs_ <|
        Element.column columnAttrs_ <|
            [ Element.el titleAttrs_ <|
                Element.text
                    (options.title
                        |> Maybe.withDefault ""
                    )
            , Element.paragraph contentAttrs_ <|
                [ Element.text options.text ]
            ]
