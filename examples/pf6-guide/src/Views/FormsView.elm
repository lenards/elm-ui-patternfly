module Views.FormsView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Button as Button
import PF6.Checkbox as Checkbox
import PF6.DatePicker as DatePicker
import PF6.FileUpload as FileUpload
import PF6.Form as Form
import PF6.InlineEdit as InlineEdit
import PF6.InputGroup as InputGroup
import PF6.NumberInput as NumberInput
import PF6.Radio as Radio
import PF6.SearchInput as SearchInput
import PF6.Select as Select
import PF6.SimpleList as SimpleList
import PF6.Slider as Slider
import PF6.Switch as Switch
import PF6.TextArea as TextArea
import PF6.TextInput as TextInput
import PF6.TextInputGroup as TextInputGroup
import PF6.Theme as Theme exposing (Theme)
import PF6.Tile as Tile
import PF6.Tokens as Tokens
import PF6.ToggleGroup as ToggleGroup
import PF6.Wizard as Wizard
import Types exposing (Model, Msg(..))


section : Theme -> String -> List (Element Msg) -> Element Msg
section theme heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color (Theme.backgroundDefault theme)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color (Theme.text theme) ]
            (Element.text heading)
            :: items
        )


view : Model -> Element Msg
view model =
    let
        theme =
            Theme.fromMode model.themeMode
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color (Theme.text theme) ]
            (Element.text "Forms")

        -- TEXT INPUT
        , section theme
            "TextInput"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ TextInput.textInput { value = model.textValue, onChange = TextChanged }
                    |> TextInput.withLabel "Default"
                    |> TextInput.withPlaceholder "Enter text..."
                    |> TextInput.toMarkup theme
                , TextInput.textInput { value = model.successValue, onChange = SuccessTextChanged }
                    |> TextInput.withLabel "Success validation"
                    |> TextInput.withSuccess
                    |> TextInput.withHelperText "Looks good!"
                    |> TextInput.toMarkup theme
                , TextInput.textInput { value = model.errorValue, onChange = ErrorTextChanged }
                    |> TextInput.withLabel "Error validation"
                    |> TextInput.withDanger
                    |> TextInput.withHelperText "This field is required."
                    |> TextInput.toMarkup theme
                , TextInput.textInput { value = "disabled", onChange = TextChanged }
                    |> TextInput.withLabel "Disabled"
                    |> TextInput.withDisabled
                    |> TextInput.toMarkup theme
                ]
            ]

        -- SEARCH INPUT
        , section theme
            "SearchInput"
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
                |> SearchInput.toMarkup theme
            ]

        -- NUMBER INPUT
        , section theme
            "NumberInput"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ NumberInput.numberInput { value = model.numberValue, onChange = NumberChanged }
                    |> NumberInput.withLabel "Quantity"
                    |> NumberInput.withMin 0
                    |> NumberInput.withMax 100
                    |> NumberInput.toMarkup theme
                , NumberInput.numberInput { value = 50, onChange = NumberChanged }
                    |> NumberInput.withLabel "Percentage"
                    |> NumberInput.withMin 0
                    |> NumberInput.withMax 100
                    |> NumberInput.withStep 5
                    |> NumberInput.withUnit "%"
                    |> NumberInput.toMarkup theme
                ]
            ]

        -- CHECKBOX
        , section theme
            "Checkbox"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Checkbox.checkbox { id = "cb1", onChange = CheckboxToggled }
                    |> Checkbox.withLabel "Default checkbox"
                    |> Checkbox.withChecked model.checkboxChecked
                    |> Checkbox.toMarkup theme
                , Checkbox.checkbox { id = "cb2", onChange = \_ -> NoOp }
                    |> Checkbox.withLabel "Checked by default"
                    |> Checkbox.withChecked True
                    |> Checkbox.withDescription "This is the description text"
                    |> Checkbox.toMarkup theme
                , Checkbox.checkbox { id = "cb3", onChange = \_ -> NoOp }
                    |> Checkbox.withLabel "Disabled"
                    |> Checkbox.withDisabled
                    |> Checkbox.toMarkup theme
                ]
            ]

        -- RADIO
        , section theme
            "Radio"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Radio.radio { id = "r1", onChange = \_ -> RadioSelected "option1" }
                    |> Radio.withLabel "Option 1"
                    |> Radio.withChecked (model.radioSelected == Just "option1")
                    |> Radio.toMarkup theme
                , Radio.radio { id = "r2", onChange = \_ -> RadioSelected "option2" }
                    |> Radio.withLabel "Option 2"
                    |> Radio.withChecked (model.radioSelected == Just "option2")
                    |> Radio.withDescription "With a description"
                    |> Radio.toMarkup theme
                , Radio.radio { id = "r3", onChange = \_ -> NoOp }
                    |> Radio.withLabel "Disabled"
                    |> Radio.withDisabled
                    |> Radio.toMarkup theme
                ]
            ]

        -- SWITCH
        , section theme
            "Switch"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Switch.switch { onChange = SwitchToggled }
                    |> Switch.withLabel "Feature enabled"
                    |> Switch.withLabelOff "Feature disabled"
                    |> Switch.withChecked model.switchOn
                    |> Switch.toMarkup theme
                , Switch.switch { onChange = \_ -> NoOp }
                    |> Switch.withLabel "No label switch"
                    |> Switch.withChecked True
                    |> Switch.toMarkup theme
                , Switch.switch { onChange = \_ -> NoOp }
                    |> Switch.withLabel "Disabled"
                    |> Switch.withDisabled
                    |> Switch.toMarkup theme
                ]
            ]

        -- SELECT
        , section theme
            "Select"
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
                |> Select.toMarkup theme
            ]

        -- TEXT AREA
        , section theme
            "TextArea"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ TextArea.textArea { value = model.textAreaValue, onChange = TextAreaChanged }
                    |> TextArea.withLabel "Description"
                    |> TextArea.withPlaceholder "Enter a description..."
                    |> TextArea.withRows 4
                    |> TextArea.toMarkup theme
                , TextArea.textArea { value = "", onChange = TextAreaChanged }
                    |> TextArea.withLabel "Required field"
                    |> TextArea.withRequired
                    |> TextArea.withDanger
                    |> TextArea.withHelperText "This field is required."
                    |> TextArea.withRows 3
                    |> TextArea.toMarkup theme
                , TextArea.textArea { value = "Read-only content", onChange = TextAreaChanged }
                    |> TextArea.withLabel "Disabled"
                    |> TextArea.withDisabled
                    |> TextArea.toMarkup theme
                ]
            ]

        -- TILE
        , section theme
            "Tile"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerSm ]
                [ Tile.tile { title = "Option A", onSelect = TileSelected "a" }
                    |> (if model.selectedTile == Just "a" then
                            Tile.withSelected

                        else
                            identity
                       )
                    |> Tile.withIcon (Element.text "\u{2601}")
                    |> Tile.toMarkup theme
                , Tile.tile { title = "Option B", onSelect = TileSelected "b" }
                    |> (if model.selectedTile == Just "b" then
                            Tile.withSelected

                        else
                            identity
                       )
                    |> Tile.withIcon (Element.text "\u{26A1}")
                    |> Tile.toMarkup theme
                , Tile.tile { title = "Stacked", onSelect = TileSelected "c" }
                    |> (if model.selectedTile == Just "c" then
                            Tile.withSelected

                        else
                            identity
                       )
                    |> Tile.withIcon (Element.text "\u{2699}")
                    |> Tile.withStacked
                    |> Tile.toMarkup theme
                , Tile.tile { title = "Disabled", onSelect = NoOp }
                    |> Tile.withDisabled
                    |> Tile.toMarkup theme
                ]
            ]

        -- TOGGLE GROUP
        , section theme
            "ToggleGroup"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ ToggleGroup.toggleGroup
                    { items =
                        [ ToggleGroup.toggleItem { label = "Grid", isSelected = model.toggleViewMode == "grid", onToggle = ToggleViewMode "grid" }
                        , ToggleGroup.toggleItem { label = "List", isSelected = model.toggleViewMode == "list", onToggle = ToggleViewMode "list" }
                        , ToggleGroup.toggleItem { label = "Table", isSelected = model.toggleViewMode == "table", onToggle = ToggleViewMode "table" }
                        ]
                    }
                    |> ToggleGroup.toMarkup theme
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
                    |> ToggleGroup.toMarkup theme
                ]
            ]

        -- SIMPLE LIST
        , section theme
            "SimpleList"
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
                    |> SimpleList.toMarkup theme
                , SimpleList.simpleList
                    [ SimpleList.simpleListItem "Item A" NoOp |> SimpleList.withItemActive
                    , SimpleList.simpleListItem "Item B" NoOp
                    , SimpleList.simpleListItem "Item C" NoOp
                    ]
                    |> SimpleList.withGrouped
                    |> SimpleList.toMarkup theme
                ]
            ]

        -- SLIDER
        , section theme
            "Slider"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Slider.slider { value = model.sliderValue, onChange = SliderChanged, min = 0, max = 100 }
                    |> Slider.withLabel "Volume"
                    |> Slider.withShowValue
                    |> Slider.withShowTicks
                    |> Slider.toMarkup theme
                , Slider.slider { value = model.sliderValue, onChange = SliderChanged, min = 0, max = 100 }
                    |> Slider.withLabel "With step (10)"
                    |> Slider.withStep 10
                    |> Slider.withShowValue
                    |> Slider.toMarkup theme
                , Slider.slider { value = 30, onChange = \_ -> NoOp, min = 0, max = 100 }
                    |> Slider.withLabel "Disabled"
                    |> Slider.withDisabled
                    |> Slider.withShowValue
                    |> Slider.toMarkup theme
                ]
            ]

        -- TEXT INPUT GROUP
        , section theme
            "TextInputGroup"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ TextInputGroup.textInputGroup { value = model.textInputGroupValue, onChange = TextInputGroupChanged }
                    |> TextInputGroup.withLabel "Amount"
                    |> TextInputGroup.withPrefix (Element.text "$")
                    |> TextInputGroup.withSuffix (Element.text ".00")
                    |> TextInputGroup.withPlaceholder "0"
                    |> TextInputGroup.toMarkup theme
                , TextInputGroup.textInputGroup { value = "", onChange = TextInputGroupChanged }
                    |> TextInputGroup.withLabel "Search"
                    |> TextInputGroup.withPrefix (Element.text "\u{1F50D}")
                    |> TextInputGroup.withPlaceholder "Search items..."
                    |> TextInputGroup.toMarkup theme
                ]
            ]

        -- INPUT GROUP
        , section theme
            "InputGroup"
            [ InputGroup.inputGroup
                [ InputGroup.inputGroupText "$"
                , InputGroup.inputGroupItem
                    (TextInput.textInput { value = model.textInputGroupValue, onChange = TextInputGroupChanged }
                        |> TextInput.withPlaceholder "Amount"
                        |> TextInput.toMarkup theme
                    )
                , InputGroup.inputGroupText ".00"
                ]
                |> InputGroup.toMarkup theme
            ]

        -- WIZARD
        , section theme
            "Wizard"
            [ Element.el [ Element.width Element.fill, Element.height (Element.px 400) ]
                (Wizard.wizard
                    { steps =
                        [ Wizard.wizardStep
                            { title = "Setup"
                            , content =
                                Element.column [ Element.spacing Tokens.spacerMd ]
                                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeLg ] (Element.text "Step 1: Setup")
                                    , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.textSubtle theme) ]
                                        [ Element.text "Configure the basic settings for your project." ]
                                    ]
                            }
                        , Wizard.wizardStep
                            { title = "Configure"
                            , content =
                                Element.column [ Element.spacing Tokens.spacerMd ]
                                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeLg ] (Element.text "Step 2: Configure")
                                    , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.textSubtle theme) ]
                                        [ Element.text "Set up advanced configuration options." ]
                                    ]
                            }
                        , Wizard.wizardStep
                            { title = "Review"
                            , content =
                                Element.column [ Element.spacing Tokens.spacerMd ]
                                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeLg ] (Element.text "Step 3: Review")
                                    , Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.textSubtle theme) ]
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
                    |> Wizard.toMarkup theme
                )
            ]

        -- FORM LAYOUT
        , section theme
            "Form (full layout)"
            [ Form.form
                [ Form.formGroup
                    (TextInput.textInput { value = "", onChange = TextChanged }
                        |> TextInput.withPlaceholder "Jane Doe"
                        |> TextInput.toMarkup theme
                    )
                    |> Form.withLabel "Full name"
                    |> Form.withRequired
                    |> Form.groupToMarkup theme
                , Form.formGroup
                    (TextInput.textInput { value = "", onChange = TextChanged }
                        |> TextInput.withEmailType
                        |> TextInput.withPlaceholder "jane@example.com"
                        |> TextInput.toMarkup theme
                    )
                    |> Form.withLabel "Email"
                    |> Form.withRequired
                    |> Form.withHelperText "We'll never share your email."
                    |> Form.groupToMarkup theme
                , Form.formGroup
                    (Checkbox.checkbox { id = "terms", onChange = CheckboxToggled }
                        |> Checkbox.withLabel "I agree to the terms and conditions"
                        |> Checkbox.withChecked model.checkboxChecked
                        |> Checkbox.toMarkup theme
                    )
                    |> Form.groupToMarkup theme
                ]
                |> Form.toMarkup theme
            ]

        -- DATE PICKER
        , section theme
            "DatePicker"
            [ DatePicker.datePicker { year = model.datePickerYear, month = model.datePickerMonth }
                |> DatePicker.withSelectedDate model.datePickerSelected
                |> DatePicker.withOnPrevMonth DatePickerPrev
                |> DatePicker.withOnNextMonth DatePickerNext
                |> DatePicker.withOnSelect DatePickerSelect
                |> DatePicker.toMarkup theme
            ]

        -- FILE UPLOAD
        , section theme
            "FileUpload"
            [ (case model.uploadFileName of
                    Just name ->
                        FileUpload.fileUpload |> FileUpload.withFileName name

                    Nothing ->
                        FileUpload.fileUpload
              )
                |> FileUpload.withIsDragOver model.uploadDragOver
                |> FileUpload.withOnClear UploadClear
                |> FileUpload.withHelperText "Accepted file types: .jpg, .png, .pdf"
                |> FileUpload.toMarkup theme
            ]

        -- INLINE EDIT
        , section theme
            "InlineEdit"
            [ InlineEdit.inlineEdit model.inlineValue
                |> InlineEdit.withEditing model.inlineEditing
                |> InlineEdit.withOnEdit InlineEditStart
                |> InlineEdit.withOnChange InlineEditChange
                |> InlineEdit.withOnSave InlineEditSave
                |> InlineEdit.withOnCancel InlineEditCancel
                |> InlineEdit.toMarkup theme
            ]
        ]
