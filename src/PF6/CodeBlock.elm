module PF6.CodeBlock exposing
    ( CodeBlock
    , codeBlock
    , withActions, withExpandable, withExpanded
    , toMarkup
    )

{-| PF6 CodeBlock component

Code blocks display read-only code in a formatted, accessible container.

See: <https://www.patternfly.org/components/code-block>


# Definition

@docs CodeBlock


# Constructor

@docs codeBlock


# Modifiers

@docs withActions, withExpandable, withExpanded


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque CodeBlock type
-}
type CodeBlock msg
    = CodeBlock (Options msg)


type alias Options msg =
    { code : String
    , actions : Maybe (Element msg)
    , isExpandable : Bool
    , isExpanded : Bool
    , onToggle : Maybe (Bool -> msg)
    }


{-| Construct a CodeBlock with code text
-}
codeBlock : String -> CodeBlock msg
codeBlock code =
    CodeBlock
        { code = code
        , actions = Nothing
        , isExpandable = False
        , isExpanded = False
        , onToggle = Nothing
        }


{-| Add action elements to the code block header (e.g., copy button)
-}
withActions : Element msg -> CodeBlock msg -> CodeBlock msg
withActions el (CodeBlock opts) =
    CodeBlock { opts | actions = Just el }


{-| Make the code block expandable/collapsible
-}
withExpandable : (Bool -> msg) -> CodeBlock msg -> CodeBlock msg
withExpandable onToggle (CodeBlock opts) =
    CodeBlock { opts | isExpandable = True, onToggle = Just onToggle }


{-| Set the expanded state (use with withExpandable)
-}
withExpanded : Bool -> CodeBlock msg -> CodeBlock msg
withExpanded expanded (CodeBlock opts) =
    CodeBlock { opts | isExpanded = expanded }


{-| Render the CodeBlock as an `Element msg`
-}
toMarkup : Theme -> CodeBlock msg -> Element msg
toMarkup theme (CodeBlock opts) =
    let
        headerEl =
            case opts.actions of
                Nothing ->
                    Element.none

                Just actions ->
                    Element.el
                        [ Element.width Element.fill
                        , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                        , Border.color (Theme.borderDefault theme)
                        , Bg.color (Element.rgb255 245 245 245)
                        ]
                        (Element.el [ Element.alignRight ] actions)

        expandToggle =
            case ( opts.isExpandable, opts.onToggle ) of
                ( True, Just onToggle ) ->
                    Element.el
                        [ Element.width Element.fill
                        , Element.paddingXY Tokens.spacerMd Tokens.spacerXs
                        , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                        , Border.color (Theme.borderDefault theme)
                        , Bg.color (Element.rgb255 245 245 245)
                        ]
                        (Input.button
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.primary theme)
                            ]
                            { onPress = Just (onToggle (not opts.isExpanded))
                            , label =
                                Element.text
                                    (if opts.isExpanded then
                                        "▲ Collapse"

                                     else
                                        "▼ Expand"
                                    )
                            }
                        )

                _ ->
                    Element.none

        codeLines =
            if opts.isExpandable && not opts.isExpanded then
                opts.code
                    |> String.lines
                    |> List.take 3
                    |> String.join "\n"

            else
                opts.code

        codeEl =
            Element.el
                [ Element.width Element.fill
                , Element.padding Tokens.spacerMd
                , Font.family [ Font.monospace ]
                , Font.size Tokens.fontSizeSm
                , Font.color (Theme.text theme)
                , Element.scrollbarX
                ]
                (Element.text codeLines)
    in
    Element.column
        [ Element.width Element.fill
        , Bg.color (Element.rgb255 250 250 250)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        [ headerEl
        , codeEl
        , expandToggle
        ]
