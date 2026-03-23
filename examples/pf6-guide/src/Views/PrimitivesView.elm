module Views.PrimitivesView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Avatar as Avatar
import PF6.Badge as Badge
import PF6.Button as Button
import PF6.Divider as Divider
import PF6.Icon as Icon
import PF6.Label as Label
import PF6.Title as Title
import PF6.Tokens as Tokens
import Types exposing (Model, Msg(..))


section : String -> List (Element Msg) -> Element Msg
section heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color Tokens.colorBackgroundDefault
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color Tokens.colorBorderDefault
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color Tokens.colorText ]
            (Element.text heading)
            :: items
        )


row : List (Element Msg) -> Element Msg
row items =
    Element.wrappedRow [ Element.spacing Tokens.spacerSm ] items


view : Model -> Element Msg
view model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color Tokens.colorText ]
            (Element.text "Primitives")

        -- BUTTON
        , section "Button"
            [ row
                [ Button.primary { label = "Primary", onPress = Nothing } |> Button.toMarkup
                , Button.secondary { label = "Secondary", onPress = Nothing } |> Button.toMarkup
                , Button.tertiary { label = "Tertiary", onPress = Nothing } |> Button.toMarkup
                , Button.danger { label = "Danger", onPress = Nothing } |> Button.toMarkup
                , Button.warning { label = "Warning", onPress = Nothing } |> Button.toMarkup
                , Button.link { label = "Link", onPress = Nothing } |> Button.toMarkup
                , Button.plain { label = "Plain", onPress = Nothing } |> Button.toMarkup
                ]
            , row
                [ Button.primary { label = "Large", onPress = Nothing } |> Button.withLargeSize |> Button.toMarkup
                , Button.primary { label = "Default", onPress = Nothing } |> Button.toMarkup
                , Button.primary { label = "Small", onPress = Nothing } |> Button.withSmallSize |> Button.toMarkup
                ]
            , row
                [ Button.primary { label = "With icon", onPress = Nothing }
                    |> Button.withIcon (Element.text "★")
                    |> Button.toMarkup
                , Button.secondary { label = "Icon right", onPress = Nothing }
                    |> Button.withIcon (Element.text "→")
                    |> Button.withIconRight
                    |> Button.toMarkup
                , Button.primary { label = "Disabled", onPress = Nothing }
                    |> Button.withDisabled
                    |> Button.toMarkup
                ]
            ]

        -- BADGE
        , section "Badge"
            [ row
                [ Badge.badge 7 |> Badge.toMarkup
                , Badge.unreadBadge 3 |> Badge.toMarkup
                , Badge.badge 0 |> Badge.toMarkup
                , Badge.badge 1000 |> Badge.toMarkup
                , Badge.badge 1000 |> Badge.withOverflowAt 99 |> Badge.toMarkup
                ]
            ]

        -- LABEL
        , section "Label"
            [ row
                [ Label.label "Default" |> Label.toMarkup
                , Label.label "Blue" |> Label.withBlueColor |> Label.toMarkup
                , Label.label "Green" |> Label.withGreenColor |> Label.toMarkup
                , Label.label "Orange" |> Label.withOrangeColor |> Label.toMarkup
                , Label.label "Red" |> Label.withRedColor |> Label.toMarkup
                , Label.label "Purple" |> Label.withPurpleColor |> Label.toMarkup
                , Label.label "Cyan" |> Label.withCyanColor |> Label.toMarkup
                , Label.label "Gold" |> Label.withGoldColor |> Label.toMarkup
                ]
            , row
                [ Label.label "Outline" |> Label.withOutline |> Label.withBlueColor |> Label.toMarkup
                , Label.label "Compact" |> Label.withCompact |> Label.withGreenColor |> Label.toMarkup
                , Label.label "Closable" |> Label.withBlueColor |> Label.withCloseMsg NoOp |> Label.toMarkup
                , Label.label "With icon" |> Label.withBlueColor |> Label.withIcon (Element.text "★") |> Label.toMarkup
                ]
            ]

        -- AVATAR
        , section "Avatar"
            [ row
                [ Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = "User avatar" }
                    |> Avatar.withSmallSize
                    |> Avatar.toMarkup
                , Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = "User avatar" }
                    |> Avatar.toMarkup
                , Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = "User avatar" }
                    |> Avatar.withLargeSize
                    |> Avatar.toMarkup
                , Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = "User avatar" }
                    |> Avatar.withLargeSize
                    |> Avatar.withBorder
                    |> Avatar.toMarkup
                ]
            ]

        -- ICON
        , section "Icon"
            [ row
                [ Icon.icon (Element.text "★") |> Icon.toMarkup
                , Icon.icon (Element.text "✓") |> Icon.withSuccessStatus |> Icon.toMarkup
                , Icon.icon (Element.text "✕") |> Icon.withDangerStatus |> Icon.toMarkup
                , Icon.icon (Element.text "⚠") |> Icon.withWarningStatus |> Icon.toMarkup
                , Icon.icon (Element.text "ℹ") |> Icon.withInfoStatus |> Icon.toMarkup
                ]
            , row
                [ Icon.icon (Element.text "◉") |> Icon.withSmallSize |> Icon.toMarkup
                , Icon.icon (Element.text "◉") |> Icon.withMediumSize |> Icon.toMarkup
                , Icon.icon (Element.text "◉") |> Icon.withLargeSize |> Icon.toMarkup
                , Icon.icon (Element.text "◉") |> Icon.withXLargeSize |> Icon.toMarkup
                ]
            ]

        -- TITLE
        , section "Title"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Title.title "Heading level 1" |> Title.withH1 |> Title.toMarkup
                , Title.title "Heading level 2" |> Title.withH2 |> Title.toMarkup
                , Title.title "Heading level 3" |> Title.withH3 |> Title.toMarkup
                , Title.title "Heading level 4" |> Title.withH4 |> Title.toMarkup
                , Title.title "Heading level 5" |> Title.withH5 |> Title.toMarkup
                , Title.title "Heading level 6" |> Title.withH6 |> Title.toMarkup
                ]
            ]

        -- DIVIDER
        , section "Divider"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Element.text "Above divider"
                , Divider.divider |> Divider.toMarkup
                , Element.text "Below divider"
                , Divider.divider |> Divider.withInsetMd |> Divider.toMarkup
                , Element.text "With medium inset"
                ]
            ]
        ]


