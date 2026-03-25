module PF6.ProgressStepper exposing
    ( ProgressStepper, Step, StepStatus(..)
    , progressStepper, step
    , withStepCurrent, withStepComplete, withStepPending, withStepIcon, withStepDescription
    , withVertical, withCompact
    , toMarkup
    )

{-| PF6 ProgressStepper component

A multi-step progress indicator showing the user's position in a workflow.

See: <https://www.patternfly.org/components/progress-stepper>


# Definition

@docs ProgressStepper, Step, StepStatus


# Constructors

@docs progressStepper, step


# Step modifiers

@docs withStepCurrent, withStepComplete, withStepPending, withStepIcon, withStepDescription


# Stepper modifiers

@docs withVertical, withCompact


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque ProgressStepper type
-}
type ProgressStepper msg
    = ProgressStepper (Options msg)


{-| Opaque Step type
-}
type Step msg
    = Step (StepOptions msg)


{-| Step status
-}
type StepStatus
    = Pending
    | Current
    | Complete


type alias StepOptions msg =
    { title : String
    , status : StepStatus
    , icon : Maybe (Element msg)
    , description : Maybe String
    }


type alias Options msg =
    { steps : List (Step msg)
    , vertical : Bool
    , compact : Bool
    }


{-| Construct a ProgressStepper with a list of steps

    progressStepper
        [ step "Setup" |> withStepComplete
        , step "Configure" |> withStepCurrent
        , step "Review"
        ]

-}
progressStepper : List (Step msg) -> ProgressStepper msg
progressStepper steps =
    ProgressStepper
        { steps = steps
        , vertical = False
        , compact = False
        }


{-| Construct a step with a title
-}
step : String -> Step msg
step title =
    Step
        { title = title
        , status = Pending
        , icon = Nothing
        , description = Nothing
        }


{-| Mark a step as the current active step
-}
withStepCurrent : Step msg -> Step msg
withStepCurrent (Step opts) =
    Step { opts | status = Current }


{-| Mark a step as complete
-}
withStepComplete : Step msg -> Step msg
withStepComplete (Step opts) =
    Step { opts | status = Complete }


{-| Mark a step as pending (default)
-}
withStepPending : Step msg -> Step msg
withStepPending (Step opts) =
    Step { opts | status = Pending }


{-| Set a custom icon for the step
-}
withStepIcon : Element msg -> Step msg -> Step msg
withStepIcon icon (Step opts) =
    Step { opts | icon = Just icon }


{-| Add a description below the step title
-}
withStepDescription : String -> Step msg -> Step msg
withStepDescription desc (Step opts) =
    Step { opts | description = Just desc }


{-| Display the stepper vertically
-}
withVertical : ProgressStepper msg -> ProgressStepper msg
withVertical (ProgressStepper opts) =
    ProgressStepper { opts | vertical = True }


{-| Use compact styling with reduced spacing
-}
withCompact : ProgressStepper msg -> ProgressStepper msg
withCompact (ProgressStepper opts) =
    ProgressStepper { opts | compact = True }


statusColor : Theme -> StepStatus -> Element.Color
statusColor theme status =
    case status of
        Complete ->
            Theme.success theme

        Current ->
            Theme.primary theme

        Pending ->
            Theme.textSubtle theme


defaultIcon : StepStatus -> Element msg
defaultIcon status =
    Element.text
        (case status of
            Complete ->
                "✓"

            Current ->
                "●"

            Pending ->
                "○"
        )


stepMarkup : Theme -> Bool -> Step msg -> Element msg
stepMarkup theme isCompact (Step opts) =
    let
        color =
            statusColor theme opts.status

        iconEl =
            Element.el
                [ Font.color color
                , Font.bold
                , Font.size
                    (if isCompact then
                        Tokens.fontSizeMd

                     else
                        Tokens.fontSizeLg
                    )
                , Element.centerX
                ]
                (opts.icon |> Maybe.withDefault (defaultIcon opts.status))

        titleEl =
            Element.el
                [ Font.size
                    (if isCompact then
                        Tokens.fontSizeSm

                     else
                        Tokens.fontSizeMd
                    )
                , Font.color
                    (case opts.status of
                        Pending ->
                            Theme.textSubtle theme

                        _ ->
                            Theme.text theme
                    )
                , Font.bold
                , Element.centerX
                ]
                (Element.text opts.title)

        descEl =
            opts.description
                |> Maybe.map
                    (\d ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.textSubtle theme)
                            , Element.centerX
                            ]
                            (Element.text d)
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        [ Element.spacing Tokens.spacerXs
        , Element.width Element.fill
        ]
        [ iconEl
        , titleEl
        , descEl
        ]


connectorLine : Theme -> StepStatus -> Element msg
connectorLine theme status =
    Element.el
        [ Element.width Element.fill
        , Element.height (Element.px 2)
        , Bg.color
            (case status of
                Complete ->
                    Theme.success theme

                _ ->
                    Theme.borderDefault theme
            )
        , Element.centerY
        ]
        Element.none


verticalConnector : Theme -> StepStatus -> Element msg
verticalConnector theme status =
    Element.el
        [ Element.width (Element.px 2)
        , Element.height (Element.px 24)
        , Bg.color
            (case status of
                Complete ->
                    Theme.success theme

                _ ->
                    Theme.borderDefault theme
            )
        , Element.centerX
        ]
        Element.none


{-| Render the ProgressStepper as an `Element msg`
-}
toMarkup : Theme -> ProgressStepper msg -> Element msg
toMarkup theme (ProgressStepper opts) =
    if opts.vertical then
        Element.column
            [ Element.spacing 0
            , Element.width Element.fill
            ]
            (List.indexedMap
                (\i s ->
                    let
                        (Step stepOpts) =
                            s
                    in
                    Element.column [ Element.width Element.fill ]
                        ([ stepMarkup theme opts.compact s ]
                            ++ (if i < List.length opts.steps - 1 then
                                    [ verticalConnector theme stepOpts.status ]

                                else
                                    []
                               )
                        )
                )
                opts.steps
            )

    else
        Element.row
            [ Element.width Element.fill
            , Element.spacing 0
            ]
            (List.indexedMap
                (\i s ->
                    let
                        (Step stepOpts) =
                            s

                        isLast =
                            i == List.length opts.steps - 1
                    in
                    Element.row [ Element.width Element.fill ]
                        [ stepMarkup theme opts.compact s
                        , if isLast then
                            Element.none

                          else
                            connectorLine theme stepOpts.status
                        ]
                )
                opts.steps
            )
