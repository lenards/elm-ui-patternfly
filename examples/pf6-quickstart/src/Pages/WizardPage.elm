module Pages.WizardPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens
import PF6.Wizard as Wizard


view :
    Theme
    ->
        { wizardStep : Int
        , onWizardStepChange : Int -> msg
        , onNext : msg
        , onBack : msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Wizard" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Wizards guide users through a multi-step workflow, one step at a time." ]
        , exampleSection theme "Basic wizard"
            (Wizard.wizard
                { steps =
                    [ Wizard.wizardStep { title = "General", content = Element.paragraph [ Font.size 14 ] [ Element.text "Step 1: Enter general information about the resource." ] }
                    , Wizard.wizardStep { title = "Configuration", content = Element.paragraph [ Font.size 14 ] [ Element.text "Step 2: Configure the resource settings." ] }
                    , Wizard.wizardStep { title = "Review", content = Element.paragraph [ Font.size 14 ] [ Element.text "Step 3: Review and confirm your selections." ] }
                    ]
                , activeStep = config.wizardStep
                }
                |> Wizard.withOnStepChange config.onWizardStepChange
                |> Wizard.withOnNext config.onNext
                |> Wizard.withOnBack config.onBack
                |> Wizard.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
