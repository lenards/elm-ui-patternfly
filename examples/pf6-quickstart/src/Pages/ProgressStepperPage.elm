module Pages.ProgressStepperPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.ProgressStepper as ProgressStepper
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Progress Stepper" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Progress steppers display progress through a sequence of steps." ]
        , exampleSection "Horizontal stepper"
            (ProgressStepper.progressStepper
                [ ProgressStepper.step "Setup" |> ProgressStepper.withStepComplete
                , ProgressStepper.step "Configuration" |> ProgressStepper.withStepComplete
                , ProgressStepper.step "Review" |> ProgressStepper.withStepCurrent
                , ProgressStepper.step "Deploy" |> ProgressStepper.withStepPending
                ]
                |> ProgressStepper.toMarkup
            )
        , exampleSection "Vertical stepper"
            (ProgressStepper.progressStepper
                [ ProgressStepper.step "Create account" |> ProgressStepper.withStepComplete |> ProgressStepper.withStepDescription "Account created successfully"
                , ProgressStepper.step "Configure settings" |> ProgressStepper.withStepCurrent |> ProgressStepper.withStepDescription "In progress"
                , ProgressStepper.step "Launch application" |> ProgressStepper.withStepPending
                ]
                |> ProgressStepper.withVertical
                |> ProgressStepper.toMarkup
            )
        , exampleSection "Compact"
            (ProgressStepper.progressStepper
                [ ProgressStepper.step "Step 1" |> ProgressStepper.withStepComplete
                , ProgressStepper.step "Step 2" |> ProgressStepper.withStepCurrent
                , ProgressStepper.step "Step 3" |> ProgressStepper.withStepPending
                ]
                |> ProgressStepper.withCompact
                |> ProgressStepper.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
