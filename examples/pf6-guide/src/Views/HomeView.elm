module Views.HomeView exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Badge as Badge
import PF6.Button as Button
import PF6.Card as Card
import PF6.Label as Label
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens
import Types exposing (Model, Msg(..), Section(..))


sectionCard : Theme -> String -> String -> Section -> Element Msg
sectionCard theme title description section =
    Card.card
        [ Element.paragraph
            [ Font.size Tokens.fontSizeMd
            , Font.color Tokens.colorTextSubtle
            ]
            [ Element.text description ]
        , Element.el [ Element.paddingEach { top = Tokens.spacerSm, right = 0, bottom = 0, left = 0 } ]
            (Button.primary { label = "View examples", onPress = Just (NavSelected section) }
                |> Button.withSmallSize
                |> Button.toMarkup theme
            )
        ]
        |> Card.withTitle title
        |> Card.withBodyPaddingXY Tokens.spacerMd Tokens.spacerSm
        |> Card.toMarkup theme


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
        [ Element.column [ Element.spacing Tokens.spacerSm ]
            [ Element.el
                [ Font.size Tokens.fontSize4xl
                , Font.bold
                , Font.color (Theme.text theme)
                ]
                (Element.text "PatternFly 6")
            , Element.paragraph
                [ Font.size Tokens.fontSizeLg
                , Font.color (Theme.textSubtle theme)
                ]
                [ Element.text "An elm-ui implementation of the PatternFly 6 design system. "
                , Element.text "74 components, all following the builder pattern."
                ]
            , Element.row [ Element.spacing Tokens.spacerSm ]
                [ Label.label "74 components" |> Label.withBlueColor |> Label.toMarkup theme
                , Label.label "elm-ui" |> Label.withGreenColor |> Label.toMarkup theme
                , Label.label "PF6" |> Label.withPurpleColor |> Label.toMarkup theme
                , Label.label "0.19.1" |> Label.withGoldColor |> Label.toMarkup theme
                ]
            ]
        , Element.column [ Element.spacing Tokens.spacerMd ]
            [ Element.el [ Font.size Tokens.fontSizeXl, Font.bold, Font.color (Theme.text theme) ]
                (Element.text "Component sections")
            , Element.wrappedRow
                [ Element.spacing Tokens.spacerMd ]
                [ sectionCard theme "Primitives"
                    "Button, Badge, Label, Avatar, Icon, Title, Divider"
                    Primitives
                , sectionCard theme "Feedback & Status"
                    "Alert, Banner, Spinner, Skeleton, EmptyState, Progress, HelperText"
                    Feedback
                , sectionCard theme "Forms"
                    "TextInput, Checkbox, Radio, Switch, NumberInput, SearchInput, Select, Form"
                    Forms
                , sectionCard theme "Navigation"
                    "Breadcrumb, Tabs, Pagination"
                    Navigation
                , sectionCard theme "Layout"
                    "Card, Drawer, Bullseye, Stack, Split, Level, Gallery, Grid, Flex"
                    Layout
                , sectionCard theme "Overlays"
                    "Modal, Tooltip, Dropdown, Accordion, ExpandableSection"
                    Overlays
                , sectionCard theme "Content"
                    "CodeBlock, ClipboardCopy, List, DescriptionList, ActionList"
                    Content
                , sectionCard theme "Data"
                    "Table, DataList, Toolbar"
                    Data
                ]
            ]
        , Element.column [ Element.spacing Tokens.spacerSm ]
            [ Element.el [ Font.size Tokens.fontSizeXl, Font.bold, Font.color (Theme.text theme) ]
                (Element.text "Usage pattern")
            , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.text theme) ]
                [ Element.text "Every component follows the same builder pattern:" ]
            , Element.column
                [ Element.spacing Tokens.spacerXs
                , Font.family [ Font.monospace ]
                , Font.size Tokens.fontSizeSm
                , Font.color (Theme.text theme)
                , Element.padding Tokens.spacerMd
                , Element.width Element.fill
                ]
                [ Element.text "Button.primary { label = \"Save\", onPress = Just Saved }"
                , Element.text "    |> Button.withLargeSize"
                , Element.text "    |> Button.withIcon myIcon"
                , Element.text "    |> Button.toMarkup"
                ]
            ]
        ]
