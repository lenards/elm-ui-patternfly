module Views.FeedbackView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Alert as Alert
import PF6.Banner as Banner
import PF6.Button as Button
import PF6.EmptyState as EmptyState
import PF6.HelperText as HelperText
import PF6.Hint as Hint
import PF6.Progress as Progress
import PF6.ProgressStepper as ProgressStepper
import PF6.Skeleton as Skeleton
import PF6.Spinner as Spinner
import PF6.Theme as Theme exposing (Theme)
import PF6.Toast as Toast
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
            (Element.text "Feedback & Status")

        -- TOAST
        , section theme
            "Toast"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Button.primary { label = "Show toast", onPress = Just ToastShow } |> Button.toMarkup theme
                , if model.toastVisible then
                    Toast.toast "Your action completed successfully."
                        |> Toast.withTitle "Success"
                        |> Toast.withSuccess
                        |> Toast.withCloseMsg ToastDismiss
                        |> Toast.toMarkup theme

                  else
                    Element.none
                ]
            ]

        -- ALERT
        , section theme
            "Alert"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Alert.alert "Default alert — informational message."
                    |> Alert.withTitle "Default alert title"
                    |> Alert.toMarkup theme
                , Alert.alert "You successfully completed the action."
                    |> Alert.withTitle "Success alert"
                    |> Alert.withSuccess
                    |> Alert.withCloseMsg AlertDismiss
                    |> Alert.toMarkup theme
                , Alert.alert "Danger alert — something went wrong."
                    |> Alert.withTitle "Danger alert"
                    |> Alert.withDanger
                    |> Alert.toMarkup theme
                , Alert.alert "Warning alert — proceed with caution."
                    |> Alert.withTitle "Warning alert"
                    |> Alert.withWarning
                    |> Alert.toMarkup theme
                , Alert.alert "Info alert — additional context."
                    |> Alert.withTitle "Info alert"
                    |> Alert.withInfo
                    |> Alert.toMarkup theme
                ]
            ]

        -- BANNER
        , section theme
            "Banner"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Banner.banner "Default banner — site-wide information."
                    |> Banner.toMarkup theme
                , Banner.banner "Info banner — new features available."
                    |> Banner.withInfo
                    |> Banner.withLink { label = "Read more", href = "#" }
                    |> Banner.toMarkup theme
                , Banner.banner "Success banner — deployment complete."
                    |> Banner.withSuccess
                    |> Banner.toMarkup theme
                , Banner.banner "Warning banner — maintenance window approaching."
                    |> Banner.withWarning
                    |> Banner.toMarkup theme
                , Banner.banner "Danger banner — critical system error."
                    |> Banner.withDanger
                    |> Banner.toMarkup theme
                ]
            ]

        -- SPINNER
        , section theme
            "Spinner"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerLg ]
                [ Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ] (Element.text "Small")
                    , Spinner.spinner |> Spinner.withSmallSize |> Spinner.toMarkup theme
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ] (Element.text "Medium")
                    , Spinner.spinner |> Spinner.toMarkup theme
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ] (Element.text "Large")
                    , Spinner.spinner |> Spinner.withLargeSize |> Spinner.toMarkup theme
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ] (Element.text "XL")
                    , Spinner.spinner |> Spinner.withXLargeSize |> Spinner.toMarkup theme
                    ]
                ]
            ]

        -- SKELETON
        , section theme
            "Skeleton"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Skeleton.skeleton |> Skeleton.withWidth 100 |> Skeleton.toMarkup theme
                , Skeleton.skeleton |> Skeleton.withWidth 75 |> Skeleton.toMarkup theme
                , Skeleton.skeleton |> Skeleton.withWidth 50 |> Skeleton.toMarkup theme
                , Skeleton.skeleton |> Skeleton.withWidth 25 |> Skeleton.toMarkup theme
                , Element.wrappedRow [ Element.spacing Tokens.spacerMd ]
                    [ Skeleton.circleSkeleton |> Skeleton.toMarkup theme
                    , Skeleton.skeleton |> Skeleton.withSquare |> Skeleton.withHeight 64 |> Skeleton.toMarkup theme
                    ]
                ]
            ]

        -- PROGRESS
        , section theme
            "Progress"
            [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Progress.progress model.progressValue
                    |> Progress.withTitle "Default"
                    |> Progress.toMarkup theme
                , Progress.progress 33
                    |> Progress.withTitle "Danger"
                    |> Progress.withDanger
                    |> Progress.toMarkup theme
                , Progress.progress 66
                    |> Progress.withTitle "Warning"
                    |> Progress.withWarning
                    |> Progress.toMarkup theme
                , Progress.progress 100
                    |> Progress.withTitle "Success"
                    |> Progress.withSuccess
                    |> Progress.toMarkup theme
                , Progress.progress 50
                    |> Progress.withTitle "Small bar"
                    |> Progress.withSmallSize
                    |> Progress.toMarkup theme
                ]
            ]

        -- EMPTY STATE
        , section theme
            "EmptyState"
            [ EmptyState.emptyState
                |> EmptyState.withIcon (Element.text "📭")
                |> EmptyState.withTitleH2 "No results found"
                |> EmptyState.withBody "Try adjusting your search or filter criteria to find what you are looking for."
                |> EmptyState.toMarkup theme
            ]

        -- HELPER TEXT
        , section theme
            "HelperText"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ HelperText.helperText "This is default helper text." |> HelperText.toMarkup theme
                , HelperText.helperText "This field is required." |> HelperText.withError |> HelperText.toMarkup theme
                , HelperText.helperText "Check your input." |> HelperText.withWarning |> HelperText.toMarkup theme
                , HelperText.helperText "Username is available." |> HelperText.withSuccess |> HelperText.toMarkup theme
                , HelperText.helperText "Checking availability..." |> HelperText.withIndeterminate |> HelperText.toMarkup theme
                ]
            ]

        -- HINT
        , section theme
            "Hint"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Hint.hint "Try searching for items by name or description to quickly find what you need."
                    |> Hint.toMarkup theme
                , Hint.hint "You can filter results by selecting categories from the sidebar."
                    |> Hint.withTitle "Pro tip"
                    |> Hint.withActions
                        (Button.link { label = "Learn more", onPress = Nothing } |> Button.toMarkup theme)
                    |> Hint.toMarkup theme
                , Hint.hint "Your changes will be saved automatically as you edit."
                    |> Hint.withTitle "Auto-save enabled"
                    |> Hint.withFooter
                        (Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ]
                            (Element.text "Last saved 2 minutes ago")
                        )
                    |> Hint.toMarkup theme
                ]
            ]

        -- PROGRESS STEPPER
        , section theme
            "ProgressStepper"
            [ Element.column [ Element.spacing Tokens.spacerLg, Element.width Element.fill ]
                [ ProgressStepper.progressStepper
                    [ ProgressStepper.step "Setup" |> ProgressStepper.withStepComplete
                    , ProgressStepper.step "Configure" |> ProgressStepper.withStepComplete
                    , ProgressStepper.step "Review" |> ProgressStepper.withStepCurrent
                    , ProgressStepper.step "Deploy"
                    ]
                    |> ProgressStepper.toMarkup theme
                , ProgressStepper.progressStepper
                    [ ProgressStepper.step "Create account"
                        |> ProgressStepper.withStepComplete
                        |> ProgressStepper.withStepDescription "Account created"
                    , ProgressStepper.step "Set preferences"
                        |> ProgressStepper.withStepCurrent
                        |> ProgressStepper.withStepDescription "In progress"
                    , ProgressStepper.step "Launch"
                        |> ProgressStepper.withStepDescription "Not started"
                    ]
                    |> ProgressStepper.withCompact
                    |> ProgressStepper.toMarkup theme
                ]
            ]
        ]
