module PF6.Form exposing
    ( Form, FormGroup
    , form, formGroup
    , withHorizontal, withLimitWidth
    , withLabel, withHelperText, withRequired, withValidation
    , toMarkup, groupToMarkup
    )

{-| PF6 Form and FormGroup components

Forms are used to collect, validate, and submit user input.

See: <https://www.patternfly.org/components/forms/form>


# Definition

@docs Form, FormGroup


# Constructors

@docs form, formGroup


# Form modifiers

@docs withHorizontal, withLimitWidth


# FormGroup modifiers

@docs withLabel, withHelperText, withRequired, withValidation


# Rendering

@docs toMarkup, groupToMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque Form type
-}
type Form msg
    = Form (FormOptions msg)


{-| Opaque FormGroup type
-}
type FormGroup msg
    = FormGroup (GroupOptions msg)


type alias FormOptions msg =
    { fields : List (Element msg)
    , isHorizontal : Bool
    , limitWidth : Bool
    }


{-| Validation state for a form group
-}
type Validation
    = NoValidation


type alias GroupOptions msg =
    { label : Maybe String
    , field : Element msg
    , helperText : Maybe String
    , isRequired : Bool
    , validation : Validation
    }


{-| Construct a Form with a list of field elements
-}
form : List (Element msg) -> Form msg
form fields =
    Form
        { fields = fields
        , isHorizontal = False
        , limitWidth = False
        }


{-| Construct a FormGroup wrapping a single field element
-}
formGroup : Element msg -> FormGroup msg
formGroup field =
    FormGroup
        { label = Nothing
        , field = field
        , helperText = Nothing
        , isRequired = False
        , validation = NoValidation
        }


{-| Horizontal form layout — labels beside fields
-}
withHorizontal : Form msg -> Form msg
withHorizontal (Form opts) =
    Form { opts | isHorizontal = True }


{-| Limit form width for readability (max ~500px)
-}
withLimitWidth : Form msg -> Form msg
withLimitWidth (Form opts) =
    Form { opts | limitWidth = True }


{-| Set the FormGroup label
-}
withLabel : String -> FormGroup msg -> FormGroup msg
withLabel l (FormGroup opts) =
    FormGroup { opts | label = Just l }


{-| Set helper text below the field
-}
withHelperText : String -> FormGroup msg -> FormGroup msg
withHelperText t (FormGroup opts) =
    FormGroup { opts | helperText = Just t }


{-| Mark the field as required (adds asterisk to label)
-}
withRequired : FormGroup msg -> FormGroup msg
withRequired (FormGroup opts) =
    FormGroup { opts | isRequired = True }


{-| Set validation state
-}
withValidation : Validation -> FormGroup msg -> FormGroup msg
withValidation v (FormGroup opts) =
    FormGroup { opts | validation = v }


validationColor : Validation -> Element.Color
validationColor v =
    case v of
        NoValidation ->
            Tokens.colorTextSubtle


{-| Render a FormGroup as an `Element msg`
-}
groupToMarkup : FormGroup msg -> Element msg
groupToMarkup (FormGroup opts) =
    let
        labelEl =
            case opts.label of
                Nothing ->
                    Element.none

                Just l ->
                    Element.row
                        [ Element.spacing Tokens.spacerXs
                        , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                        ]
                        [ Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.bold
                            , Font.color Tokens.colorText
                            ]
                            (Element.text l)
                        , if opts.isRequired then
                            Element.el
                                [ Font.color Tokens.colorDanger
                                , Font.size Tokens.fontSizeSm
                                ]
                                (Element.text "*")

                          else
                            Element.none
                        ]

        helperEl =
            case opts.helperText of
                Nothing ->
                    Element.none

                Just t ->
                    Element.el
                        [ Font.size Tokens.fontSizeSm
                        , Font.color (validationColor opts.validation)
                        , Element.paddingEach { top = Tokens.spacerXs, right = 0, bottom = 0, left = 0 }
                        ]
                        (Element.text t)
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 0
        ]
        [ labelEl
        , opts.field
        , helperEl
        ]


{-| Render the Form as an `Element msg`
-}
toMarkup : Form msg -> Element msg
toMarkup (Form opts) =
    let
        maxWidth =
            if opts.limitWidth then
                Element.maximum 500 Element.fill

            else
                Element.fill
    in
    Element.column
        [ Element.width maxWidth
        , Element.spacing Tokens.spacerMd
        ]
        opts.fields
