module Pages.ModalPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Modal as Modal
import PF6.Title as Title
import PF6.Tokens as Tokens


view : { modalOpen : Bool, onOpen : msg, onClose : msg } -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Modal" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Modals present information in an overlay above the main page content." ]
        , exampleSection "Basic modal"
            (Element.column [ Element.spacing 16 ]
                [ Button.primary { label = "Open modal", onPress = Just config.onOpen } |> Button.toMarkup
                , if config.modalOpen then
                    Modal.modal
                        |> Modal.withTitle "Example modal"
                        |> Modal.withBody
                            (Element.paragraph [ Font.size 14 ]
                                [ Element.text "This is the modal body content. Modals focus the user's attention on a specific task or piece of information." ]
                            )
                        |> Modal.withFooter
                            (Element.row [ Element.spacing 8 ]
                                [ Button.primary { label = "Confirm", onPress = Just config.onClose } |> Button.toMarkup
                                , Button.link { label = "Cancel", onPress = Just config.onClose } |> Button.toMarkup
                                ]
                            )
                        |> Modal.withCloseMsg config.onClose
                        |> Modal.toMarkup

                  else
                    Element.none
                ]
            )
        , exampleSection "Modal sizes"
            (Element.paragraph [ Font.size 14, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Modals support small, medium, and large sizes via withSmallSize, withMediumSize, and withLargeSize." ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
