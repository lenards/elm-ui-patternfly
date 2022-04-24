module Views.HomeView exposing (view)

import Element exposing (Element)
import Html exposing (Html)
import PF4.ApplicationLauncher as AppLauncher
import PF4.Card as Card
import PF4.Checkbox as Checkbox
import PF4.Info as Info
import PF4.Navigation as Navigation exposing (Navigation)
import PF4.Page as Page
import PF4.Radio as Radio
import PF4.Switch as Switch
import PF4.Title as Title
import PF4.Tooltip as Tooltip
import Types exposing (Model, Msg(..))
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
    [ Title.title "Kitchen Sink of PF4 Components"
        |> Title.withSize2xl
        |> Title.toMarkup
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ AppLauncher.applicationLauncher
                { id = "menu-id__lolz"
                , items =
                    [ { itemId = "instances_id", label = "instances" }
                    , { itemId = "volumes_id", label = "volumes" }
                    , { itemId = "images_id", label = "images" }
                    ]
                , onItemSelect = \_ -> NoOp
                , onClick = LauncherClicked "menu-id__lolz"
                }
                |> AppLauncher.withActiveMenu model.activeMenuId
                |> AppLauncher.toMarkup
            ]
            |> Card.withTitle "Menu Example - sort of ..."
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 10
                , left = 0
                }
            |> Card.toMarkup
        , Card.card
            [ Radio.radio
                { onChange = RadioSelected
                , selected = model.selectedRadio
                , label = "Radio!"
                , options =
                    [ { value = "boot-volume", text = "Boot Volume" }
                    , { value = "block-volume", text = "Block Storage Volume" }
                    ]
                }
                |> Radio.toMarkup
            , Checkbox.checkbox
                { checked = model.checked
                , onCheck = CheckboxChanged
                , label = "Default Checkbox"
                }
                |> Checkbox.toMarkup
            ]
            |> Card.withTitle "Radio Selection Example"
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 10
                , left = 0
                }
            |> Card.toMarkup
        ]
    ]
