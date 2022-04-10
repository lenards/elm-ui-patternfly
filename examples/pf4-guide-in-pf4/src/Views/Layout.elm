module Views.Layout exposing (layout)

import Element exposing (Element)
import Html exposing (Html)
import PF4.Page as Page exposing (Page)


layout : Page msg -> Html msg
layout page =
    Element.layout [] <|
        Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ page |> Page.toMarkup ]
