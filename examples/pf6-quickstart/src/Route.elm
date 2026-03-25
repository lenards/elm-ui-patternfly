module Route exposing
    ( Route(..)
    , routeFromUrl
    , routeToFragment
    , routeToTitle
    )

import Url exposing (Url)


type Route
    = Home
    | AccordionRoute
    | ActionListRoute
    | AlertRoute
    | AvatarRoute
    | BackdropRoute
    | BackToTopRoute
    | BadgeRoute
    | BannerRoute
    | BrandRoute
    | BreadcrumbRoute
    | ButtonRoute
    | CardRoute
    | CheckboxRoute
    | ClipboardCopyRoute
    | CodeBlockRoute
    | DataListRoute
    | DescriptionListRoute
    | DividerRoute
    | DrawerRoute
    | DropdownRoute
    | EmptyStateRoute
    | ExpandableSectionRoute
    | FormRoute
    | HelperTextRoute
    | HintRoute
    | IconRoute
    | InputGroupRoute
    | JumpLinksRoute
    | LabelRoute
    | ListRoute
    | MastheadRoute
    | MenuRoute
    | ModalRoute
    | NotificationBadgeRoute
    | NotificationDrawerRoute
    | NumberInputRoute
    | PageRoute
    | PaginationRoute
    | PanelRoute
    | PopoverRoute
    | ProgressRoute
    | ProgressStepperRoute
    | RadioRoute
    | SearchInputRoute
    | SelectRoute
    | SimpleListRoute
    | SkeletonRoute
    | SkipToContentRoute
    | SliderRoute
    | SpinnerRoute
    | SwitchRoute
    | TableRoute
    | TabsRoute
    | TextAreaRoute
    | TextInputRoute
    | TextInputGroupRoute
    | TileRoute
    | TimestampRoute
    | TitleRoute
    | ToggleGroupRoute
    | ToolbarRoute
    | TooltipRoute
    | TruncateRoute
    | WizardRoute
    | BullseyeRoute
    | FlexRoute
    | GalleryRoute
    | GridRoute
    | LevelRoute
    | SidebarLayoutRoute
    | SplitRoute
    | StackRoute
    | NotFound


routeFromUrl : Url -> Route
routeFromUrl url =
    case url.fragment of
        Nothing ->
            Home

        Just "" ->
            Home

        Just "accordion" ->
            AccordionRoute

        Just "action-list" ->
            ActionListRoute

        Just "alert" ->
            AlertRoute

        Just "avatar" ->
            AvatarRoute

        Just "backdrop" ->
            BackdropRoute

        Just "back-to-top" ->
            BackToTopRoute

        Just "badge" ->
            BadgeRoute

        Just "banner" ->
            BannerRoute

        Just "brand" ->
            BrandRoute

        Just "breadcrumb" ->
            BreadcrumbRoute

        Just "button" ->
            ButtonRoute

        Just "card" ->
            CardRoute

        Just "checkbox" ->
            CheckboxRoute

        Just "clipboard-copy" ->
            ClipboardCopyRoute

        Just "code-block" ->
            CodeBlockRoute

        Just "data-list" ->
            DataListRoute

        Just "description-list" ->
            DescriptionListRoute

        Just "divider" ->
            DividerRoute

        Just "drawer" ->
            DrawerRoute

        Just "dropdown" ->
            DropdownRoute

        Just "empty-state" ->
            EmptyStateRoute

        Just "expandable-section" ->
            ExpandableSectionRoute

        Just "form" ->
            FormRoute

        Just "helper-text" ->
            HelperTextRoute

        Just "hint" ->
            HintRoute

        Just "icon" ->
            IconRoute

        Just "input-group" ->
            InputGroupRoute

        Just "jump-links" ->
            JumpLinksRoute

        Just "label" ->
            LabelRoute

        Just "list" ->
            ListRoute

        Just "masthead" ->
            MastheadRoute

        Just "menu" ->
            MenuRoute

        Just "modal" ->
            ModalRoute

        Just "notification-badge" ->
            NotificationBadgeRoute

        Just "notification-drawer" ->
            NotificationDrawerRoute

        Just "number-input" ->
            NumberInputRoute

        Just "page" ->
            PageRoute

        Just "pagination" ->
            PaginationRoute

        Just "panel" ->
            PanelRoute

        Just "popover" ->
            PopoverRoute

        Just "progress" ->
            ProgressRoute

        Just "progress-stepper" ->
            ProgressStepperRoute

        Just "radio" ->
            RadioRoute

        Just "search-input" ->
            SearchInputRoute

        Just "select" ->
            SelectRoute

        Just "simple-list" ->
            SimpleListRoute

        Just "skeleton" ->
            SkeletonRoute

        Just "skip-to-content" ->
            SkipToContentRoute

        Just "slider" ->
            SliderRoute

        Just "spinner" ->
            SpinnerRoute

        Just "switch" ->
            SwitchRoute

        Just "table" ->
            TableRoute

        Just "tabs" ->
            TabsRoute

        Just "text-area" ->
            TextAreaRoute

        Just "text-input" ->
            TextInputRoute

        Just "text-input-group" ->
            TextInputGroupRoute

        Just "tile" ->
            TileRoute

        Just "timestamp" ->
            TimestampRoute

        Just "title" ->
            TitleRoute

        Just "toggle-group" ->
            ToggleGroupRoute

        Just "toolbar" ->
            ToolbarRoute

        Just "tooltip" ->
            TooltipRoute

        Just "truncate" ->
            TruncateRoute

        Just "wizard" ->
            WizardRoute

        Just "bullseye" ->
            BullseyeRoute

        Just "flex" ->
            FlexRoute

        Just "gallery" ->
            GalleryRoute

        Just "grid" ->
            GridRoute

        Just "level" ->
            LevelRoute

        Just "sidebar-layout" ->
            SidebarLayoutRoute

        Just "split" ->
            SplitRoute

        Just "stack" ->
            StackRoute

        _ ->
            NotFound


routeToFragment : Route -> String
routeToFragment route =
    case route of
        Home ->
            ""

        AccordionRoute ->
            "accordion"

        ActionListRoute ->
            "action-list"

        AlertRoute ->
            "alert"

        AvatarRoute ->
            "avatar"

        BackdropRoute ->
            "backdrop"

        BackToTopRoute ->
            "back-to-top"

        BadgeRoute ->
            "badge"

        BannerRoute ->
            "banner"

        BrandRoute ->
            "brand"

        BreadcrumbRoute ->
            "breadcrumb"

        ButtonRoute ->
            "button"

        CardRoute ->
            "card"

        CheckboxRoute ->
            "checkbox"

        ClipboardCopyRoute ->
            "clipboard-copy"

        CodeBlockRoute ->
            "code-block"

        DataListRoute ->
            "data-list"

        DescriptionListRoute ->
            "description-list"

        DividerRoute ->
            "divider"

        DrawerRoute ->
            "drawer"

        DropdownRoute ->
            "dropdown"

        EmptyStateRoute ->
            "empty-state"

        ExpandableSectionRoute ->
            "expandable-section"

        FormRoute ->
            "form"

        HelperTextRoute ->
            "helper-text"

        HintRoute ->
            "hint"

        IconRoute ->
            "icon"

        InputGroupRoute ->
            "input-group"

        JumpLinksRoute ->
            "jump-links"

        LabelRoute ->
            "label"

        ListRoute ->
            "list"

        MastheadRoute ->
            "masthead"

        MenuRoute ->
            "menu"

        ModalRoute ->
            "modal"

        NotificationBadgeRoute ->
            "notification-badge"

        NotificationDrawerRoute ->
            "notification-drawer"

        NumberInputRoute ->
            "number-input"

        PageRoute ->
            "page"

        PaginationRoute ->
            "pagination"

        PanelRoute ->
            "panel"

        PopoverRoute ->
            "popover"

        ProgressRoute ->
            "progress"

        ProgressStepperRoute ->
            "progress-stepper"

        RadioRoute ->
            "radio"

        SearchInputRoute ->
            "search-input"

        SelectRoute ->
            "select"

        SimpleListRoute ->
            "simple-list"

        SkeletonRoute ->
            "skeleton"

        SkipToContentRoute ->
            "skip-to-content"

        SliderRoute ->
            "slider"

        SpinnerRoute ->
            "spinner"

        SwitchRoute ->
            "switch"

        TableRoute ->
            "table"

        TabsRoute ->
            "tabs"

        TextAreaRoute ->
            "text-area"

        TextInputRoute ->
            "text-input"

        TextInputGroupRoute ->
            "text-input-group"

        TileRoute ->
            "tile"

        TimestampRoute ->
            "timestamp"

        TitleRoute ->
            "title"

        ToggleGroupRoute ->
            "toggle-group"

        ToolbarRoute ->
            "toolbar"

        TooltipRoute ->
            "tooltip"

        TruncateRoute ->
            "truncate"

        WizardRoute ->
            "wizard"

        BullseyeRoute ->
            "bullseye"

        FlexRoute ->
            "flex"

        GalleryRoute ->
            "gallery"

        GridRoute ->
            "grid"

        LevelRoute ->
            "level"

        SidebarLayoutRoute ->
            "sidebar-layout"

        SplitRoute ->
            "split"

        StackRoute ->
            "stack"

        NotFound ->
            "not-found"


routeToTitle : Route -> String
routeToTitle route =
    case route of
        Home ->
            "Home"

        AccordionRoute ->
            "Accordion"

        ActionListRoute ->
            "Action List"

        AlertRoute ->
            "Alert"

        AvatarRoute ->
            "Avatar"

        BackdropRoute ->
            "Backdrop"

        BackToTopRoute ->
            "Back to Top"

        BadgeRoute ->
            "Badge"

        BannerRoute ->
            "Banner"

        BrandRoute ->
            "Brand"

        BreadcrumbRoute ->
            "Breadcrumb"

        ButtonRoute ->
            "Button"

        CardRoute ->
            "Card"

        CheckboxRoute ->
            "Checkbox"

        ClipboardCopyRoute ->
            "Clipboard Copy"

        CodeBlockRoute ->
            "Code Block"

        DataListRoute ->
            "Data List"

        DescriptionListRoute ->
            "Description List"

        DividerRoute ->
            "Divider"

        DrawerRoute ->
            "Drawer"

        DropdownRoute ->
            "Dropdown"

        EmptyStateRoute ->
            "Empty State"

        ExpandableSectionRoute ->
            "Expandable Section"

        FormRoute ->
            "Form"

        HelperTextRoute ->
            "Helper Text"

        HintRoute ->
            "Hint"

        IconRoute ->
            "Icon"

        InputGroupRoute ->
            "Input Group"

        JumpLinksRoute ->
            "Jump Links"

        LabelRoute ->
            "Label"

        ListRoute ->
            "List"

        MastheadRoute ->
            "Masthead"

        MenuRoute ->
            "Menu"

        ModalRoute ->
            "Modal"

        NotificationBadgeRoute ->
            "Notification Badge"

        NotificationDrawerRoute ->
            "Notification Drawer"

        NumberInputRoute ->
            "Number Input"

        PageRoute ->
            "Page"

        PaginationRoute ->
            "Pagination"

        PanelRoute ->
            "Panel"

        PopoverRoute ->
            "Popover"

        ProgressRoute ->
            "Progress"

        ProgressStepperRoute ->
            "Progress Stepper"

        RadioRoute ->
            "Radio"

        SearchInputRoute ->
            "Search Input"

        SelectRoute ->
            "Select"

        SimpleListRoute ->
            "Simple List"

        SkeletonRoute ->
            "Skeleton"

        SkipToContentRoute ->
            "Skip to Content"

        SliderRoute ->
            "Slider"

        SpinnerRoute ->
            "Spinner"

        SwitchRoute ->
            "Switch"

        TableRoute ->
            "Table"

        TabsRoute ->
            "Tabs"

        TextAreaRoute ->
            "Text Area"

        TextInputRoute ->
            "Text Input"

        TextInputGroupRoute ->
            "Text Input Group"

        TileRoute ->
            "Tile"

        TimestampRoute ->
            "Timestamp"

        TitleRoute ->
            "Title"

        ToggleGroupRoute ->
            "Toggle Group"

        ToolbarRoute ->
            "Toolbar"

        TooltipRoute ->
            "Tooltip"

        TruncateRoute ->
            "Truncate"

        WizardRoute ->
            "Wizard"

        BullseyeRoute ->
            "Bullseye"

        FlexRoute ->
            "Flex"

        GalleryRoute ->
            "Gallery"

        GridRoute ->
            "Grid"

        LevelRoute ->
            "Level"

        SidebarLayoutRoute ->
            "Sidebar"

        SplitRoute ->
            "Split"

        StackRoute ->
            "Stack"

        NotFound ->
            "Not Found"
