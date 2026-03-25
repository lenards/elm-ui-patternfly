module Views.PrimitivesView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Avatar as Avatar
import PF6.Badge as Badge
import PF6.Brand as Brand
import PF6.Button as Button
import PF6.Divider as Divider
import PF6.Icon as Icon
import PF6.Label as Label
import PF6.NotificationBadge as NotificationBadge
import PF6.Theme as Theme exposing (Theme)
import PF6.Timestamp as Timestamp
import PF6.Title as Title
import PF6.Tokens as Tokens
import PF6.Truncate as Truncate
import Types exposing (Model, Msg(..))


section : Theme -> String -> List (Element Msg) -> Element Msg
section theme heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color (Theme.backgroundDefault theme)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color (Theme.text theme) ]
            (Element.text heading)
            :: items
        )


row : List (Element Msg) -> Element Msg
row items =
    Element.wrappedRow [ Element.spacing Tokens.spacerSm ] items


view : Model -> Element Msg
view model =
    let
        theme =
            Theme.fromMode model.themeMode
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color (Theme.text theme) ]
            (Element.text "Primitives")

        -- BUTTON
        , section theme
            "Button"
            [ row
                [ Button.primary { label = "Primary", onPress = Nothing } |> Button.toMarkup theme
                , Button.secondary { label = "Secondary", onPress = Nothing } |> Button.toMarkup theme
                , Button.tertiary { label = "Tertiary", onPress = Nothing } |> Button.toMarkup theme
                , Button.danger { label = "Danger", onPress = Nothing } |> Button.toMarkup theme
                , Button.warning { label = "Warning", onPress = Nothing } |> Button.toMarkup theme
                , Button.link { label = "Link", onPress = Nothing } |> Button.toMarkup theme
                , Button.plain { label = "Plain", onPress = Nothing } |> Button.toMarkup theme
                ]
            , row
                [ Button.primary { label = "Large", onPress = Nothing } |> Button.withLargeSize |> Button.toMarkup theme
                , Button.primary { label = "Default", onPress = Nothing } |> Button.toMarkup theme
                , Button.primary { label = "Small", onPress = Nothing } |> Button.withSmallSize |> Button.toMarkup theme
                ]
            , row
                [ Button.primary { label = "With icon", onPress = Nothing }
                    |> Button.withIcon (Element.text "★")
                    |> Button.toMarkup theme
                , Button.secondary { label = "Icon right", onPress = Nothing }
                    |> Button.withIcon (Element.text "→")
                    |> Button.withIconRight
                    |> Button.toMarkup theme
                , Button.primary { label = "Disabled", onPress = Nothing }
                    |> Button.withDisabled
                    |> Button.toMarkup theme
                ]
            ]

        -- BADGE
        , section theme
            "Badge"
            [ row
                [ Badge.badge 7 |> Badge.toMarkup theme
                , Badge.unreadBadge 3 |> Badge.toMarkup theme
                , Badge.badge 0 |> Badge.toMarkup theme
                , Badge.badge 1000 |> Badge.toMarkup theme
                , Badge.badge 1000 |> Badge.withOverflowAt 99 |> Badge.toMarkup theme
                ]
            ]

        -- LABEL
        , section theme
            "Label"
            [ row
                [ Label.label "Default" |> Label.toMarkup theme
                , Label.label "Blue" |> Label.withBlueColor |> Label.toMarkup theme
                , Label.label "Green" |> Label.withGreenColor |> Label.toMarkup theme
                , Label.label "Orange" |> Label.withOrangeColor |> Label.toMarkup theme
                , Label.label "Red" |> Label.withRedColor |> Label.toMarkup theme
                , Label.label "Purple" |> Label.withPurpleColor |> Label.toMarkup theme
                , Label.label "Cyan" |> Label.withCyanColor |> Label.toMarkup theme
                , Label.label "Gold" |> Label.withGoldColor |> Label.toMarkup theme
                ]
            , row
                [ Label.label "Outline" |> Label.withOutline |> Label.withBlueColor |> Label.toMarkup theme
                , Label.label "Compact" |> Label.withCompact |> Label.withGreenColor |> Label.toMarkup theme
                , Label.label "Closable" |> Label.withBlueColor |> Label.withCloseMsg NoOp |> Label.toMarkup theme
                , Label.label "With icon" |> Label.withBlueColor |> Label.withIcon (Element.text "★") |> Label.toMarkup theme
                ]
            ]

        -- AVATAR
        , section theme
            "Avatar"
            [ row
                [ Avatar.avatar { src = "avatar.svg", alt = "User avatar" }
                    |> Avatar.withSmallSize
                    |> Avatar.toMarkup theme
                , Avatar.avatar { src = "avatar.svg", alt = "User avatar" }
                    |> Avatar.toMarkup theme
                , Avatar.avatar { src = "avatar.svg", alt = "User avatar" }
                    |> Avatar.withLargeSize
                    |> Avatar.toMarkup theme
                , Avatar.avatar { src = "avatar.svg", alt = "User avatar" }
                    |> Avatar.withLargeSize
                    |> Avatar.withBorder
                    |> Avatar.toMarkup theme
                ]
            ]

        -- ICON
        , section theme
            "Icon"
            [ row
                [ Icon.icon (Element.text "★") |> Icon.toMarkup theme
                , Icon.icon (Element.text "✓") |> Icon.withSuccessStatus |> Icon.toMarkup theme
                , Icon.icon (Element.text "✕") |> Icon.withDangerStatus |> Icon.toMarkup theme
                , Icon.icon (Element.text "⚠") |> Icon.withWarningStatus |> Icon.toMarkup theme
                , Icon.icon (Element.text "ℹ") |> Icon.withInfoStatus |> Icon.toMarkup theme
                ]
            , row
                [ Icon.icon (Element.text "◉") |> Icon.withSmallSize |> Icon.toMarkup theme
                , Icon.icon (Element.text "◉") |> Icon.withMediumSize |> Icon.toMarkup theme
                , Icon.icon (Element.text "◉") |> Icon.withLargeSize |> Icon.toMarkup theme
                , Icon.icon (Element.text "◉") |> Icon.withXLargeSize |> Icon.toMarkup theme
                ]
            ]

        -- TITLE
        , section theme
            "Title"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Title.title "Heading level 1" |> Title.withH1 |> Title.toMarkup theme
                , Title.title "Heading level 2" |> Title.withH2 |> Title.toMarkup theme
                , Title.title "Heading level 3" |> Title.withH3 |> Title.toMarkup theme
                , Title.title "Heading level 4" |> Title.withH4 |> Title.toMarkup theme
                , Title.title "Heading level 5" |> Title.withH5 |> Title.toMarkup theme
                , Title.title "Heading level 6" |> Title.withH6 |> Title.toMarkup theme
                ]
            ]

        -- DIVIDER
        , section theme
            "Divider"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Element.text "Above divider"
                , Divider.divider |> Divider.toMarkup theme
                , Element.text "Below divider"
                , Divider.divider |> Divider.withInsetMd |> Divider.toMarkup theme
                , Element.text "With medium inset"
                ]
            ]

        -- BRAND
        , section theme
            "Brand"
            [ row
                [ Brand.brand { src = "https://www.patternfly.org/images/pf-c-brand--logo.svg", alt = "PatternFly" }
                    |> Brand.withHeight 36
                    |> Brand.toMarkup theme
                , Brand.brand { src = "https://www.patternfly.org/images/pf-c-brand--logo.svg", alt = "PatternFly large" }
                    |> Brand.withHeight 48
                    |> Brand.withWidth 200
                    |> Brand.toMarkup theme
                ]
            ]

        -- NOTIFICATION BADGE
        , section theme
            "NotificationBadge"
            [ row
                [ NotificationBadge.notificationBadge { count = 5, onClick = NotificationToggled }
                    |> NotificationBadge.withExpanded model.notificationExpanded
                    |> NotificationBadge.toMarkup theme
                , NotificationBadge.notificationBadge { count = 0, onClick = NoOp }
                    |> NotificationBadge.withRead
                    |> NotificationBadge.toMarkup theme
                , NotificationBadge.notificationBadge { count = 12, onClick = NoOp }
                    |> NotificationBadge.withAttentionVariant
                    |> NotificationBadge.toMarkup theme
                , NotificationBadge.notificationBadge { count = 150, onClick = NoOp }
                    |> NotificationBadge.toMarkup theme
                ]
            ]

        -- TIMESTAMP
        , section theme
            "Timestamp"
            [ row
                [ Timestamp.timestamp "Jan 1, 2024, 12:00 PM"
                    |> Timestamp.toMarkup theme
                , Timestamp.timestamp "Mar 15, 2024"
                    |> Timestamp.withIcon
                    |> Timestamp.toMarkup theme
                , Timestamp.timestamp "2024-03-15T14:30:00Z"
                    |> Timestamp.withTooltip "March 15, 2024 at 2:30 PM UTC"
                    |> Timestamp.withCustomIcon (Element.text "\u{1F4C5}")
                    |> Timestamp.toMarkup theme
                ]
            ]

        -- TRUNCATE
        , section theme
            "Truncate"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Truncate.truncate "This is a very long text string that should be truncated at the end"
                    |> Truncate.withMaxChars 30
                    |> Truncate.toMarkup theme
                , Truncate.truncate "This is a long text that gets truncated in the middle to show both ends"
                    |> Truncate.withMaxChars 30
                    |> Truncate.withMiddleTruncation
                    |> Truncate.toMarkup theme
                , Truncate.truncate "Short text"
                    |> Truncate.withMaxChars 30
                    |> Truncate.toMarkup theme
                ]
            ]
        ]
