module PF6.LoginPage exposing
    ( LoginPage
    , loginPage
    , withTitle
    , withSubtitle
    , withBrandText
    , withUsernameLabel
    , withPasswordLabel
    , withRememberMeLabel
    , withSubmitLabel
    , withUsername
    , withPassword
    , withShowPassword
    , withRememberMe
    , withHelperText
    , withOnUsernameChange
    , withOnPasswordChange
    , withOnShowPasswordToggle
    , withOnRememberMeToggle
    , withOnSubmit
    , withFooterLinks
    , toMarkup
    )

{-| PF6 LoginPage component

A centered login form with brand text, username/password fields, optional
"remember me" checkbox, and footer links. Use as a full-page layout.

See: <https://www.patternfly.org/components/login-page>


# Definition

@docs LoginPage


# Constructor

@docs loginPage


# Label modifiers

@docs withTitle, withSubtitle, withBrandText
@docs withUsernameLabel, withPasswordLabel, withRememberMeLabel, withSubmitLabel


# Value modifiers

@docs withUsername, withPassword, withShowPassword, withRememberMe


# Event modifiers

@docs withOnUsernameChange, withOnPasswordChange
@docs withOnShowPasswordToggle, withOnRememberMeToggle
@docs withOnSubmit


# Content modifiers

@docs withHelperText, withFooterLinks


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque LoginPage type
-}
type LoginPage msg
    = LoginPage (Options msg)


type alias Options msg =
    { title : String
    , subtitle : Maybe String
    , brandText : Maybe String
    , usernameLabel : String
    , passwordLabel : String
    , rememberMeLabel : String
    , submitLabel : String
    , username : String
    , password : String
    , showPassword : Bool
    , rememberMe : Bool
    , helperText : Maybe String
    , footerLinks : List { label : String, onPress : Maybe msg }
    , onUsernameChange : Maybe (String -> msg)
    , onPasswordChange : Maybe (String -> msg)
    , onShowPasswordToggle : Maybe msg
    , onRememberMeToggle : Maybe (Bool -> msg)
    , onSubmit : Maybe msg
    }


{-| Construct an empty LoginPage
-}
loginPage : LoginPage msg
loginPage =
    LoginPage
        { title = "Log in to your account"
        , subtitle = Nothing
        , brandText = Nothing
        , usernameLabel = "Username"
        , passwordLabel = "Password"
        , rememberMeLabel = "Keep me logged in"
        , submitLabel = "Log in"
        , username = ""
        , password = ""
        , showPassword = False
        , rememberMe = False
        , helperText = Nothing
        , footerLinks = []
        , onUsernameChange = Nothing
        , onPasswordChange = Nothing
        , onShowPasswordToggle = Nothing
        , onRememberMeToggle = Nothing
        , onSubmit = Nothing
        }


{-| Set the login form title
-}
withTitle : String -> LoginPage msg -> LoginPage msg
withTitle t (LoginPage opts) =
    LoginPage { opts | title = t }


{-| Set an optional subtitle below the title
-}
withSubtitle : String -> LoginPage msg -> LoginPage msg
withSubtitle s (LoginPage opts) =
    LoginPage { opts | subtitle = Just s }


{-| Set optional brand/product name displayed above the card
-}
withBrandText : String -> LoginPage msg -> LoginPage msg
withBrandText t (LoginPage opts) =
    LoginPage { opts | brandText = Just t }


{-| Set the username field label
-}
withUsernameLabel : String -> LoginPage msg -> LoginPage msg
withUsernameLabel l (LoginPage opts) =
    LoginPage { opts | usernameLabel = l }


{-| Set the password field label
-}
withPasswordLabel : String -> LoginPage msg -> LoginPage msg
withPasswordLabel l (LoginPage opts) =
    LoginPage { opts | passwordLabel = l }


{-| Set the remember-me checkbox label
-}
withRememberMeLabel : String -> LoginPage msg -> LoginPage msg
withRememberMeLabel l (LoginPage opts) =
    LoginPage { opts | rememberMeLabel = l }


{-| Set the submit button label
-}
withSubmitLabel : String -> LoginPage msg -> LoginPage msg
withSubmitLabel l (LoginPage opts) =
    LoginPage { opts | submitLabel = l }


{-| Set the current username value
-}
withUsername : String -> LoginPage msg -> LoginPage msg
withUsername u (LoginPage opts) =
    LoginPage { opts | username = u }


{-| Set the current password value
-}
withPassword : String -> LoginPage msg -> LoginPage msg
withPassword p (LoginPage opts) =
    LoginPage { opts | password = p }


{-| Show the password in plain text (True) or masked (False)
-}
withShowPassword : Bool -> LoginPage msg -> LoginPage msg
withShowPassword show (LoginPage opts) =
    LoginPage { opts | showPassword = show }


{-| Set the remember-me checkbox state
-}
withRememberMe : Bool -> LoginPage msg -> LoginPage msg
withRememberMe v (LoginPage opts) =
    LoginPage { opts | rememberMe = v }


{-| Set the message sent when the username field changes
-}
withOnUsernameChange : (String -> msg) -> LoginPage msg -> LoginPage msg
withOnUsernameChange f (LoginPage opts) =
    LoginPage { opts | onUsernameChange = Just f }


{-| Set the message sent when the password field changes
-}
withOnPasswordChange : (String -> msg) -> LoginPage msg -> LoginPage msg
withOnPasswordChange f (LoginPage opts) =
    LoginPage { opts | onPasswordChange = Just f }


{-| Set the message sent when "show password" is toggled
-}
withOnShowPasswordToggle : msg -> LoginPage msg -> LoginPage msg
withOnShowPasswordToggle msg (LoginPage opts) =
    LoginPage { opts | onShowPasswordToggle = Just msg }


{-| Set the message sent when the remember-me checkbox is toggled
-}
withOnRememberMeToggle : (Bool -> msg) -> LoginPage msg -> LoginPage msg
withOnRememberMeToggle f (LoginPage opts) =
    LoginPage { opts | onRememberMeToggle = Just f }


{-| Set the message sent when the submit button is clicked
-}
withOnSubmit : msg -> LoginPage msg -> LoginPage msg
withOnSubmit msg (LoginPage opts) =
    LoginPage { opts | onSubmit = Just msg }


{-| Set helper/error text displayed above the submit button
-}
withHelperText : String -> LoginPage msg -> LoginPage msg
withHelperText t (LoginPage opts) =
    LoginPage { opts | helperText = Just t }


{-| Add footer links (e.g. "Forgot password?", "Create account")
-}
withFooterLinks : List { label : String, onPress : Maybe msg } -> LoginPage msg -> LoginPage msg
withFooterLinks links (LoginPage opts) =
    LoginPage { opts | footerLinks = links }


staticField : Theme -> List (Element.Attribute msg) -> String -> String -> Element msg
staticField theme attrs placeholder value =
    Element.el
        (attrs
            ++ [ Bg.color (Theme.backgroundSecondary theme)
               , Font.color (Theme.textSubtle theme)
               ]
        )
        (Element.text
            (if String.isEmpty value then
                placeholder

             else
                value
            )
        )


{-| Render the LoginPage as an `Element msg`
-}
toMarkup : Theme -> LoginPage msg -> Element msg
toMarkup theme (LoginPage opts) =
    let
        fieldAttrs =
            [ Element.width Element.fill
            , Bg.color (Theme.backgroundDefault theme)
            , Border.rounded Tokens.radiusMd
            , Border.solid
            , Border.width 1
            , Border.color (Theme.borderDefault theme)
            , Font.size Tokens.fontSizeMd
            , Font.color (Theme.text theme)
            , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
            ]

        labelEl labelText =
            Element.el
                [ Font.size Tokens.fontSizeSm
                , Font.color (Theme.text theme)
                , Font.bold
                ]
                (Element.text labelText)

        brandEl =
            case opts.brandText of
                Just t ->
                    Element.el
                        [ Element.centerX
                        , Font.bold
                        , Font.size Tokens.fontSize2xl
                        , Font.color (Theme.primary theme)
                        , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerLg, left = 0 }
                        ]
                        (Element.text t)

                Nothing ->
                    Element.none

        titleEl =
            Element.el
                [ Font.bold
                , Font.size Tokens.fontSize2xl
                , Font.color (Theme.text theme)
                ]
                (Element.text opts.title)

        subtitleEl =
            case opts.subtitle of
                Just s ->
                    Element.el
                        [ Font.size Tokens.fontSizeMd
                        , Font.color (Theme.textSubtle theme)
                        ]
                        (Element.text s)

                Nothing ->
                    Element.none

        usernameInput =
            case opts.onUsernameChange of
                Just onChange ->
                    Input.username fieldAttrs
                        { onChange = onChange
                        , text = opts.username
                        , placeholder =
                            Just
                                (Input.placeholder [ Font.color (Theme.textSubtle theme) ]
                                    (Element.text opts.usernameLabel)
                                )
                        , label = Input.labelHidden opts.usernameLabel
                        }

                Nothing ->
                    staticField theme fieldAttrs opts.usernameLabel opts.username

        usernameField =
            Element.column [ Element.width Element.fill, Element.spacing Tokens.spacerXs ]
                [ labelEl opts.usernameLabel
                , usernameInput
                ]

        showPasswordBtn =
            Input.button
                [ Font.size Tokens.fontSizeSm
                , Font.color (Theme.primary theme)
                ]
                { onPress = opts.onShowPasswordToggle
                , label =
                    Element.text
                        (if opts.showPassword then
                            "Hide"

                         else
                            "Show"
                        )
                }

        passwordInput =
            case opts.onPasswordChange of
                Just onChange ->
                    if opts.showPassword then
                        Input.text fieldAttrs
                            { onChange = onChange
                            , text = opts.password
                            , placeholder =
                                Just
                                    (Input.placeholder [ Font.color (Theme.textSubtle theme) ]
                                        (Element.text opts.passwordLabel)
                                    )
                            , label = Input.labelHidden opts.passwordLabel
                            }

                    else
                        Input.currentPassword fieldAttrs
                            { onChange = onChange
                            , text = opts.password
                            , placeholder =
                                Just
                                    (Input.placeholder [ Font.color (Theme.textSubtle theme) ]
                                        (Element.text opts.passwordLabel)
                                    )
                            , label = Input.labelHidden opts.passwordLabel
                            , show = False
                            }

                Nothing ->
                    staticField theme fieldAttrs opts.passwordLabel
                        (if opts.showPassword then
                            opts.password

                         else
                            String.repeat (String.length opts.password) "•"
                        )

        passwordField =
            Element.column [ Element.width Element.fill, Element.spacing Tokens.spacerXs ]
                [ Element.row [ Element.width Element.fill, Element.spaceEvenly ]
                    [ labelEl opts.passwordLabel
                    , showPasswordBtn
                    ]
                , passwordInput
                ]

        rememberMeEl =
            case opts.onRememberMeToggle of
                Just onChange ->
                    Input.checkbox []
                        { onChange = onChange
                        , icon = Input.defaultCheckbox
                        , checked = opts.rememberMe
                        , label =
                            Input.labelRight
                                [ Font.size Tokens.fontSizeMd
                                , Font.color (Theme.text theme)
                                ]
                                (Element.text opts.rememberMeLabel)
                        }

                Nothing ->
                    Element.none

        helperEl =
            case opts.helperText of
                Just t ->
                    Element.el
                        [ Font.size Tokens.fontSizeSm
                        , Font.color (Theme.danger theme)
                        ]
                        (Element.text t)

                Nothing ->
                    Element.none

        submitBtn =
            Input.button
                [ Element.width Element.fill
                , Bg.color (Theme.primary theme)
                , Font.color (Theme.textOnDark theme)
                , Font.bold
                , Font.size Tokens.fontSizeMd
                , Border.rounded Tokens.radiusMd
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                ]
                { onPress = opts.onSubmit
                , label = Element.el [ Element.centerX ] (Element.text opts.submitLabel)
                }

        footerEl =
            if List.isEmpty opts.footerLinks then
                Element.none

            else
                Element.row
                    [ Element.centerX
                    , Element.spacing Tokens.spacerMd
                    ]
                    (List.map
                        (\lnk ->
                            Input.button
                                [ Font.size Tokens.fontSizeSm
                                , Font.color (Theme.primary theme)
                                ]
                                { onPress = lnk.onPress
                                , label = Element.text lnk.label
                                }
                        )
                        opts.footerLinks
                    )

        card =
            Element.column
                [ Element.width (Element.px 400)
                , Bg.color (Theme.backgroundDefault theme)
                , Border.rounded Tokens.radiusLg
                , Border.solid
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                , Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 4px 24px rgba(0,0,0,0.1)")
                , Element.padding Tokens.spacerXl
                , Element.spacing Tokens.spacerMd
                ]
                [ titleEl
                , subtitleEl
                , usernameField
                , passwordField
                , rememberMeEl
                , helperEl
                , submitBtn
                , footerEl
                ]
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Bg.color (Theme.backgroundSecondary theme)
        , Element.padding Tokens.spacer3xl
        , Element.spacing 0
        ]
        [ brandEl
        , Element.el [ Element.centerX ] card
        ]
