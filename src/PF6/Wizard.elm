module PF6.Wizard exposing
    ( Wizard, WizardStep
    , wizard, wizardStep
    , withStepDisabled, withStepIcon
    , withOnStepChange, withOnNext, withOnBack, withOnCancel, withOnFinish
    , toMarkup
    )

{-| PF6 Wizard component

A multi-step form wizard with sidebar navigation and step content.

See: <https://www.patternfly.org/components/wizard>


# Definition

@docs Wizard, WizardStep


# Constructors

@docs wizard, wizardStep


# Step modifiers

@docs withStepDisabled, withStepIcon


# Wizard modifiers

@docs withOnStepChange, withOnNext, withOnBack, withOnCancel, withOnFinish


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


{-| Opaque Wizard type
-}
type Wizard msg
    = Wizard (Options msg)


{-| Opaque WizardStep type
-}
type WizardStep msg
    = WizardStep (StepOptions msg)


type alias StepOptions msg =
    { title : String
    , content : Element msg
    , isDisabled : Bool
    , icon : Maybe (Element msg)
    }


type alias Options msg =
    { steps : List (WizardStep msg)
    , activeStep : Int
    , onStepChange : Maybe (Int -> msg)
    , onNext : Maybe msg
    , onBack : Maybe msg
    , onCancel : Maybe msg
    , onFinish : Maybe msg
    }


{-| Construct a Wizard

    wizard
        { steps =
            [ wizardStep { title = "Setup", content = setupView }
            , wizardStep { title = "Configure", content = configView }
            , wizardStep { title = "Review", content = reviewView }
            ]
        , activeStep = model.wizardStep
        }

-}
wizard : { steps : List (WizardStep msg), activeStep : Int } -> Wizard msg
wizard config =
    Wizard
        { steps = config.steps
        , activeStep = config.activeStep
        , onStepChange = Nothing
        , onNext = Nothing
        , onBack = Nothing
        , onCancel = Nothing
        , onFinish = Nothing
        }


{-| Construct a wizard step

    wizardStep { title = "Setup", content = myContent }

-}
wizardStep : { title : String, content : Element msg } -> WizardStep msg
wizardStep config =
    WizardStep
        { title = config.title
        , content = config.content
        , isDisabled = False
        , icon = Nothing
        }


{-| Disable a wizard step (not clickable in sidebar)
-}
withStepDisabled : WizardStep msg -> WizardStep msg
withStepDisabled (WizardStep opts) =
    WizardStep { opts | isDisabled = True }


{-| Add a custom icon to a wizard step
-}
withStepIcon : Element msg -> WizardStep msg -> WizardStep msg
withStepIcon icon (WizardStep opts) =
    WizardStep { opts | icon = Just icon }


{-| Set a callback when a step is clicked in the sidebar
-}
withOnStepChange : (Int -> msg) -> Wizard msg -> Wizard msg
withOnStepChange handler (Wizard opts) =
    Wizard { opts | onStepChange = Just handler }


{-| Set the Next button message
-}
withOnNext : msg -> Wizard msg -> Wizard msg
withOnNext msg (Wizard opts) =
    Wizard { opts | onNext = Just msg }


{-| Set the Back button message
-}
withOnBack : msg -> Wizard msg -> Wizard msg
withOnBack msg (Wizard opts) =
    Wizard { opts | onBack = Just msg }


{-| Set the Cancel button message
-}
withOnCancel : msg -> Wizard msg -> Wizard msg
withOnCancel msg (Wizard opts) =
    Wizard { opts | onCancel = Just msg }


{-| Set the Finish button message (shown on the last step instead of Next)
-}
withOnFinish : msg -> Wizard msg -> Wizard msg
withOnFinish msg (Wizard opts) =
    Wizard { opts | onFinish = Just msg }


stepStatusIcon : Theme -> Int -> Int -> StepOptions msg -> Element msg
stepStatusIcon theme index activeStep stepOpts =
    let
        iconContent =
            case stepOpts.icon of
                Just ic ->
                    ic

                Nothing ->
                    if index < activeStep then
                        Element.text "\u{2713}"

                    else
                        Element.text (String.fromInt (index + 1))

        color =
            if index < activeStep then
                Theme.success theme

            else if index == activeStep then
                Theme.primary theme

            else
                Theme.textSubtle theme
    in
    Element.el
        [ Font.color color
        , Font.bold
        , Font.size Tokens.fontSizeMd
        , Element.width (Element.px 28)
        , Element.height (Element.px 28)
        , Border.rounded 14
        , Border.width 2
        , Border.color color
        , Bg.color (Theme.backgroundDefault theme)
        , Element.centerX
        ]
        (Element.el [ Element.centerX, Element.centerY ] iconContent)


sidebarStep : Theme -> Int -> Int -> Maybe (Int -> msg) -> WizardStep msg -> Element msg
sidebarStep theme index activeStep onStepChange (WizardStep stepOpts) =
    let
        isCurrent =
            index == activeStep

        isComplete =
            index < activeStep

        textColor =
            if stepOpts.isDisabled then
                Theme.textSubtle theme

            else if isCurrent then
                Theme.primary theme

            else if isComplete then
                Theme.text theme

            else
                Theme.textSubtle theme

        bgAttrs =
            if isCurrent then
                [ Bg.color (Theme.backgroundSecondary theme) ]

            else
                []

        onPress =
            if stepOpts.isDisabled then
                Nothing

            else
                onStepChange |> Maybe.map (\handler -> handler index)

        content =
            Element.row [ Element.spacing Tokens.spacerSm, Element.centerY ]
                [ stepStatusIcon theme index activeStep stepOpts
                , Element.el
                    [ Font.size Tokens.fontSizeMd
                    , Font.color textColor
                    , if isCurrent then
                        Font.bold

                      else
                        Font.regular
                    ]
                    (Element.text stepOpts.title)
                ]
    in
    Input.button
        ([ Element.width Element.fill
         , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
         ]
            ++ bgAttrs
        )
        { onPress = onPress
        , label = content
        }


{-| Render the Wizard as an `Element msg`
-}
toMarkup : Theme -> Wizard msg -> Element msg
toMarkup theme (Wizard opts) =
    let
        totalSteps =
            List.length opts.steps

        isFirstStep =
            opts.activeStep == 0

        isLastStep =
            opts.activeStep == totalSteps - 1

        sidebarEl =
            Element.column
                [ Element.width (Element.px 250)
                , Element.height Element.fill
                , Bg.color (Theme.backgroundDefault theme)
                , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
                , Border.color (Theme.borderDefault theme)
                , Element.paddingXY 0 Tokens.spacerMd
                ]
                (List.indexedMap
                    (\i s -> sidebarStep theme i opts.activeStep opts.onStepChange s)
                    opts.steps
                )

        activeContent =
            opts.steps
                |> List.indexedMap Tuple.pair
                |> List.filter (\( i, _ ) -> i == opts.activeStep)
                |> List.head
                |> Maybe.map
                    (\( _, WizardStep stepOpts ) ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.height Element.fill
                            , Element.padding Tokens.spacerXl
                            , Element.scrollbarY
                            ]
                            stepOpts.content
                    )
                |> Maybe.withDefault Element.none

        backBtn =
            if isFirstStep then
                Element.none

            else
                Input.button
                    [ Element.paddingXY 16 Tokens.spacerSm
                    , Font.size Tokens.fontSizeMd
                    , Font.color (Theme.text theme)
                    , Bg.color (Theme.backgroundDefault theme)
                    , Border.rounded Tokens.radiusMd
                    , Border.solid
                    , Border.width 1
                    , Border.color (Theme.borderDefault theme)
                    ]
                    { onPress = opts.onBack
                    , label = Element.text "Back"
                    }

        nextOrFinishBtn =
            if isLastStep then
                Input.button
                    [ Element.paddingXY 16 Tokens.spacerSm
                    , Font.size Tokens.fontSizeMd
                    , Font.color (Theme.textOnDark theme)
                    , Bg.color (Theme.primary theme)
                    , Border.rounded Tokens.radiusMd
                    , Border.width 0
                    ]
                    { onPress = opts.onFinish
                    , label = Element.text "Finish"
                    }

            else
                Input.button
                    [ Element.paddingXY 16 Tokens.spacerSm
                    , Font.size Tokens.fontSizeMd
                    , Font.color (Theme.textOnDark theme)
                    , Bg.color (Theme.primary theme)
                    , Border.rounded Tokens.radiusMd
                    , Border.width 0
                    ]
                    { onPress = opts.onNext
                    , label = Element.text "Next"
                    }

        cancelBtn =
            case opts.onCancel of
                Just _ ->
                    Input.button
                        [ Element.paddingXY 16 Tokens.spacerSm
                        , Font.size Tokens.fontSizeMd
                        , Font.color (Theme.primary theme)
                        , Bg.color (Theme.backgroundDefault theme)
                        , Border.rounded Tokens.radiusMd
                        , Border.width 0
                        ]
                        { onPress = opts.onCancel
                        , label = Element.text "Cancel"
                        }

                Nothing ->
                    Element.none

        footerEl =
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerXl Tokens.spacerMd
                , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                , Border.color (Theme.borderDefault theme)
                , Element.spacing Tokens.spacerSm
                ]
                [ backBtn
                , nextOrFinishBtn
                , Element.el [ Element.alignRight ] cancelBtn
                ]
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Border.rounded Tokens.radiusLg
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        , Element.clip
        ]
        [ Element.row
            [ Element.width Element.fill
            , Element.height (Element.fillPortion 1)
            ]
            [ sidebarEl
            , activeContent
            ]
        , footerEl
        ]
