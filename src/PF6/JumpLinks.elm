module PF6.JumpLinks exposing
    ( JumpLinks, JumpLink
    , jumpLinks
    , link, subsectionLink
    , withVertical, withCentered, withSticky
    , withLabel
    , toMarkup
    )

{-| PF6 JumpLinks component

Jump links allow users to navigate to sections of a page by clicking anchors
in a vertical (or horizontal) list. Useful for long-form pages with multiple
named sections.

See: <https://www.patternfly.org/components/jump-links>


# Definition

@docs JumpLinks, JumpLink


# Constructor

@docs jumpLinks


# Link constructors

@docs link, subsectionLink


# Layout modifiers

@docs withVertical, withCentered, withSticky


# Label

@docs withLabel


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque JumpLinks type
-}
type JumpLinks msg
    = JumpLinks (Options msg)


{-| A single jump link item (may contain subsection links)
-}
type JumpLink msg
    = JumpLink (LinkOptions msg)


type alias LinkOptions msg =
    { label : String
    , href : String
    , isActive : Bool
    , onClick : Maybe msg
    , subsections : List (JumpLink msg)
    }


type Layout
    = Vertical


type alias Options msg =
    { links : List (JumpLink msg)
    , layout : Layout
    , isCentered : Bool
    , isSticky : Bool
    , label : Maybe String
    }


{-| Construct a JumpLinks component from a list of links

    jumpLinks
        [ link "Section 1" "#section-1" |> withActive
        , link "Section 2" "#section-2"
        , link "Section 3" "#section-3"
        ]

-}
jumpLinks : List (JumpLink msg) -> JumpLinks msg
jumpLinks links =
    JumpLinks
        { links = links
        , layout = Vertical
        , isCentered = False
        , isSticky = False
        , label = Nothing
        }


{-| Construct a jump link

    link "Getting started" "#getting-started"

-}
link : String -> String -> JumpLink msg
link label href =
    JumpLink
        { label = label
        , href = href
        , isActive = False
        , onClick = Nothing
        , subsections = []
        }


{-| Construct a jump link with subsection links

    subsectionLink "Overview"
        "#overview"
        [ link "Introduction" "#intro"
        , link "Quick start" "#quick-start"
        ]

-}
subsectionLink : String -> String -> List (JumpLink msg) -> JumpLink msg
subsectionLink label href children =
    JumpLink
        { label = label
        , href = href
        , isActive = False
        , onClick = Nothing
        , subsections = children
        }


{-| Vertical layout (default) — links stacked top to bottom
-}
withVertical : JumpLinks msg -> JumpLinks msg
withVertical (JumpLinks opts) =
    JumpLinks { opts | layout = Vertical }


{-| Center the links horizontally (applies mainly to horizontal layout)
-}
withCentered : JumpLinks msg -> JumpLinks msg
withCentered (JumpLinks opts) =
    JumpLinks { opts | isCentered = True }


{-| Sticky positioning — the nav stays visible while the page scrolls
-}
withSticky : JumpLinks msg -> JumpLinks msg
withSticky (JumpLinks opts) =
    JumpLinks { opts | isSticky = True }


{-| Add a heading label above the links
-}
withLabel : String -> JumpLinks msg -> JumpLinks msg
withLabel l (JumpLinks opts) =
    JumpLinks { opts | label = Just l }


renderSubLink : JumpLink msg -> Element msg
renderSubLink (JumpLink opts) =
    Element.el
        [ Element.paddingEach { top = Tokens.spacerXs, right = 0, bottom = Tokens.spacerXs, left = Tokens.spacerLg }
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
        , Border.color
            (if opts.isActive then
                Tokens.colorPrimary

             else
                Tokens.colorBorderDefault
            )
        ]
        (Element.link
            [ Font.size Tokens.fontSizeSm
            , Font.color
                (if opts.isActive then
                    Tokens.colorPrimary

                 else
                    Tokens.colorTextSubtle
                )
            ]
            { url = opts.href
            , label = Element.text opts.label
            }
        )


renderLink : Layout -> JumpLink msg -> Element msg
renderLink layout (JumpLink opts) =
    let
        linkEl =
            Element.el
                [ Element.paddingXY
                    (case layout of
                        Vertical ->
                            Tokens.spacerMd
                    )
                    Tokens.spacerSm
                , Border.widthEach
                    (case layout of
                        Vertical ->
                            { top = 0, right = 0, bottom = 0, left = 3 }
                    )
                , Border.color
                    (if opts.isActive then
                        Tokens.colorPrimary

                     else
                        Element.rgba 0 0 0 0
                    )
                ]
                (Element.link
                    [ Font.size Tokens.fontSizeMd
                    , Font.color
                        (if opts.isActive then
                            Tokens.colorPrimary

                         else
                            Tokens.colorText
                        )
                    , if opts.isActive then
                        Font.bold

                      else
                        Font.regular
                    ]
                    { url = opts.href
                    , label = Element.text opts.label
                    }
                )
    in
    case layout of
        Vertical ->
            Element.column [ Element.width Element.fill ]
                (linkEl :: List.map renderSubLink opts.subsections)


{-| Render the JumpLinks as an `Element msg`

Links use `Element.link` to produce `<a href>` anchors. For in-page
navigation to work, the target sections must have matching `id` attributes
set via `Element.htmlAttribute (Html.Attributes.id "section-name")`.

-}
toMarkup : JumpLinks msg -> Element msg
toMarkup (JumpLinks opts) =
    let
        container =
            case opts.layout of
                Vertical ->
                    Element.column
                        [ Element.spacing 0
                        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 1 }
                        , Border.color Tokens.colorBorderDefault
                        , Bg.color Tokens.colorBackgroundDefault
                        ]
    in
    Element.column
        [ Element.spacing Tokens.spacerSm ]
        [ case opts.label of
            Just l ->
                Element.el
                    [ Font.bold
                    , Font.size Tokens.fontSizeSm
                    , Font.color Tokens.colorTextSubtle
                    , Element.paddingEach { bottom = Tokens.spacerXs, top = 0, left = Tokens.spacerMd, right = 0 }
                    ]
                    (Element.text (String.toUpper l))

            Nothing ->
                Element.none
        , container (List.map (renderLink opts.layout) opts.links)
        ]
