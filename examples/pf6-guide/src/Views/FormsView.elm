module Views.FormsView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Button as Button
import PF6.Checkbox as Checkbox
import PF6.Form as Form
import PF6.InputGroup as InputGroup
import PF6.NumberInput as NumberInput
import PF6.Slider as Slider
import PF6.Radio as Radio
import PF6.SearchInput as SearchInput
import PF6.Select as Select
import PF6.SimpleList as SimpleList
import PF6.Switch as Switch
import PF6.TextArea as TextArea
import PF6.TextInput as TextInput
import PF6.TextInputGroup as TextInputGroup
import PF6.Tile as Tile
import PF6.Tokens as Tokens
import PF6.ToggleGroup as ToggleGroup
import PF6.Wizard as Wizard
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
                , TextInput.textInput { value = model.successValue, onChange = SuccessTextChanged }
                    |> TextInput.withLabel "Success validation"
                    |> TextInput.withSuccess
                    |> TextInput.withHelperText "Looks good!"
                    |> TextInput.toMarkup
                , TextInput.textInput { value = model.errorValue, onChange = ErrorTextChanged }
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

        -- TEXT AREA
        , section "TextArea"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ TextArea.textArea { value = model.textAreaValue, onChange = TextAreaChanged }
                    |> TextArea.withLabel "Description"
                    |> TextArea.withPlaceholder "Enter a description..."
                    |> TextArea.withRows 4
                    |> TextArea.toMarkup
                , TextArea.textArea { value = "", onChange = TextAreaChanged }
                    |> TextArea.withLabel "Required field"
                    |> TextArea.withRequired
                    |> TextArea.withDanger
                    |> TextArea.withHelperText "This field is required."
                    |> TextArea.withRows 3
                    |> TextArea.toMarkup
                , TextArea.textArea { value = "Read-only content", onChange = TextAreaChanged }
                    |> TextArea.withLabel "Disabled"
                    |> TextArea.withDisabled
                    |> TextArea.toMarkup
                ]
            ]

        -- TILE
        , section "Tile"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerSm ]
                [ Tile.tile { title = "Option A", onSelect = TileSelected "a" }
                    |> (if model.selectedTile == Just "a" then
                            Tile.withSelected

                        else
                            identity
                       )
                    |> Tile.withIcon (Element.text "\u{2601}")
                    |> Tile.toMarkup
                , Tile.tile { title = "Option B", onSelect = TileSelected "b" }
                    |> (if model.selectedTile == Just "b" then
                            Tile.withSelected

                        else
                            identity
                       )
                    |> Tile.withIcon (Element.text "\u{26A1}")
                    |> Tile.toMarkup
                , Tile.tile { title = "Stacked", onSelect = TileSelected "c" }
                    |> (if model.selectedTile == Just "c" then
                            Tile.withSelected

                        else
                            identity
                       )
                    |> Tile.withIcon (Element.text "\u{2699}")
                    |> Tile.withStacked
                    |> Tile.toMarkup
                , Tile.tile { title = "Disabled", onSelect = NoOp }
                    |> Tile.withDisabled
                    |> Tile.toMarkup
                ]
            ]

        -- TOGGLE GROUP
        , section "ToggleGroup"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ ToggleGroup.toggleGroup
                    { items =
                        [ ToggleGroup.toggleItem { label = "Grid", isSelected = model.toggleViewMode == "grid", onToggle = ToggleViewMode "grid" }
                        , ToggleGroup.toggleItem { label = "List", isSelected = model.toggleViewMode == "list", onToggle = ToggleViewMode "list" }
                        , ToggleGroup.toggleItem { label = "Table", isSelected = model.toggleViewMode == "table", onToggle = ToggleViewMode "table" }
                        ]
                    }
                    |> ToggleGroup.toMarkup
                , ToggleGroup.toggleGroup
                    { items =
                        [ ToggleGroup.toggleItem { label = "Day", isSelected = False, onToggle = NoOp }
                            |> ToggleGroup.withItemIcon (Element.text "\u{1F4C5}")
                        , ToggleGroup.toggleItem { label = "Week", isSelected = True, onToggle = NoOp }
                            |> ToggleGroup.withItemIcon (Element.text "\u{1F5D3}")
                        , ToggleGroup.toggleItem { label = "Disabled", isSelected = False, onToggle = NoOp }
                            |> ToggleGroup.withItemDisabled
                        ]
                    }
                    |> ToggleGroup.withCompact
                    |> ToggleGroup.toMarkup
                ]
            ]

        -- SIMPLE LIST
        , section "SimpleList"
            [ Element.row [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ SimpleList.simpleList
                    [ SimpleList.simpleListItem "Dashboard" (SimpleListSelected "item1")
                        |> (if model.simpleListActive == "item1" then
                                SimpleList.withItemActive

                            else
                                identity
                           )
                    , SimpleList.simpleListItem "Settings" (SimpleListSelected "item2")
                        |> (if model.simpleListActive == "item2" then
                                SimpleList.withItemActive

                            else
                                identity
                           )
                    , SimpleList.simpleListItem "Users" (SimpleListSelected "item3")
                        |> (if model.simpleListActive == "item3" then
                                SimpleList.withItemActive

                            else
                                identity
                           )
                    , SimpleList.simpleListItem "Disabled" NoOp
                        |> SimpleList.withItemDisabled
                    ]
                    |> SimpleList.toMarkup
                , SimpleList.simpleList
                    [ SimpleList.simpleListItem "Item A" NoOp |> SimpleList.withItemActive
                    , SimpleList.simpleListItem "Item B" NoOp
                    , SimpleList.simpleListItem "Item C" NoOp
                    ]
                    |> SimpleList.withGrouped
                    |> SimpleList.toMarkup
                ]
            ]

        -- SLIDER
        , section "Slider"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Slider.slider { value = model.sliderValue, onChange = SliderChanged, min = 0, max = 100 }
                    |> Slider.withLabel "Volume"
                    |> Slider.withShowValue
                    |> Slider.withShowTicks
                    |> Slider.toMarkup
                , Slider.slider { value = model.sliderValue, onChange = SliderChanged, min = 0, max = 100 }
                    |> Slider.withLabel "With step (10)"
                    |> Slider.withStep 10
                    |> Slider.withShowValue
                    |> Slider.toMarkup
                , Slider.slider { value = 30, onChange = \_ -> NoOp, min = 0, max = 100 }
                    |> Slider.withLabel "Disabled"
                    |> Slider.withDisabled
                    |> Slider.withShowValue
                    |> Slider.toMarkup
                ]
            ]

        -- TEXT INPUT GROUP
        , section "TextInputGroup"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ TextInputGroup.textInputGroup { value = model.textInputGroupValue, onChange = TextInputGroupChanged }
                    |> TextInputGroup.withLabel "Amount"
                    |> TextInputGroup.withPrefix (Element.text "$")
                    |> TextInputGroup.withSuffix (Element.text ".00")
                    |> TextInputGroup.withPlaceholder "0"
                    |> TextInputGroup.toMarkup
                , TextInputGroup.textInputGroup { value = "", onChange = TextInputGroupChanged }
                    |> TextInputGroup.withLabel "Search"
                    |> TextInputGroup.withPrefix (Element.text "\u{1F50D}")
                    |> TextInputGroup.withPlaceholder "Search items..."
                    |> TextInputGroup.toMarkup
                ]
            ]

        -- INPUT GROUP
        , section "InputGroup"
            [ InputGroup.inputGroup
                [ InputGroup.inputGroupText "$"
                , InputGroup.inputGroupItem
                    (TextInput.textInput { value = model.textInputGroupValue, onChange = TextInputGroupChanged }
                        |> TextInput.withPlaceholder "Amount"
                        |> TextInput.toMarkup
                    )
                , InputGroup.inputGroupText ".00"
                ]
                |> InputGroup.toMarkup
            ]

        -- WIZARD
        , section "Wizard"
            [ Element.el [ Element.width Element.fill, Element.height (Element.px 400) ]
                (Wizard.wizard
                    { steps =
                        [ Wizard.wizardStep
                            { title = "Setup"
                            , content =
                                Element.column [ Element.spacing Tokens.spacerMd ]
                                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeLg ] (Element.text "Step 1: Setup")
                                    , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                                        [ Element.text "Configure the basic settings for your project." ]
                                    ]
                            }
                        , Wizard.wizardStep
                            { title = "Configure"
                            , content =
                                Element.column [ Element.spacing Tokens.spacerMd ]
                                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeLg ] (Element.text "Step 2: Configure")
                                    , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                                        [ Element.text "Set up advanced configuration options." ]
                                    ]
                            }
                        , Wizard.wizardStep
                            { title = "Review"
                            , content =
                                Element.column [ Element.spacing Tokens.spacerMd ]
                                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeLg ] (Element.text "Step 3: Review")
                                    , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                                        [ Element.text "Review your settings before finishing." ]
                                    ]
                            }
                        ]
                    , activeStep = model.wizardStep
                    }
                    |> Wizard.withOnStepChange WizardStepChanged
                    |> Wizard.withOnNext WizardNext
                    |> Wizard.withOnBack WizardBack
                    |> Wizard.withOnCancel WizardCancel
                    |> Wizard.withOnFinish WizardFinish
                    |> Wizard.toMarkup
                )
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
