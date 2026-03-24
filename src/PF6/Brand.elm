module PF6.Brand exposing
    ( Brand
    , brand
    , withWidth, withHeight, withResponsive
    , toMarkup
    )

{-| PF6 Brand component

A logo/brand image with alt text, typically used in the masthead.

See: <https://www.patternfly.org/components/brand>


# Definition

@docs Brand


# Constructor

@docs brand


# Modifiers

@docs withWidth, withHeight, withResponsive


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html.Attributes


{-| Opaque Brand type
-}
type Brand msg
    = Brand (Options)


type alias Options =
    { src : String
    , alt : String
    , width : Maybe Int
    , height : Maybe Int
    , responsive : Bool
    }


{-| Construct a Brand with image source and alt text

    brand { src = "/logo.svg", alt = "My App" }

-}
brand : { src : String, alt : String } -> Brand msg
brand { src, alt } =
    Brand
        { src = src
        , alt = alt
        , width = Nothing
        , height = Nothing
        , responsive = False
        }


{-| Set an explicit width in pixels
-}
withWidth : Int -> Brand msg -> Brand msg
withWidth w (Brand opts) =
    Brand { opts | width = Just w }


{-| Set an explicit height in pixels
-}
withHeight : Int -> Brand msg -> Brand msg
withHeight h (Brand opts) =
    Brand { opts | height = Just h }


{-| Make the brand image responsive (scales to fit container)
-}
withResponsive : Brand msg -> Brand msg
withResponsive (Brand opts) =
    Brand { opts | responsive = True }


{-| Render the Brand as an `Element msg`
-}
toMarkup : Brand msg -> Element msg
toMarkup (Brand opts) =
    let
        widthAttr =
            case ( opts.width, opts.responsive ) of
                ( Just w, _ ) ->
                    [ Element.width (Element.px w) ]

                ( Nothing, True ) ->
                    [ Element.width Element.fill
                    , Element.htmlAttribute (Html.Attributes.style "max-width" "100%")
                    ]

                ( Nothing, False ) ->
                    []

        heightAttr =
            case opts.height of
                Just h ->
                    [ Element.height (Element.px h) ]

                Nothing ->
                    []
    in
    Element.image
        (widthAttr ++ heightAttr)
        { src = opts.src
        , description = opts.alt
        }
