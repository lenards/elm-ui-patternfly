module Pages.ModalPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Modal as Modal
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> { modalOpen : Bool, onOpen : msg, onClose : msg } -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Modal" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Modals present information in an overlay above the main page content." ]
        , exampleSection theme "Basic modal"
            (Element.column [ Element.spacing 16 ]
                [ Button.primary { label = "Open modal", onPress = Just config.onOpen } |> Button.toMarkup theme
                , if config.modalOpen then
                    Modal.modal
                        |> Modal.withTitle "Example modal"
                        |> Modal.withBody
                            (Element.paragraph [ Font.size 14 ]
                                [ Element.text "This is the modal body content. Modals focus the user's attention on a specific task or piece of information." ]
                            )
                        |> Modal.withFooter
                            (Element.row [ Element.spacing 8 ]
                                [ Button.primary { label = "Confirm", onPress = Just config.onClose } |> Button.toMarkup theme
                                , Button.link { label = "Cancel", onPress = Just config.onClose } |> Button.toMarkup theme
                                ]
                            )
                        |> Modal.withCloseMsg config.onClose
                        |> Modal.toMarkup theme

                  else
                    Element.none
                ]
            )
        , exampleSection theme "Modal sizes"
            (Element.paragraph [ Font.size 14, Font.color (Theme.textSubtle theme) ]
                [ Element.text "Modals support small, medium, and large sizes via withSmallSize, withMediumSize, and withLargeSize." ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
