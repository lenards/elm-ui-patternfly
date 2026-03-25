module PF6.Content exposing
    ( Content, HeadingLevel(..)
    , content
    , withHeading, withParagraph
    , withBulletList, withOrderedList
    , withCustom
    , withEditorial, withLarge
    , toMarkup
    )

{-| PF6 Content component

Provides PF6-styled typographic content blocks: headings, paragraphs, and lists.
Build up content with multiple `withX` calls; all items render in order.

See: <https://www.patternfly.org/components/content>


# Definition

@docs Content, HeadingLevel


# Constructor

@docs content


# Content modifiers

@docs withHeading, withParagraph
@docs withBulletList, withOrderedList
@docs withCustom


# Display modifiers

@docs withEditorial, withLarge


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Content type
-}
type Content msg
    = Content (Options msg)


{-| Heading levels H1 through H6
-}
type HeadingLevel
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6


type ContentItem msg
    = ParagraphItem String
    | HeadingItem HeadingLevel String
    | BulletListItem (List String)
    | OrderedListItem (List String)
    | CustomItem (Element msg)


type alias Options msg =
    { items : List (ContentItem msg)
    , isLarge : Bool
    , isEditorial : Bool
    }


{-| Construct an empty Content block. Add items with `withX` modifiers.
-}
content : Content msg
content =
    Content
        { items = []
        , isLarge = False
        , isEditorial = False
        }


{-| Add a heading at the given level
-}
withHeading : HeadingLevel -> String -> Content msg -> Content msg
withHeading level text (Content opts) =
    Content { opts | items = opts.items ++ [ HeadingItem level text ] }


{-| Add a paragraph of text
-}
withParagraph : String -> Content msg -> Content msg
withParagraph text (Content opts) =
    Content { opts | items = opts.items ++ [ ParagraphItem text ] }


{-| Add an unordered (bullet) list
-}
withBulletList : List String -> Content msg -> Content msg
withBulletList items (Content opts) =
    Content { opts | items = opts.items ++ [ BulletListItem items ] }


{-| Add an ordered (numbered) list
-}
withOrderedList : List String -> Content msg -> Content msg
withOrderedList items (Content opts) =
    Content { opts | items = opts.items ++ [ OrderedListItem items ] }


{-| Add a custom element
-}
withCustom : Element msg -> Content msg -> Content msg
withCustom el (Content opts) =
    Content { opts | items = opts.items ++ [ CustomItem el ] }


{-| Use larger body text (fontSizeLg instead of fontSizeMd)
-}
withLarge : Content msg -> Content msg
withLarge (Content opts) =
    Content { opts | isLarge = True }


{-| Editorial style — increases line-height and paragraph spacing for long-form reading
-}
withEditorial : Content msg -> Content msg
withEditorial (Content opts) =
    Content { opts | isEditorial = True }


headingSize : HeadingLevel -> Int
headingSize level =
    case level of
        H1 ->
            Tokens.fontSize4xl

        H2 ->
            Tokens.fontSize3xl

        H3 ->
            Tokens.fontSize2xl

        H4 ->
            Tokens.fontSizeXl

        H5 ->
            Tokens.fontSizeLg

        H6 ->
            Tokens.fontSizeMd


renderItem : Theme -> Bool -> Bool -> ContentItem msg -> Element msg
renderItem theme isLarge isEditorial item =
    let
        baseSize =
            if isLarge then
                Tokens.fontSizeLg

            else
                Tokens.fontSizeMd

        paragraphSpacing =
            if isEditorial then
                Tokens.spacerMd

            else
                Tokens.spacerSm
    in
    case item of
        HeadingItem level text ->
            Element.el
                [ Font.size (headingSize level)
                , Font.bold
                , Font.color (Theme.text theme)
                , Element.paddingEach { top = paragraphSpacing, right = 0, bottom = Tokens.spacerXs, left = 0 }
                ]
                (Element.text text)

        ParagraphItem text ->
            Element.paragraph
                [ Font.size baseSize
                , Font.color (Theme.text theme)
                , Element.paddingEach { top = 0, right = 0, bottom = paragraphSpacing, left = 0 }
                ]
                [ Element.text text ]

        BulletListItem items ->
            Element.column
                [ Element.spacing Tokens.spacerXs
                , Element.paddingEach { top = 0, right = 0, bottom = paragraphSpacing, left = Tokens.spacerMd }
                ]
                (List.map
                    (\i ->
                        Element.row [ Element.spacing Tokens.spacerSm ]
                            [ Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text "•")
                            , Element.paragraph
                                [ Font.size baseSize
                                , Font.color (Theme.text theme)
                                ]
                                [ Element.text i ]
                            ]
                    )
                    items
                )

        OrderedListItem items ->
            Element.column
                [ Element.spacing Tokens.spacerXs
                , Element.paddingEach { top = 0, right = 0, bottom = paragraphSpacing, left = Tokens.spacerMd }
                ]
                (List.indexedMap
                    (\idx i ->
                        Element.row [ Element.spacing Tokens.spacerSm ]
                            [ Element.el
                                [ Font.color (Theme.textSubtle theme)
                                , Font.size baseSize
                                ]
                                (Element.text (String.fromInt (idx + 1) ++ "."))
                            , Element.paragraph
                                [ Font.size baseSize
                                , Font.color (Theme.text theme)
                                ]
                                [ Element.text i ]
                            ]
                    )
                    items
                )

        CustomItem el ->
            el


{-| Render the Content block as an `Element msg`
-}
toMarkup : Theme -> Content msg -> Element msg
toMarkup theme (Content opts) =
    Element.column
        [ Element.width Element.fill
        , Element.spacing 0
        ]
        (List.map (renderItem theme opts.isLarge opts.isEditorial) opts.items)
