module Views.RadioView exposing (view)

import Element exposing (Element)
import Html exposing (Html)
import PF4.Card as Card
import PF4.Info as Info
import PF4.Navigation as Navigation
import PF4.Page as Page
import PF4.Radio as Radio
import PF4.Title as Title
import Types
    exposing
        ( AdvancedOptionsOptions(..)
        , Model
        , Msg(..)
        , RootDiskSizeOptions(..)
        , WebDesktopOptions(..)
        )
import Views.Layout exposing (layout)


view : Model -> Html Msg
view model =
    layout <|
        Page.page
            { title = "PF4 Components"
            , nav =
                model.navItems
                    |> List.map
                        (\item ->
                            ( item, NavSelected item )
                        )
                    |> Navigation.nav
                    |> Navigation.withSelectedItem
                        model.selectedNav
            , body = body model
            }


body model =
    [ Title.title "Radio Component"
        |> Title.withSize2xl
        |> Title.toMarkup
    , Info.info
        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
        |> Info.withTitle "This is a Title"
        |> Info.withDefaultIcon
        |> Info.toMarkup
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ Radio.radio
                { selected = model.rootDiskSizeSelected
                , label = "Choose a root disk size"
                , options =
                    [ { value = EightGigabytes
                      , text = "8 GB (default for selected flavor"
                      }
                    , { value = CustomDiskSize
                      , text = "Custom disk size (volume-backed)"
                      }
                    ]
                , onChange = RootDiskSizeSelected
                }
                |> Radio.toMarkup
            ]
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 10
                , left = 0
                }
            |> Card.toMarkup
        , Card.card
            [ Radio.radio
                { selected = model.webDesktopSelected
                , label = "Enable Web Desktop?"
                , options =
                    [ { value = No, text = "No" }
                    , { value = Yes, text = "Yes" }
                    ]
                , onChange = WebDesktopSelected
                }
                |> Radio.asRow
                |> Radio.toMarkup
            ]
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 10
                , left = 0
                }
            |> Card.toMarkup
        , Card.card
            [ Radio.radio
                { selected = model.advOptionsSelected
                , label = "Advanced Options"
                , options =
                    [ { value = Hide, text = "Hide" }
                    , { value = Show, text = "Show" }
                    ]
                , onChange = AdvancedOptionsSelected
                }
                |> Radio.asRow
                |> Radio.toMarkup
            ]
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 10
                , left = 0
                }
            |> Card.toMarkup
        ]
    ]
