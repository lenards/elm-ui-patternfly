module Sidebar exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import Route exposing (Route(..))


type alias Config msg =
    { route : Route
    , theme : Theme
    , componentsExpanded : Bool
    , layoutsExpanded : Bool
    , onToggleComponents : msg
    , onToggleLayouts : msg
    , onNavigate : Route -> msg
    }


componentRoutes : List ( Route, String )
componentRoutes =
    [ ( AccordionRoute, "Accordion" )
    , ( ActionListRoute, "Action List" )
    , ( AlertRoute, "Alert" )
    , ( AvatarRoute, "Avatar" )
    , ( BackdropRoute, "Backdrop" )
    , ( BackToTopRoute, "Back to Top" )
    , ( BadgeRoute, "Badge" )
    , ( BannerRoute, "Banner" )
    , ( BrandRoute, "Brand" )
    , ( BreadcrumbRoute, "Breadcrumb" )
    , ( ButtonRoute, "Button" )
    , ( CardRoute, "Card" )
    , ( CheckboxRoute, "Checkbox" )
    , ( ClipboardCopyRoute, "Clipboard Copy" )
    , ( CodeBlockRoute, "Code Block" )
    , ( DataListRoute, "Data List" )
    , ( DescriptionListRoute, "Description List" )
    , ( DividerRoute, "Divider" )
    , ( DrawerRoute, "Drawer" )
    , ( DropdownRoute, "Dropdown" )
    , ( EmptyStateRoute, "Empty State" )
    , ( ExpandableSectionRoute, "Expandable Section" )
    , ( FormRoute, "Form" )
    , ( HelperTextRoute, "Helper Text" )
    , ( HintRoute, "Hint" )
    , ( IconRoute, "Icon" )
    , ( InputGroupRoute, "Input Group" )
    , ( JumpLinksRoute, "Jump Links" )
    , ( LabelRoute, "Label" )
    , ( ListRoute, "List" )
    , ( MastheadRoute, "Masthead" )
    , ( MenuRoute, "Menu" )
    , ( ModalRoute, "Modal" )
    , ( NotificationBadgeRoute, "Notification Badge" )
    , ( NotificationDrawerRoute, "Notification Drawer" )
    , ( NumberInputRoute, "Number Input" )
    , ( PageRoute, "Page" )
    , ( PaginationRoute, "Pagination" )
    , ( PanelRoute, "Panel" )
    , ( PopoverRoute, "Popover" )
    , ( ProgressRoute, "Progress" )
    , ( ProgressStepperRoute, "Progress Stepper" )
    , ( RadioRoute, "Radio" )
    , ( SearchInputRoute, "Search Input" )
    , ( SelectRoute, "Select" )
    , ( SimpleListRoute, "Simple List" )
    , ( SkeletonRoute, "Skeleton" )
    , ( SkipToContentRoute, "Skip to Content" )
    , ( SliderRoute, "Slider" )
    , ( SpinnerRoute, "Spinner" )
    , ( SwitchRoute, "Switch" )
    , ( TableRoute, "Table" )
    , ( TabsRoute, "Tabs" )
    , ( TextAreaRoute, "Text Area" )
    , ( TextInputRoute, "Text Input" )
    , ( TextInputGroupRoute, "Text Input Group" )
    , ( TileRoute, "Tile" )
    , ( TimestampRoute, "Timestamp" )
    , ( TitleRoute, "Title" )
    , ( ToggleGroupRoute, "Toggle Group" )
    , ( ToolbarRoute, "Toolbar" )
    , ( TooltipRoute, "Tooltip" )
    , ( TruncateRoute, "Truncate" )
    , ( WizardRoute, "Wizard" )
    ]


layoutRoutes : List ( Route, String )
layoutRoutes =
    [ ( BullseyeRoute, "Bullseye" )
    , ( FlexRoute, "Flex" )
    , ( GalleryRoute, "Gallery" )
    , ( GridRoute, "Grid" )
    , ( LevelRoute, "Level" )
    , ( SidebarLayoutRoute, "Sidebar" )
    , ( SplitRoute, "Split" )
    , ( StackRoute, "Stack" )
    ]


view : Config msg -> Element msg
view config =
    Element.column
        [ Element.width (Element.px 250)
        , Element.height Element.fill
        , Bg.color (Theme.backgroundDefault config.theme)
        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
        , Border.color (Theme.borderDefault config.theme)
        , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
        , Element.scrollbarY
        ]
        [ homeItem config
        , sectionHeader config.theme "Components" config.componentsExpanded config.onToggleComponents
        , if config.componentsExpanded then
            Element.column [ Element.width Element.fill ]
                (List.map (navItem config.theme config.route config.onNavigate) componentRoutes)

          else
            Element.none
        , sectionHeader config.theme "Layouts" config.layoutsExpanded config.onToggleLayouts
        , if config.layoutsExpanded then
            Element.column [ Element.width Element.fill ]
                (List.map (navItem config.theme config.route config.onNavigate) layoutRoutes)

          else
            Element.none
        ]


homeItem : Config msg -> Element msg
homeItem config =
    let
        isActive =
            config.route == Home
    in
    Input.button
        [ Element.width Element.fill
        , Element.paddingXY 16 12
        , Font.size 14
        , Font.bold
        , Font.color
            (if isActive then
                Theme.primary config.theme

             else
                Theme.text config.theme
            )
        , Bg.color
            (if isActive then
                Element.rgb255 215 235 255

             else
                Theme.backgroundDefault config.theme
            )
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
        , Border.color
            (if isActive then
                Theme.primary config.theme

             else
                Element.rgba 0 0 0 0
            )
        ]
        { onPress = Just (config.onNavigate Home)
        , label = Element.text "Home"
        }


sectionHeader : Theme -> String -> Bool -> msg -> Element msg
sectionHeader theme label isExpanded onToggle =
    Input.button
        [ Element.width Element.fill
        , Element.paddingXY 16 10
        , Font.size 13
        , Font.bold
        , Font.color (Theme.textSubtle theme)
        , Bg.color (Theme.backgroundSecondary theme)
        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
        , Border.color (Theme.borderDefault theme)
        ]
        { onPress = Just onToggle
        , label =
            Element.row [ Element.width Element.fill, Element.spacing 8 ]
                [ Element.text
                    (if isExpanded then
                        "v "

                     else
                        "> "
                    )
                , Element.text (String.toUpper label)
                ]
        }


navItem : Theme -> Route -> (Route -> msg) -> ( Route, String ) -> Element msg
navItem theme currentRoute onNavigate ( route, label ) =
    let
        isActive =
            currentRoute == route
    in
    Input.button
        [ Element.width Element.fill
        , Element.paddingXY 28 10
        , Font.size 14
        , Font.color
            (if isActive then
                Theme.primary theme

             else
                Theme.text theme
            )
        , Bg.color
            (if isActive then
                Element.rgb255 215 235 255

             else
                Theme.backgroundDefault theme
            )
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
        , Border.color
            (if isActive then
                Theme.primary theme

             else
                Element.rgba 0 0 0 0
            )
        ]
        { onPress = Just (onNavigate route)
        , label = Element.text label
        }
