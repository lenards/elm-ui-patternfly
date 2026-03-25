module Main exposing (main)

import Browser
import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Alert as Alert
import PF6.Avatar as Avatar
import PF6.Badge as Badge
import PF6.Banner as Banner
import PF6.Brand as Brand
import PF6.Breadcrumb as Breadcrumb
import PF6.Button as Button
import PF6.Card as Card
import PF6.Divider as Divider
import PF6.Hint as Hint
import PF6.Label as Label
import PF6.Masthead as Masthead
import PF6.NotificationBadge as NotificationBadge
import PF6.Pagination as Pagination
import PF6.Panel as Panel
import PF6.Progress as Progress
import PF6.ProgressStepper as ProgressStepper
import PF6.SearchInput as SearchInput
import PF6.Sidebar as Sidebar
import PF6.SimpleList as SimpleList
import PF6.Tabs as Tabs
import PF6.TextArea as TextArea
import PF6.TextInput as TextInput
import PF6.Tile as Tile
import PF6.Timestamp as Timestamp
import PF6.Title as Title
import PF6.ToggleGroup as ToggleGroup
import PF6.Theme as Theme exposing (Mode(..), Theme)
import PF6.Tokens as Tokens
import PF6.Truncate as Truncate



-- MODEL


type Page
    = Dashboard
    | Users
    | Settings


type alias User =
    { name : String
    , email : String
    , role : String
    , status : String
    , lastLogin : String
    }


type alias Model =
    { page : Page
    , searchValue : String
    , viewMode : String
    , notificationsExpanded : Bool
    , selectedUser : Maybe String
    , bannerVisible : Bool
    , currentPage : Int
    , activeTab : String
    , settingsDescription : String
    , selectedTier : Maybe String
    , themeMode : Mode
    }


sampleUsers : List User
sampleUsers =
    [ { name = "Jane Smith", email = "jane.smith@example.com", role = "Admin", status = "Active", lastLogin = "2024-03-15, 2:30 PM" }
    , { name = "John Doe", email = "john.doe@example.com", role = "Editor", status = "Active", lastLogin = "2024-03-14, 11:00 AM" }
    , { name = "Alice Johnson", email = "alice.j@example.com", role = "Viewer", status = "Active", lastLogin = "2024-03-13, 9:15 AM" }
    , { name = "Bob Williams", email = "bob.w@example.com", role = "Editor", status = "Inactive", lastLogin = "2024-02-28, 4:45 PM" }
    , { name = "Carol Davis", email = "carol.d@example.com", role = "Admin", status = "Active", lastLogin = "2024-03-15, 8:00 AM" }
    , { name = "David Brown", email = "david.b@example.com", role = "Viewer", status = "Pending", lastLogin = "Never" }
    ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( { page = Dashboard
      , searchValue = ""
      , viewMode = "table"
      , notificationsExpanded = False
      , selectedUser = Nothing
      , bannerVisible = True
      , currentPage = 1
      , activeTab = "overview"
      , settingsDescription = ""
      , selectedTier = Nothing
      , themeMode = Light
      }
    , Cmd.none
    )



-- MSG


type Msg
    = NoOp
    | NavigateTo Page
    | SearchChanged String
    | ViewModeChanged String
    | ToggleNotifications
    | SelectUser String
    | DismissBanner
    | PageChanged Int
    | TabSelected String
    | DescriptionChanged String
    | TierSelected String
    | ToggleTheme



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NavigateTo page ->
            ( { model | page = page }, Cmd.none )

        SearchChanged value ->
            ( { model | searchValue = value }, Cmd.none )

        ViewModeChanged mode ->
            ( { model | viewMode = mode }, Cmd.none )

        ToggleNotifications ->
            ( { model | notificationsExpanded = not model.notificationsExpanded }, Cmd.none )

        SelectUser name ->
            ( { model | selectedUser = Just name }, Cmd.none )

        DismissBanner ->
            ( { model | bannerVisible = False }, Cmd.none )

        PageChanged p ->
            ( { model | currentPage = p }, Cmd.none )

        TabSelected key ->
            ( { model | activeTab = key }, Cmd.none )

        DescriptionChanged value ->
            ( { model | settingsDescription = value }, Cmd.none )

        TierSelected tier ->
            ( { model | selectedTier = Just tier }, Cmd.none )

        ToggleTheme ->
            ( { model
                | themeMode =
                    case model.themeMode of
                        Light ->
                            Dark

                        Dark ->
                            Light
              }
            , Cmd.none
            )



-- VIEW


mastheadView : Theme -> Model -> Element Msg
mastheadView theme model =
    let
        toggleLabel =
            case model.themeMode of
                Light ->
                    "Dark mode"

                Dark ->
                    "Light mode"
    in
    Masthead.masthead
        |> Masthead.withBrand
            (Element.row [ Element.spacing Tokens.spacerSm ]
                [ Element.el [ Font.bold, Font.size Tokens.fontSizeXl, Font.color (Theme.textOnDark theme) ]
                    (Element.text "UserHub")
                , Element.el [ Font.size Tokens.fontSizeSm, Font.color (Element.rgb255 160 160 160) ]
                    (Element.text "Management Console")
                ]
            )
        |> Masthead.withToolbar
            (Element.row [ Element.spacing Tokens.spacerMd ]
                [ Button.secondary { label = toggleLabel, onPress = Just ToggleTheme }
                    |> Button.withSmallSize
                    |> Button.toMarkup theme
                , NotificationBadge.notificationBadge { count = 3, onClick = ToggleNotifications }
                    |> NotificationBadge.withExpanded model.notificationsExpanded
                    |> NotificationBadge.toMarkup theme
                , Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = "User" }
                    |> Avatar.withSmallSize
                    |> Avatar.withBorder
                    |> Avatar.toMarkup theme
                ]
            )
        |> Masthead.withInset
        |> Masthead.toMarkup theme


sidebarNav : Theme -> Model -> Element Msg
sidebarNav theme model =
    let
        navItem page label =
            let
                isActive =
                    model.page == page
            in
            Input.button
                [ Element.width Element.fill
                , Element.paddingXY 16 10
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
                { onPress = Just (NavigateTo page)
                , label = Element.text label
                }
    in
    Element.column
        [ Element.width (Element.px 200)
        , Element.height Element.fill
        , Bg.color (Theme.backgroundDefault theme)
        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
        , Border.color (Theme.borderDefault theme)
        ]
        [ Element.el [ Element.padding Tokens.spacerMd, Font.bold, Font.size Tokens.fontSizeMd, Font.color (Theme.textSubtle theme) ]
            (Element.text "NAVIGATION")
        , navItem Dashboard "Dashboard"
        , navItem Users "Users"
        , navItem Settings "Settings"
        ]


dashboardView : Theme -> Model -> Element Msg
dashboardView theme model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ -- Breadcrumb
          Breadcrumb.breadcrumb
            [ Breadcrumb.item { label = "Home", href = "#" }
            , Breadcrumb.currentItem "Dashboard"
            ]
            |> Breadcrumb.toMarkup theme

        -- Title
        , Title.title "Dashboard" |> Title.withH2 |> Title.toMarkup theme

        -- Stats cards
        , Element.wrappedRow [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
            [ statCard theme "Total Users" "6" "Active accounts" (Theme.primary theme)
            , statCard theme "Active" "5" "Currently active" (Theme.success theme)
            , statCard theme "Pending" "1" "Awaiting approval" (Theme.warning theme)
            , statCard theme "Storage" "72%" "Used capacity" (Theme.info theme)
            ]

        -- Onboarding progress
        , Card.card
            [ ProgressStepper.progressStepper
                [ ProgressStepper.step "Setup org"
                    |> ProgressStepper.withStepComplete
                    |> ProgressStepper.withStepDescription "Completed"
                , ProgressStepper.step "Add users"
                    |> ProgressStepper.withStepComplete
                    |> ProgressStepper.withStepDescription "6 users added"
                , ProgressStepper.step "Configure roles"
                    |> ProgressStepper.withStepCurrent
                    |> ProgressStepper.withStepDescription "In progress"
                , ProgressStepper.step "Go live"
                    |> ProgressStepper.withStepDescription "Not started"
                ]
                |> ProgressStepper.toMarkup theme
            ]
            |> Card.withTitle "Onboarding Progress"
            |> Card.toMarkup theme

        -- Hint
        , Hint.hint "You have 1 pending user invitation. Review and approve new users from the Users page."
            |> Hint.withTitle "Action needed"
            |> Hint.withActions
                (Button.link { label = "Go to Users", onPress = Just (NavigateTo Users) } |> Button.toMarkup theme)
            |> Hint.toMarkup theme

        -- Activity feed
        , Card.card
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ activityItem theme "Jane Smith" "updated user role to Admin" "2 hours ago"
                , Divider.divider |> Divider.toMarkup theme
                , activityItem theme "John Doe" "logged in" "5 hours ago"
                , Divider.divider |> Divider.toMarkup theme
                , activityItem theme "Carol Davis" "created new project" "1 day ago"
                , Divider.divider |> Divider.toMarkup theme
                , activityItem theme "David Brown" "account created (pending)" "2 days ago"
                ]
            ]
            |> Card.withTitle "Recent Activity"
            |> Card.toMarkup theme
        ]


statCard : Theme -> String -> String -> String -> Element.Color -> Element Msg
statCard theme title value subtitle color =
    Card.card
        [ Element.column [ Element.spacing Tokens.spacerXs ]
            [ Element.el [ Font.size Tokens.fontSize3xl, Font.bold, Font.color color ]
                (Element.text value)
            , Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ]
                (Element.text subtitle)
            ]
        ]
        |> Card.withTitle title
        |> Card.withCompact
        |> Card.toMarkup theme


activityItem : Theme -> String -> String -> String -> Element Msg
activityItem theme user action time =
    Element.row [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
        [ Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = user }
            |> Avatar.withSmallSize
            |> Avatar.toMarkup theme
        , Element.column [ Element.spacing 2, Element.width Element.fill ]
            [ Element.paragraph [ Font.size Tokens.fontSizeMd ]
                [ Element.el [ Font.bold ] (Element.text user)
                , Element.text (" " ++ action)
                ]
            , Timestamp.timestamp time
                |> Timestamp.withIcon
                |> Timestamp.toMarkup theme
            ]
        ]


usersView : Theme -> Model -> Element Msg
usersView theme model =
    let
        filteredUsers =
            if String.isEmpty model.searchValue then
                sampleUsers

            else
                List.filter
                    (\u -> String.contains (String.toLower model.searchValue) (String.toLower u.name))
                    sampleUsers
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ -- Breadcrumb
          Breadcrumb.breadcrumb
            [ Breadcrumb.item { label = "Home", href = "#" }
            , Breadcrumb.currentItem "Users"
            ]
            |> Breadcrumb.toMarkup theme

        -- Title + actions
        , Element.row [ Element.width Element.fill ]
            [ Title.title "Users" |> Title.withH2 |> Title.toMarkup theme
            , Element.el [ Element.alignRight ]
                (Button.primary { label = "+ Add User", onPress = Nothing } |> Button.toMarkup theme)
            ]

        -- Toolbar
        , Element.row [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
            [ Element.el [ Element.width (Element.fillPortion 3) ]
                (SearchInput.searchInput { value = model.searchValue, onChange = SearchChanged }
                    |> SearchInput.withPlaceholder "Search users..."
                    |> SearchInput.withClearMsg (SearchChanged "")
                    |> SearchInput.toMarkup theme
                )
            , ToggleGroup.toggleGroup
                { items =
                    [ ToggleGroup.toggleItem { label = "Table", isSelected = model.viewMode == "table", onToggle = ViewModeChanged "table" }
                    , ToggleGroup.toggleItem { label = "Cards", isSelected = model.viewMode == "cards", onToggle = ViewModeChanged "cards" }
                    ]
                }
                |> ToggleGroup.toMarkup theme
            ]

        -- User list
        , if model.viewMode == "cards" then
            userCardsView theme filteredUsers model

          else
            userTableView theme filteredUsers model

        -- Pagination
        , Pagination.pagination
            { page = model.currentPage
            , onPageChange = PageChanged
            }
            |> Pagination.withTotalItems (List.length sampleUsers)
            |> Pagination.withPerPage 10
            |> Pagination.toMarkup theme
        ]


roleLabel : Theme -> String -> Element Msg
roleLabel theme role =
    case role of
        "Admin" ->
            Label.label role |> Label.withRedColor |> Label.toMarkup theme

        "Editor" ->
            Label.label role |> Label.withBlueColor |> Label.toMarkup theme

        _ ->
            Label.label role |> Label.toMarkup theme


statusLabel : Theme -> String -> Element Msg
statusLabel theme status =
    case status of
        "Active" ->
            Label.label status |> Label.withGreenColor |> Label.toMarkup theme

        "Inactive" ->
            Label.label status |> Label.toMarkup theme

        "Pending" ->
            Label.label status |> Label.withGoldColor |> Label.toMarkup theme

        _ ->
            Label.label status |> Label.toMarkup theme


userTableView : Theme -> List User -> Model -> Element Msg
userTableView theme users model =
    let
        headerRow =
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Bg.color (Theme.backgroundSecondary theme)
                , Font.bold
                , Font.size Tokens.fontSizeSm
                , Font.color (Theme.textSubtle theme)
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderDefault theme)
                ]
                [ Element.el [ Element.width (Element.fillPortion 3) ] (Element.text "NAME")
                , Element.el [ Element.width (Element.fillPortion 2) ] (Element.text "ROLE")
                , Element.el [ Element.width (Element.fillPortion 2) ] (Element.text "STATUS")
                , Element.el [ Element.width (Element.fillPortion 3) ] (Element.text "LAST LOGIN")
                ]

        userRow user =
            let
                isSelected =
                    model.selectedUser == Just user.name
            in
            Input.button
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Bg.color
                    (if isSelected then
                        Element.rgb255 215 235 255

                     else
                        Theme.backgroundDefault theme
                    )
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                , Font.size Tokens.fontSizeMd
                ]
                { onPress = Just (SelectUser user.name)
                , label =
                    Element.row [ Element.width Element.fill ]
                        [ Element.row [ Element.width (Element.fillPortion 3), Element.spacing Tokens.spacerSm ]
                            [ Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = user.name }
                                |> Avatar.withSmallSize
                                |> Avatar.toMarkup theme
                            , Element.column [ Element.spacing 2 ]
                                [ Element.el [ Font.bold ] (Element.text user.name)
                                , Truncate.truncate user.email
                                    |> Truncate.withMaxChars 25
                                    |> Truncate.toMarkup theme
                                ]
                            ]
                        , Element.el [ Element.width (Element.fillPortion 2) ] (roleLabel theme user.role)
                        , Element.el [ Element.width (Element.fillPortion 2) ] (statusLabel theme user.status)
                        , Element.el [ Element.width (Element.fillPortion 3) ]
                            (Timestamp.timestamp user.lastLogin |> Timestamp.toMarkup theme)
                        ]
                }
    in
    Panel.panel
        (Element.column [ Element.width Element.fill ]
            (headerRow :: List.map userRow users)
        )
        |> Panel.withBordered
        |> Panel.toMarkup theme


userCardsView : Theme -> List User -> Model -> Element Msg
userCardsView theme users model =
    Element.wrappedRow [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
        (List.map
            (\user ->
                let
                    isSelected =
                        model.selectedUser == Just user.name
                in
                Card.card
                    [ Element.column [ Element.spacing Tokens.spacerSm ]
                        [ Element.row [ Element.spacing Tokens.spacerSm ]
                            [ Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = user.name }
                                |> Avatar.toMarkup theme
                            , Element.column [ Element.spacing 2 ]
                                [ Element.el [ Font.bold, Font.size Tokens.fontSizeMd ] (Element.text user.name)
                                , Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ] (Element.text user.email)
                                ]
                            ]
                        , Element.row [ Element.spacing Tokens.spacerSm ]
                            [ roleLabel theme user.role
                            , statusLabel theme user.status
                            ]
                        , Timestamp.timestamp user.lastLogin
                            |> Timestamp.withIcon
                            |> Timestamp.toMarkup theme
                        ]
                    ]
                    |> Card.withCompact
                    |> (if isSelected then
                            Card.withSelected

                        else
                            identity
                       )
                    |> Card.withSelectable
                    |> Card.toMarkup theme
            )
            users
        )


settingsView : Theme -> Model -> Element Msg
settingsView theme model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ -- Breadcrumb
          Breadcrumb.breadcrumb
            [ Breadcrumb.item { label = "Home", href = "#" }
            , Breadcrumb.currentItem "Settings"
            ]
            |> Breadcrumb.toMarkup theme

        -- Title
        , Title.title "Settings" |> Title.withH2 |> Title.toMarkup theme

        -- Tabs
        , Tabs.tabs
            { activeKey = model.activeTab
            , onSelect = TabSelected
            , tabs =
                [ Tabs.tab "overview" "Overview"
                , Tabs.tab "profile" "Profile"
                , Tabs.tab "plan" "Plan"
                ]
            }
            |> Tabs.toMarkup theme

        -- Tab content
        , case model.activeTab of
            "profile" ->
                profileTabView theme model

            "plan" ->
                planTabView theme model

            _ ->
                overviewTabView theme
        ]


overviewTabView : Theme -> Element Msg
overviewTabView theme =
    Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
        [ Card.card
            [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Element.row [ Element.spacing Tokens.spacerMd ]
                    [ Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text "Organization:")
                    , Element.el [ Font.bold ] (Element.text "Acme Corp")
                    ]
                , Element.row [ Element.spacing Tokens.spacerMd ]
                    [ Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text "Plan:")
                    , Label.label "Professional" |> Label.withBlueColor |> Label.toMarkup theme
                    ]
                , Element.row [ Element.spacing Tokens.spacerMd ]
                    [ Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text "Users:")
                    , Badge.badge 6 |> Badge.toMarkup theme
                    , Element.text "of 25 seats"
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs, Element.width Element.fill ]
                    [ Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text "Storage usage:")
                    , Progress.progress 72
                        |> Progress.withTitle "72% used"
                        |> Progress.toMarkup theme
                    ]
                ]
            ]
            |> Card.withTitle "Organization Overview"
            |> Card.toMarkup theme

        -- Alert
        , Alert.alert "Your trial period ends in 14 days. Upgrade to keep all features."
            |> Alert.withTitle "Trial expiring soon"
            |> Alert.withWarning
            |> Alert.withActions
                (Button.primary { label = "Upgrade now", onPress = Nothing }
                    |> Button.withSmallSize
                    |> Button.toMarkup theme
                )
            |> Alert.toMarkup theme
        ]


profileTabView : Theme -> Model -> Element Msg
profileTabView theme model =
    Card.card
        [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
            [ TextInput.textInput { value = "Acme Corp", onChange = \_ -> NoOp }
                |> TextInput.withLabel "Organization name"
                |> TextInput.toMarkup theme
            , TextInput.textInput { value = "admin@acme.com", onChange = \_ -> NoOp }
                |> TextInput.withLabel "Contact email"
                |> TextInput.withEmailType
                |> TextInput.toMarkup theme
            , TextArea.textArea { value = model.settingsDescription, onChange = DescriptionChanged }
                |> TextArea.withLabel "Description"
                |> TextArea.withPlaceholder "Tell us about your organization..."
                |> TextArea.withRows 4
                |> TextArea.toMarkup theme
            , Element.row [ Element.spacing Tokens.spacerSm ]
                [ Button.primary { label = "Save changes", onPress = Nothing } |> Button.toMarkup theme
                , Button.secondary { label = "Cancel", onPress = Nothing } |> Button.toMarkup theme
                ]
            ]
        ]
        |> Card.withTitle "Organization Profile"
        |> Card.toMarkup theme


planTabView : Theme -> Model -> Element Msg
planTabView theme model =
    Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
        [ Hint.hint "Select a plan that fits your team. You can upgrade or downgrade at any time."
            |> Hint.withTitle "Choose your plan"
            |> Hint.toMarkup theme
        , Element.wrappedRow [ Element.spacing Tokens.spacerMd ]
            [ Tile.tile { title = "Starter", onSelect = TierSelected "starter" }
                |> (if model.selectedTier == Just "starter" then
                        Tile.withSelected

                    else
                        identity
                   )
                |> Tile.withIcon (Element.text "\u{1F31F}")
                |> Tile.withStacked
                |> Tile.toMarkup theme
            , Tile.tile { title = "Professional", onSelect = TierSelected "pro" }
                |> (if model.selectedTier == Just "pro" || model.selectedTier == Nothing then
                        Tile.withSelected

                    else
                        identity
                   )
                |> Tile.withIcon (Element.text "\u{1F680}")
                |> Tile.withStacked
                |> Tile.toMarkup theme
            , Tile.tile { title = "Enterprise", onSelect = TierSelected "enterprise" }
                |> (if model.selectedTier == Just "enterprise" then
                        Tile.withSelected

                    else
                        identity
                   )
                |> Tile.withIcon (Element.text "\u{1F3E2}")
                |> Tile.withStacked
                |> Tile.toMarkup theme
            ]
        , Button.primary { label = "Update plan", onPress = Nothing } |> Button.toMarkup theme
        ]


mainContent : Theme -> Model -> Element Msg
mainContent theme model =
    let
        bannerEl =
            if model.bannerVisible then
                Banner.banner "Welcome to UserHub! Your account is set up and ready to go."
                    |> Banner.withSuccess
                    |> Banner.toMarkup theme

            else
                Element.none

        pageContent =
            case model.page of
                Dashboard ->
                    dashboardView theme model

                Users ->
                    usersView theme model

                Settings ->
                    settingsView theme model
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
        ]
        [ bannerEl
        , Element.el
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.scrollbarY
            , Bg.color (Theme.backgroundSecondary theme)
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            ]
            (Element.el
                [ Element.width (Element.maximum 960 Element.fill)
                , Element.padding Tokens.spacerLg
                , Element.spacing Tokens.spacerLg
                , Element.centerX
                ]
                pageContent
            )
        ]


view : Model -> Browser.Document Msg
view model =
    let
        theme =
            Theme.fromMode model.themeMode
    in
    { title = "UserHub — Management Console"
    , body =
        [ Element.layout
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            (Element.column
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
                [ mastheadView theme model
                , Element.row
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
                    ]
                    [ sidebarNav theme model
                    , mainContent theme model
                    ]
                ]
            )
        ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
