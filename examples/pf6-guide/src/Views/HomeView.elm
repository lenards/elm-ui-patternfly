module Views.HomeView exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Badge as Badge
import PF6.Button as Button
import PF6.Card as Card
import PF6.Label as Label
import PF6.Tokens as Tokens
import Types exposing (Model, Msg(..), Section(..))


sectionCard : String -> String -> Section -> Element Msg
sectionCard title description section =
    Card.card
        [ Element.paragraph
            [ Font.size Tokens.fontSizeMd
            , Font.color Tokens.colorTextSubtle
            ]
            [ Element.text description ]
        , Element.el [ Element.paddingEach { top = Tokens.spacerSm, right = 0, bottom = 0, left = 0 } ]
            (Button.primary { label = "View examples", onPress = Just (NavSelected section) }
                |> Button.withSmallSize
                |> Button.toMarkup
            )
        ]
        |> Card.withTitle title
        |> Card.withBodyPaddingXY Tokens.spacerMd Tokens.spacerSm
        |> Card.toMarkup


view : Model -> Element Msg
view _ =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.column [ Element.spacing Tokens.spacerSm ]
            [ Element.el
                [ Font.size Tokens.fontSize4xl
                , Font.bold
                , Font.color Tokens.colorText
                ]
                (Element.text "PatternFly 6")
            , Element.paragraph
                [ Font.size Tokens.fontSizeLg
                , Font.color Tokens.colorTextSubtle
                ]
                [ Element.text "An elm-ui implementation of the PatternFly 6 design system. "
                , Element.text "59 components, all following the builder pattern."
                ]
            , Element.row [ Element.spacing Tokens.spacerSm ]
                [ Label.label "59 components" |> Label.withBlueColor |> Label.toMarkup
                , Label.label "elm-ui" |> Label.withGreenColor |> Label.toMarkup
                , Label.label "PF6" |> Label.withPurpleColor |> Label.toMarkup
                , Label.label "0.19.1" |> Label.withGoldColor |> Label.toMarkup
                ]
            ]
        , Element.column [ Element.spacing Tokens.spacerMd ]
            [ Element.el [ Font.size Tokens.fontSizeXl, Font.bold, Font.color Tokens.colorText ]
                (Element.text "Component sections")
            , Element.wrappedRow
                [ Element.spacing Tokens.spacerMd ]
                [ sectionCard "Primitives"
                    "Button, Badge, Label, Avatar, Icon, Title, Divider"
                    Primitives
                , sectionCard "Feedback & Status"
                    "Alert, Banner, Spinner, Skeleton, EmptyState, Progress, HelperText"
                    Feedback
                , sectionCard "Forms"
                    "TextInput, Checkbox, Radio, Switch, NumberInput, SearchInput, Select, Form"
                    Forms
                , sectionCard "Navigation"
                    "Breadcrumb, Tabs, Pagination"
                    Navigation
                , sectionCard "Layout"
                    "Card, Page, Drawer"
                    Layout
                , sectionCard "Overlays"
                    "Modal, Tooltip, Dropdown, Accordion, ExpandableSection"
                    Overlays
                , sectionCard "Content"
                    "CodeBlock, ClipboardCopy, List, DescriptionList, ActionList"
                    Content
                , sectionCard "Data"
                    "Table, DataList, Toolbar"
                    Data
                ]
            ]
        , Element.column [ Element.spacing Tokens.spacerSm ]
            [ Element.el [ Font.size Tokens.fontSizeXl, Font.bold, Font.color Tokens.colorText ]
                (Element.text "Usage pattern")
            , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorText ]
                [ Element.text "Every component follows the same builder pattern:" ]
            , Element.column
                [ Element.spacing Tokens.spacerXs
                , Font.family [ Font.monospace ]
                , Font.size Tokens.fontSizeSm
                , Font.color Tokens.colorText
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
