module PF6.FileUpload exposing
    ( FileUpload
    , fileUpload
    , withOnClick
    , withIsDragOver
    , withFileName
    , withFileSize
    , withAccept
    , withHelperText
    , withOnClear
    , withIsDisabled
    , toMarkup
    )

{-| PF6 FileUpload component

Provides a drag-and-drop file upload zone. Actual file reading requires a port
in the consumer application. This component handles the visual UI only:
the drop zone, drag-over highlighting, selected file display, and clear button.

See: <https://www.patternfly.org/components/file-upload>


# Definition

@docs FileUpload


# Constructor

@docs fileUpload


# State modifiers

@docs withIsDragOver, withFileName, withFileSize, withIsDisabled


# Event modifiers

@docs withOnClick, withOnClear


# Display modifiers

@docs withAccept, withHelperText


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque FileUpload type
-}
type FileUpload msg
    = FileUpload (Options msg)


type alias Options msg =
    { fileName : Maybe String
    , fileSize : Maybe String
    , accept : Maybe String
    , helperText : Maybe String
    , isDragOver : Bool
    , isDisabled : Bool
    , onClick : Maybe msg
    , onClear : Maybe msg
    }


{-| Construct an empty FileUpload drop zone
-}
fileUpload : FileUpload msg
fileUpload =
    FileUpload
        { fileName = Nothing
        , fileSize = Nothing
        , accept = Nothing
        , helperText = Nothing
        , isDragOver = False
        , isDisabled = False
        , onClick = Nothing
        , onClear = Nothing
        }


{-| Set the message sent when the drop zone is clicked (open file browser)
-}
withOnClick : msg -> FileUpload msg -> FileUpload msg
withOnClick msg (FileUpload opts) =
    FileUpload { opts | onClick = Just msg }


{-| Set drag-over state (highlight drop zone while a file is dragged over it)
-}
withIsDragOver : Bool -> FileUpload msg -> FileUpload msg
withIsDragOver dragging (FileUpload opts) =
    FileUpload { opts | isDragOver = dragging }


{-| Show the selected file name
-}
withFileName : String -> FileUpload msg -> FileUpload msg
withFileName name (FileUpload opts) =
    FileUpload { opts | fileName = Just name }


{-| Show the selected file size (e.g. "2.4 MB")
-}
withFileSize : String -> FileUpload msg -> FileUpload msg
withFileSize size (FileUpload opts) =
    FileUpload { opts | fileSize = Just size }


{-| Accepted file types hint (e.g. ".jpg, .png, .gif")
-}
withAccept : String -> FileUpload msg -> FileUpload msg
withAccept accept (FileUpload opts) =
    FileUpload { opts | accept = Just accept }


{-| Helper text displayed below the drop zone
-}
withHelperText : String -> FileUpload msg -> FileUpload msg
withHelperText text (FileUpload opts) =
    FileUpload { opts | helperText = Just text }


{-| Set the message sent when the clear button is clicked
-}
withOnClear : msg -> FileUpload msg -> FileUpload msg
withOnClear msg (FileUpload opts) =
    FileUpload { opts | onClear = Just msg }


{-| Disable the file upload zone
-}
withIsDisabled : FileUpload msg -> FileUpload msg
withIsDisabled (FileUpload opts) =
    FileUpload { opts | isDisabled = True }


{-| Render the FileUpload as an `Element msg`
-}
toMarkup : Theme -> FileUpload msg -> Element msg
toMarkup theme (FileUpload opts) =
    let
        borderColor =
            if opts.isDragOver then
                Theme.primary theme

            else
                Theme.borderDefault theme

        bgColor =
            if opts.isDragOver then
                Theme.backgroundInfo theme

            else
                Theme.backgroundDefault theme

        dropZone =
            Input.button
                [ Element.width Element.fill
                , Bg.color bgColor
                , Border.rounded Tokens.radiusMd
                , Border.dashed
                , Border.width 2
                , Border.color borderColor
                , Element.padding Tokens.spacerXl
                , Element.htmlAttribute (Html.Attributes.style "cursor" "pointer")
                ]
                { onPress =
                    if opts.isDisabled then
                        Nothing

                    else
                        opts.onClick
                , label =
                    Element.column
                        [ Element.centerX
                        , Element.spacing Tokens.spacerSm
                        ]
                        [ Element.el
                            [ Element.centerX
                            , Font.size Tokens.fontSize2xl
                            , Font.color (Theme.textSubtle theme)
                            ]
                            (Element.text "⬆")
                        , Element.el
                            [ Element.centerX
                            , Font.size Tokens.fontSizeMd
                            , Font.color
                                (if opts.isDisabled then
                                    Theme.textSubtle theme

                                 else
                                    Theme.primary theme
                                )
                            ]
                            (Element.text "Drag a file here or click to browse")
                        , case opts.accept of
                            Just acceptText ->
                                Element.el
                                    [ Element.centerX
                                    , Font.size Tokens.fontSizeSm
                                    , Font.color (Theme.textSubtle theme)
                                    ]
                                    (Element.text ("Accepted: " ++ acceptText))

                            Nothing ->
                                Element.none
                        ]
                }

        fileInfo =
            case opts.fileName of
                Nothing ->
                    Element.none

                Just name ->
                    Element.row
                        [ Element.width Element.fill
                        , Bg.color (Theme.backgroundSecondary theme)
                        , Border.rounded Tokens.radiusMd
                        , Border.solid
                        , Border.width 1
                        , Border.color (Theme.borderDefault theme)
                        , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                        , Element.spacing Tokens.spacerSm
                        ]
                        [ Element.el [ Font.size Tokens.fontSizeLg, Font.color (Theme.textSubtle theme) ]
                            (Element.text "📄")
                        , Element.column [ Element.width Element.fill, Element.spacing 2 ]
                            [ Element.el
                                [ Font.size Tokens.fontSizeMd
                                , Font.color (Theme.text theme)
                                ]
                                (Element.text name)
                            , case opts.fileSize of
                                Just size ->
                                    Element.el
                                        [ Font.size Tokens.fontSizeSm
                                        , Font.color (Theme.textSubtle theme)
                                        ]
                                        (Element.text size)

                                Nothing ->
                                    Element.none
                            ]
                        , case opts.onClear of
                            Just msg ->
                                Input.button
                                    [ Font.color (Theme.textSubtle theme)
                                    , Font.size Tokens.fontSizeXl
                                    ]
                                    { onPress = Just msg
                                    , label = Element.text "×"
                                    }

                            Nothing ->
                                Element.none
                        ]

        helperEl =
            case opts.helperText of
                Just text ->
                    Element.el
                        [ Font.size Tokens.fontSizeSm
                        , Font.color (Theme.textSubtle theme)
                        ]
                        (Element.text text)

                Nothing ->
                    Element.none
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerSm
        ]
        [ dropZone
        , fileInfo
        , helperEl
        ]
