module Views.ContentView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.ActionList as ActionList
import PF6.Button as Button
import PF6.ClipboardCopy as ClipboardCopy
import PF6.CodeBlock as CodeBlock
import PF6.Content as Content
import PF6.DescriptionList as DescriptionList
import PF6.List as PFList
import PF6.LoginPage as LoginPage
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens
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
            (Element.text "Content")

        -- CODE BLOCK
        , section theme
            "CodeBlock"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ CodeBlock.codeBlock "$ elm make src/Main.elm --output=main.js\nSuccessfully compiled Main.elm"
                    |> CodeBlock.toMarkup theme
                , CodeBlock.codeBlock "module Hello exposing (..)\n\nhello : String\nhello =\n    \"Hello, World!\""
                    |> CodeBlock.toMarkup theme
                ]
            ]

        -- CLIPBOARD COPY
        , section theme
            "ClipboardCopy"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ ClipboardCopy.clipboardCopy "elm install mdgriffith/elm-ui"
                    |> ClipboardCopy.withOnCopy (CopyText "elm install mdgriffith/elm-ui")
                    |> ClipboardCopy.toMarkup theme
                , ClipboardCopy.clipboardCopy "https://github.com/lenards/elm-ui-patternfly"
                    |> ClipboardCopy.withInline
                    |> ClipboardCopy.withOnCopy (CopyText "https://github.com/lenards/elm-ui-patternfly")
                    |> ClipboardCopy.toMarkup theme
                , ClipboardCopy.clipboardCopy "{\n  \"type\": \"application\",\n  \"elm-version\": \"0.19.1\"\n}"
                    |> ClipboardCopy.withBlock
                    |> ClipboardCopy.withOnCopy (CopyText "{\n  \"type\": \"application\",\n  \"elm-version\": \"0.19.1\"\n}")
                    |> ClipboardCopy.toMarkup theme
                ]
            ]

        -- LIST
        , section theme
            "List"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerXl ]
                [ Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme), Element.paddingEach { bottom = Tokens.spacerXs, top = 0, left = 0, right = 0 } ]
                        (Element.text "Unordered (bullet)")
                    , PFList.pFList
                        [ Element.text "First list item"
                        , Element.text "Second list item"
                        , Element.text "Third list item"
                        ]
                        |> PFList.toMarkup theme
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme), Element.paddingEach { bottom = Tokens.spacerXs, top = 0, left = 0, right = 0 } ]
                        (Element.text "Ordered (numbered)")
                    , PFList.pFList
                        [ Element.text "Step one"
                        , Element.text "Step two"
                        , Element.text "Step three"
                        ]
                        |> PFList.withOrdered
                        |> PFList.toMarkup theme
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme), Element.paddingEach { bottom = Tokens.spacerXs, top = 0, left = 0, right = 0 } ]
                        (Element.text "Plain (no bullets)")
                    , PFList.pFList
                        [ Element.text "Plain item one"
                        , Element.text "Plain item two"
                        , Element.text "Plain item three"
                        ]
                        |> PFList.withPlain
                        |> PFList.toMarkup theme
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme), Element.paddingEach { bottom = Tokens.spacerXs, top = 0, left = 0, right = 0 } ]
                        (Element.text "Inline")
                    , PFList.pFList
                        [ Element.text "Inline one"
                        , Element.text "Inline two"
                        , Element.text "Inline three"
                        ]
                        |> PFList.withInlined
                        |> PFList.toMarkup theme
                    ]
                ]
            ]

        -- DESCRIPTION LIST
        , section theme
            "DescriptionList"
            [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ DescriptionList.descriptionList
                    [ DescriptionList.group "Name" [ Element.text "Lenards" ]
                    , DescriptionList.group "Framework" [ Element.text "Elm 0.19.1" ]
                    , DescriptionList.group "Design System" [ Element.text "PatternFly 6" ]
                    , DescriptionList.group "UI Library" [ Element.text "elm-ui" ]
                    ]
                    |> DescriptionList.toMarkup theme
                , DescriptionList.descriptionList
                    [ DescriptionList.group "Status" [ Element.text "Active" ]
                    , DescriptionList.group "Components" [ Element.text "43" ]
                    , DescriptionList.group "Tests" [ Element.text "85" ]
                    ]
                    |> DescriptionList.withHorizontal
                    |> DescriptionList.toMarkup theme
                ]
            ]

        -- ACTION LIST
        , section theme
            "ActionList"
            [ ActionList.actionList
                [ ActionList.actionItem
                    (Button.primary { label = "Save", onPress = Nothing }
                        |> Button.toMarkup theme
                    )
                , ActionList.actionItem
                    (Button.secondary { label = "Cancel", onPress = Nothing }
                        |> Button.toMarkup theme
                    )
                ]
                |> ActionList.toMarkup theme
            ]

        -- CONTENT
        , section theme
            "Content"
            [ Content.content
                |> Content.withHeading Content.H2 "PatternFly Design System"
                |> Content.withParagraph "PatternFly is an open source design system built to drive consistency and unify teams."
                |> Content.withBulletList [ "Accessible", "Consistent", "Open source" ]
                |> Content.withOrderedList [ "Install the package", "Import components", "Build your UI" ]
                |> Content.toMarkup theme
            ]

        -- LOGIN PAGE
        , section theme
            "LoginPage"
            [ Element.el [ Element.width Element.fill, Element.height (Element.px 500), Element.clip ]
                (LoginPage.loginPage
                    |> LoginPage.withTitle "Log in"
                    |> LoginPage.withBrandText "MyApp"
                    |> LoginPage.withUsername model.loginUsername
                    |> LoginPage.withPassword model.loginPassword
                    |> LoginPage.withShowPassword model.loginShowPassword
                    |> LoginPage.withOnUsernameChange LoginUsernameChanged
                    |> LoginPage.withOnPasswordChange LoginPasswordChanged
                    |> LoginPage.withOnShowPasswordToggle LoginShowPasswordToggled
                    |> LoginPage.withOnSubmit LoginSubmit
                    |> LoginPage.withFooterLinks [ { label = "Forgot password?", onPress = Nothing } ]
                    |> LoginPage.toMarkup theme
                )
            ]
        ]
