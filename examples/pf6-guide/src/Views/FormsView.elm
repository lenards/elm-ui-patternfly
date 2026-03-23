module Views.FormsView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Checkbox as Checkbox
import PF6.Form as Form
import PF6.NumberInput as NumberInput
import PF6.Radio as Radio
import PF6.SearchInput as SearchInput
import PF6.Select as Select
import PF6.Switch as Switch
import PF6.TextInput as TextInput
import PF6.Tokens as Tokens
import Types exposing (Model, Msg(..))


section : String -> List (Element Msg) -> Element Msg
section heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color Tokens.colorBackgroundDefault
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color Tokens.colorBorderDefault
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color Tokens.colorText ]
            (Element.text heading)
            :: items
        )


view : Model -> Element Msg
view model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color Tokens.colorText ]
            (Element.text "Forms")

        -- TEXT INPUT
        , section "TextInput"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ TextInput.textInput { value = model.textValue, onChange = TextChanged }
                    |> TextInput.withLabel "Default"
                    |> TextInput.withPlaceholder "Enter text..."
                    |> TextInput.toMarkup
                , TextInput.textInput { value = "", onChange = TextChanged }
                    |> TextInput.withLabel "Success validation"
                    |> TextInput.withSuccess
                    |> TextInput.withHelperText "Looks good!"
                    |> TextInput.toMarkup
                , TextInput.textInput { value = "", onChange = TextChanged }
                    |> TextInput.withLabel "Error validation"
                    |> TextInput.withDanger
                    |> TextInput.withHelperText "This field is required."
                    |> TextInput.toMarkup
                , TextInput.textInput { value = "disabled", onChange = TextChanged }
                    |> TextInput.withLabel "Disabled"
                    |> TextInput.withDisabled
                    |> TextInput.toMarkup
                ]
            ]

        -- SEARCH INPUT
        , section "SearchInput"
            [ SearchInput.searchInput { value = model.searchValue, onChange = SearchChanged }
                |> SearchInput.withPlaceholder "Search components..."
                |> SearchInput.withClearMsg (SearchChanged "")
                |> SearchInput.withSubmitMsg NoOp
                |> SearchInput.withHints
                    (if String.isEmpty model.searchValue then
                        []

                     else
                        [ "Button", "Badge", "Banner" ]
                            |> List.filter (String.contains model.searchValue)
                    )
                |> SearchInput.toMarkup
            ]

        -- NUMBER INPUT
        , section "NumberInput"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ NumberInput.numberInput { value = model.numberValue, onChange = NumberChanged }
                    |> NumberInput.withLabel "Quantity"
                    |> NumberInput.withMin 0
                    |> NumberInput.withMax 100
                    |> NumberInput.toMarkup
                , NumberInput.numberInput { value = 50, onChange = NumberChanged }
                    |> NumberInput.withLabel "Percentage"
                    |> NumberInput.withMin 0
                    |> NumberInput.withMax 100
                    |> NumberInput.withStep 5
                    |> NumberInput.withUnit "%"
                    |> NumberInput.toMarkup
                ]
            ]

        -- CHECKBOX
        , section "Checkbox"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Checkbox.checkbox { id = "cb1", onChange = CheckboxToggled }
                    |> Checkbox.withLabel "Default checkbox"
                    |> Checkbox.withChecked model.checkboxChecked
                    |> Checkbox.toMarkup
                , Checkbox.checkbox { id = "cb2", onChange = \_ -> NoOp }
                    |> Checkbox.withLabel "Checked by default"
                    |> Checkbox.withChecked True
                    |> Checkbox.withDescription "This is the description text"
                    |> Checkbox.toMarkup
                , Checkbox.checkbox { id = "cb3", onChange = \_ -> NoOp }
                    |> Checkbox.withLabel "Disabled"
                    |> Checkbox.withDisabled
                    |> Checkbox.toMarkup
                ]
            ]

        -- RADIO
        , section "Radio"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Radio.radio { id = "r1", onChange = \_ -> RadioSelected "option1" }
                    |> Radio.withLabel "Option 1"
                    |> Radio.withChecked (model.radioSelected == Just "option1")
                    |> Radio.toMarkup
                , Radio.radio { id = "r2", onChange = \_ -> RadioSelected "option2" }
                    |> Radio.withLabel "Option 2"
                    |> Radio.withChecked (model.radioSelected == Just "option2")
                    |> Radio.withDescription "With a description"
                    |> Radio.toMarkup
                , Radio.radio { id = "r3", onChange = \_ -> NoOp }
                    |> Radio.withLabel "Disabled"
                    |> Radio.withDisabled
                    |> Radio.toMarkup
                ]
            ]

        -- SWITCH
        , section "Switch"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Switch.switch { onChange = SwitchToggled }
                    |> Switch.withLabel "Feature enabled"
                    |> Switch.withLabelOff "Feature disabled"
                    |> Switch.withChecked model.switchOn
                    |> Switch.toMarkup
                , Switch.switch { onChange = \_ -> NoOp }
                    |> Switch.withLabel "No label switch"
                    |> Switch.withChecked True
                    |> Switch.toMarkup
                , Switch.switch { onChange = \_ -> NoOp }
                    |> Switch.withLabel "Disabled"
                    |> Switch.withDisabled
                    |> Switch.toMarkup
                ]
            ]

        -- SELECT
        , section "Select"
            [ Select.select
                { selected = model.selectValue
                , isOpen = model.selectOpen
                , onToggle = SelectToggled
                , onSelect = SelectChosen
                , options =
                    [ Select.option "react" "React"
                    , Select.option "angular" "Angular"
                    , Select.option "vue" "Vue"
                    , Select.optionGroup "Other"
                        [ Select.option "elm" "Elm"
                        , Select.option "svelte" "Svelte"
                        ]
                    ]
                }
                |> Select.withLabel "Framework"
                |> Select.withPlaceholder "Select a framework..."
                |> Select.withHelperText "Choose your frontend framework"
                |> Select.toMarkup
            ]

        -- FORM LAYOUT
        , section "Form (full layout)"
            [ Form.form
                [ Form.formGroup
                    (TextInput.textInput { value = "", onChange = TextChanged }
                        |> TextInput.withPlaceholder "Jane Doe"
                        |> TextInput.toMarkup
                    )
                    |> Form.withLabel "Full name"
                    |> Form.withRequired
                    |> Form.groupToMarkup
                , Form.formGroup
                    (TextInput.textInput { value = "", onChange = TextChanged }
                        |> TextInput.withEmailType
                        |> TextInput.withPlaceholder "jane@example.com"
                        |> TextInput.toMarkup
                    )
                    |> Form.withLabel "Email"
                    |> Form.withRequired
                    |> Form.withHelperText "We'll never share your email."
                    |> Form.groupToMarkup
                , Form.formGroup
                    (Checkbox.checkbox { id = "terms", onChange = CheckboxToggled }
                        |> Checkbox.withLabel "I agree to the terms and conditions"
                        |> Checkbox.withChecked model.checkboxChecked
                        |> Checkbox.toMarkup
                    )
                    |> Form.groupToMarkup
                ]
                |> Form.toMarkup
            ]
        ]
