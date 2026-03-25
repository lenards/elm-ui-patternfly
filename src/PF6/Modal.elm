module PF6.Modal exposing
    ( Modal, Size
    , modal
    , withTitle, withDescription, withBody, withFooter
    , withSmallSize, withMediumSize, withLargeSize, withVariantSize
    , withCloseMsg, withNoClose
    , toMarkup
    )

{-| PF6 Modal component

Modals present information in an overlay above the main page content.

See: <https://www.patternfly.org/components/modal>


# Definition

@docs Modal, Size


# Constructor

@docs modal


# Content modifiers

@docs withTitle, withDescription, withBody, withFooter


# Size modifiers

@docs withSmallSize, withMediumSize, withLargeSize, withVariantSize


# Close behavior

@docs withCloseMsg, withNoClose


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Modal type
-}
type Modal msg
    = Modal (Options msg)


{-| Modal width size
-}
type Size
    = Small
    | Medium
    | Large
    | Custom Int


type alias Options msg =
    { title : Maybe String
    , description : Maybe String
    , body : Maybe (Element msg)
    , footer : Maybe (Element msg)
    , size : Size
    , onClose : Maybe msg
    , showClose : Bool
    }


{-| Construct a Modal
-}
modal : Modal msg
modal =
    Modal
        { title = Nothing
        , description = Nothing
        , body = Nothing
        , footer = Nothing
        , size = Medium
        , onClose = Nothing
        , showClose = True
        }


{-| Set the modal title
-}
withTitle : String -> Modal msg -> Modal msg
withTitle t (Modal opts) =
    Modal { opts | title = Just t }


{-| Set a description below the title
-}
withDescription : String -> Modal msg -> Modal msg
withDescription d (Modal opts) =
    Modal { opts | description = Just d }


{-| Set the modal body content
-}
withBody : Element msg -> Modal msg -> Modal msg
withBody el (Modal opts) =
    Modal { opts | body = Just el }


{-| Set the modal footer (usually action buttons)
-}
withFooter : Element msg -> Modal msg -> Modal msg
withFooter el (Modal opts) =
    Modal { opts | footer = Just el }


{-| Small modal (~400px)
-}
withSmallSize : Modal msg -> Modal msg
withSmallSize (Modal opts) =
    Modal { opts | size = Small }


{-| Medium modal (~600px, default)
-}
withMediumSize : Modal msg -> Modal msg
withMediumSize (Modal opts) =
    Modal { opts | size = Medium }


{-| Large modal (~900px)
-}
withLargeSize : Modal msg -> Modal msg
withLargeSize (Modal opts) =
    Modal { opts | size = Large }


{-| Custom width in pixels
-}
withVariantSize : Int -> Modal msg -> Modal msg
withVariantSize px (Modal opts) =
    Modal { opts | size = Custom px }


{-| Set the message sent when the close button or backdrop is clicked
-}
withCloseMsg : msg -> Modal msg -> Modal msg
withCloseMsg msg (Modal opts) =
    Modal { opts | onClose = Just msg }


{-| Hide the close button
-}
withNoClose : Modal msg -> Modal msg
withNoClose (Modal opts) =
    Modal { opts | showClose = False }


widthPx : Size -> Int
widthPx size =
    case size of
        Small ->
            400

        Medium ->
            600

        Large ->
            900

        Custom px ->
            px


{-| Render the Modal as an `Element msg`

The modal renders as a full-viewport overlay with a centered dialog box.
Wrap your application in a `Element.inFront (Modal.toMarkup myModal)` pattern.

-}
toMarkup : Modal msg -> Element msg
toMarkup (Modal opts) =
    let
        px =
            widthPx opts.size

        closeBtn =
            if opts.showClose then
                case opts.onClose of
                    Just msg ->
                        Input.button
                            [ Font.color Tokens.colorTextSubtle
                            , Font.size Tokens.fontSizeXl
                            , Element.alignRight
                            , Element.alignTop
                            ]
                            { onPress = Just msg
                            , label = Element.text "×"
                            }

                    Nothing ->
                        Element.none

            else
                Element.none

        titleEl =
            opts.title
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.bold
                            , Font.size Tokens.fontSizeXl
                            , Font.color Tokens.colorText
                            , Element.width Element.fill
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none

        descEl =
            opts.description
                |> Maybe.map
                    (\d ->
                        Element.paragraph
                            [ Font.size Tokens.fontSizeMd
                            , Font.color Tokens.colorTextSubtle
                            ]
                            [ Element.text d ]
                    )
                |> Maybe.withDefault Element.none

        headerEl =
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerXl Tokens.spacerMd
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color Tokens.colorBorderSubtle
                ]
                [ Element.column [ Element.width Element.fill, Element.spacing Tokens.spacerXs ]
                    [ titleEl, descEl ]
                , closeBtn
                ]

        bodyEl =
            opts.body
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding Tokens.spacerXl
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        footerEl =
            opts.footer
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.paddingXY Tokens.spacerXl Tokens.spacerMd
                            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                            , Border.color Tokens.colorBorderSubtle
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        dialog =
            Element.column
                [ Element.width (Element.px px)
                , Element.centerX
                , Element.centerY
                , Bg.color Tokens.colorBackgroundDefault
                , Border.rounded Tokens.radiusLg
                , Border.solid
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Element.htmlAttribute (Html.Attributes.style "z-index" "1001")
                , Element.htmlAttribute (Html.Attributes.style "max-height" "80vh")
                , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                ]
                [ headerEl
                , bodyEl
                , footerEl
                ]
    in
    Element.el
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.htmlAttribute (Html.Attributes.style "position" "fixed")
        , Element.htmlAttribute (Html.Attributes.style "top" "0")
        , Element.htmlAttribute (Html.Attributes.style "left" "0")
        , Element.htmlAttribute (Html.Attributes.style "z-index" "1000")
        ]
        (Element.el
            [ Element.width Element.fill
            , Element.height Element.fill
            , Bg.color (Element.rgba 0 0 0 0.5)
            ]
            dialog
        )
