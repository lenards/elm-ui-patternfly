module Pages.ProgressStepperPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.ProgressStepper as ProgressStepper
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Progress Stepper" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Progress steppers display progress through a sequence of steps." ]
        , exampleSection theme "Horizontal stepper"
            (ProgressStepper.progressStepper
                [ ProgressStepper.step "Setup" |> ProgressStepper.withStepComplete
                , ProgressStepper.step "Configuration" |> ProgressStepper.withStepComplete
                , ProgressStepper.step "Review" |> ProgressStepper.withStepCurrent
                , ProgressStepper.step "Deploy" |> ProgressStepper.withStepPending
                ]
                |> ProgressStepper.toMarkup theme
            )
        , exampleSection theme "Vertical stepper"
            (ProgressStepper.progressStepper
                [ ProgressStepper.step "Create account" |> ProgressStepper.withStepComplete |> ProgressStepper.withStepDescription "Account created successfully"
                , ProgressStepper.step "Configure settings" |> ProgressStepper.withStepCurrent |> ProgressStepper.withStepDescription "In progress"
                , ProgressStepper.step "Launch application" |> ProgressStepper.withStepPending
                ]
                |> ProgressStepper.withVertical
                |> ProgressStepper.toMarkup theme
            )
        , exampleSection theme "Compact"
            (ProgressStepper.progressStepper
                [ ProgressStepper.step "Step 1" |> ProgressStepper.withStepComplete
                , ProgressStepper.step "Step 2" |> ProgressStepper.withStepCurrent
                , ProgressStepper.step "Step 3" |> ProgressStepper.withStepPending
                ]
                |> ProgressStepper.withCompact
                |> ProgressStepper.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
