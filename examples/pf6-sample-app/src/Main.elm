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



-- VIEW


mastheadView : Model -> Element Msg
mastheadView model =
    Masthead.masthead
        |> Masthead.withBrand
            (Element.row [ Element.spacing Tokens.spacerSm ]
                [ Element.el [ Font.bold, Font.size Tokens.fontSizeXl, Font.color Tokens.colorTextOnDark ]
                    (Element.text "UserHub")
                , Element.el [ Font.size Tokens.fontSizeSm, Font.color (Element.rgb255 160 160 160) ]
                    (Element.text "Management Console")
                ]
            )
        |> Masthead.withToolbar
            (Element.row [ Element.spacing Tokens.spacerMd ]
                [ NotificationBadge.notificationBadge { count = 3, onClick = ToggleNotifications }
                    |> NotificationBadge.withExpanded model.notificationsExpanded
                    |> NotificationBadge.toMarkup
                , Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = "User" }
                    |> Avatar.withSmallSize
                    |> Avatar.withBorder
                    |> Avatar.toMarkup
                ]
            )
        |> Masthead.withInset
        |> Masthead.toMarkup


sidebarNav : Model -> Element Msg
sidebarNav model =
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
                        Tokens.colorPrimary

                     else
                        Tokens.colorText
                    )
                , Bg.color
                    (if isActive then
                        Element.rgb255 215 235 255

                     else
                        Tokens.colorBackgroundDefault
                    )
                , Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
                , Border.color
                    (if isActive then
                        Tokens.colorPrimary

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
        , Bg.color Tokens.colorBackgroundDefault
        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
        , Border.color Tokens.colorBorderDefault
        ]
        [ Element.el [ Element.padding Tokens.spacerMd, Font.bold, Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
            (Element.text "NAVIGATION")
        , navItem Dashboard "Dashboard"
        , navItem Users "Users"
        , navItem Settings "Settings"
        ]


dashboardView : Model -> Element Msg
dashboardView model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ -- Breadcrumb
          Breadcrumb.breadcrumb
            [ Breadcrumb.item { label = "Home", href = "#" }
            , Breadcrumb.currentItem "Dashboard"
            ]
            |> Breadcrumb.toMarkup

        -- Title
        , Title.title "Dashboard" |> Title.withH2 |> Title.toMarkup

        -- Stats cards
        , Element.wrappedRow [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
            [ statCard "Total Users" "6" "Active accounts" Tokens.colorPrimary
            , statCard "Active" "5" "Currently active" Tokens.colorSuccess
            , statCard "Pending" "1" "Awaiting approval" Tokens.colorWarning
            , statCard "Storage" "72%" "Used capacity" Tokens.colorInfo
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
                |> ProgressStepper.toMarkup
            ]
            |> Card.withTitle "Onboarding Progress"
            |> Card.toMarkup

        -- Hint
        , Hint.hint "You have 1 pending user invitation. Review and approve new users from the Users page."
            |> Hint.withTitle "Action needed"
            |> Hint.withActions
                (Button.link { label = "Go to Users", onPress = Just (NavigateTo Users) } |> Button.toMarkup)
            |> Hint.toMarkup

        -- Activity feed
        , Card.card
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ activityItem "Jane Smith" "updated user role to Admin" "2 hours ago"
                , Divider.divider |> Divider.toMarkup
                , activityItem "John Doe" "logged in" "5 hours ago"
                , Divider.divider |> Divider.toMarkup
                , activityItem "Carol Davis" "created new project" "1 day ago"
                , Divider.divider |> Divider.toMarkup
                , activityItem "David Brown" "account created (pending)" "2 days ago"
                ]
            ]
            |> Card.withTitle "Recent Activity"
            |> Card.toMarkup
        ]


statCard : String -> String -> String -> Element.Color -> Element Msg
statCard title value subtitle color =
    Card.card
        [ Element.column [ Element.spacing Tokens.spacerXs ]
            [ Element.el [ Font.size Tokens.fontSize3xl, Font.bold, Font.color color ]
                (Element.text value)
            , Element.el [ Font.size Tokens.fontSizeSm, Font.color Tokens.colorTextSubtle ]
                (Element.text subtitle)
            ]
        ]
        |> Card.withTitle title
        |> Card.withCompact
        |> Card.toMarkup


activityItem : String -> String -> String -> Element Msg
activityItem user action time =
    Element.row [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
        [ Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = user }
            |> Avatar.withSmallSize
            |> Avatar.toMarkup
        , Element.column [ Element.spacing 2, Element.width Element.fill ]
            [ Element.paragraph [ Font.size Tokens.fontSizeMd ]
                [ Element.el [ Font.bold ] (Element.text user)
                , Element.text (" " ++ action)
                ]
            , Timestamp.timestamp time
                |> Timestamp.withIcon
                |> Timestamp.toMarkup
            ]
        ]


usersView : Model -> Element Msg
usersView model =
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
            |> Breadcrumb.toMarkup

        -- Title + actions
        , Element.row [ Element.width Element.fill ]
            [ Title.title "Users" |> Title.withH2 |> Title.toMarkup
            , Element.el [ Element.alignRight ]
                (Button.primary { label = "+ Add User", onPress = Nothing } |> Button.toMarkup)
            ]

        -- Toolbar
        , Element.row [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
            [ Element.el [ Element.width (Element.fillPortion 3) ]
                (SearchInput.searchInput { value = model.searchValue, onChange = SearchChanged }
                    |> SearchInput.withPlaceholder "Search users..."
                    |> SearchInput.withClearMsg (SearchChanged "")
                    |> SearchInput.toMarkup
                )
            , ToggleGroup.toggleGroup
                { items =
                    [ ToggleGroup.toggleItem { label = "Table", isSelected = model.viewMode == "table", onToggle = ViewModeChanged "table" }
                    , ToggleGroup.toggleItem { label = "Cards", isSelected = model.viewMode == "cards", onToggle = ViewModeChanged "cards" }
                    ]
                }
                |> ToggleGroup.toMarkup
            ]

        -- User list
        , if model.viewMode == "cards" then
            userCardsView filteredUsers model

          else
            userTableView filteredUsers model

        -- Pagination
        , Pagination.pagination
            { page = model.currentPage
            , onPageChange = PageChanged
            }
            |> Pagination.withTotalItems (List.length sampleUsers)
            |> Pagination.withPerPage 10
            |> Pagination.toMarkup
        ]


roleLabel : String -> Element Msg
roleLabel role =
    case role of
        "Admin" ->
            Label.label role |> Label.withRedColor |> Label.toMarkup

        "Editor" ->
            Label.label role |> Label.withBlueColor |> Label.toMarkup

        _ ->
            Label.label role |> Label.toMarkup


statusLabel : String -> Element Msg
statusLabel status =
    case status of
        "Active" ->
            Label.label status |> Label.withGreenColor |> Label.toMarkup

        "Inactive" ->
            Label.label status |> Label.toMarkup

        "Pending" ->
            Label.label status |> Label.withGoldColor |> Label.toMarkup

        _ ->
            Label.label status |> Label.toMarkup


userTableView : List User -> Model -> Element Msg
userTableView users model =
    let
        headerRow =
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Bg.color Tokens.colorBackgroundSecondary
                , Font.bold
                , Font.size Tokens.fontSizeSm
                , Font.color Tokens.colorTextSubtle
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color Tokens.colorBorderDefault
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
                        Tokens.colorBackgroundDefault
                    )
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color Tokens.colorBorderSubtle
                , Font.size Tokens.fontSizeMd
                ]
                { onPress = Just (SelectUser user.name)
                , label =
                    Element.row [ Element.width Element.fill ]
                        [ Element.row [ Element.width (Element.fillPortion 3), Element.spacing Tokens.spacerSm ]
                            [ Avatar.avatar { src = "https://www.patternfly.org/images/avatarImg.svg", alt = user.name }
                                |> Avatar.withSmallSize
                                |> Avatar.toMarkup
                            , Element.column [ Element.spacing 2 ]
                                [ Element.el [ Font.bold ] (Element.text user.name)
                                , Truncate.truncate user.email
                                    |> Truncate.withMaxChars 25
                                    |> Truncate.toMarkup
                                ]
                            ]
                        , Element.el [ Element.width (Element.fillPortion 2) ] (roleLabel user.role)
                        , Element.el [ Element.width (Element.fillPortion 2) ] (statusLabel user.status)
                        , Element.el [ Element.width (Element.fillPortion 3) ]
                            (Timestamp.timestamp user.lastLogin |> Timestamp.toMarkup)
                        ]
                }
    in
    Panel.panel
        (Element.column [ Element.width Element.fill ]
            (headerRow :: List.map userRow users)
        )
        |> Panel.withBordered
        |> Panel.toMarkup


userCardsView : List User -> Model -> Element Msg
userCardsView users model =
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
                                |> Avatar.toMarkup
                            , Element.column [ Element.spacing 2 ]
                                [ Element.el [ Font.bold, Font.size Tokens.fontSizeMd ] (Element.text user.name)
                                , Element.el [ Font.size Tokens.fontSizeSm, Font.color Tokens.colorTextSubtle ] (Element.text user.email)
                                ]
                            ]
                        , Element.row [ Element.spacing Tokens.spacerSm ]
                            [ roleLabel user.role
                            , statusLabel user.status
                            ]
                        , Timestamp.timestamp user.lastLogin
                            |> Timestamp.withIcon
                            |> Timestamp.toMarkup
                        ]
                    ]
                    |> Card.withCompact
                    |> (if isSelected then
                            Card.withSelected

                        else
                            identity
                       )
                    |> Card.withSelectable
                    |> Card.toMarkup
            )
            users
        )


settingsView : Model -> Element Msg
settingsView model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ -- Breadcrumb
          Breadcrumb.breadcrumb
            [ Breadcrumb.item { label = "Home", href = "#" }
            , Breadcrumb.currentItem "Settings"
            ]
            |> Breadcrumb.toMarkup

        -- Title
        , Title.title "Settings" |> Title.withH2 |> Title.toMarkup

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
            |> Tabs.toMarkup

        -- Tab content
        , case model.activeTab of
            "profile" ->
                profileTabView model

            "plan" ->
                planTabView model

            _ ->
                overviewTabView
        ]


overviewTabView : Element Msg
overviewTabView =
    Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
        [ Card.card
            [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Element.row [ Element.spacing Tokens.spacerMd ]
                    [ Element.el [ Font.color Tokens.colorTextSubtle ] (Element.text "Organization:")
                    , Element.el [ Font.bold ] (Element.text "Acme Corp")
                    ]
                , Element.row [ Element.spacing Tokens.spacerMd ]
                    [ Element.el [ Font.color Tokens.colorTextSubtle ] (Element.text "Plan:")
                    , Label.label "Professional" |> Label.withBlueColor |> Label.toMarkup
                    ]
                , Element.row [ Element.spacing Tokens.spacerMd ]
                    [ Element.el [ Font.color Tokens.colorTextSubtle ] (Element.text "Users:")
                    , Badge.badge 6 |> Badge.toMarkup
                    , Element.text "of 25 seats"
                    ]
                , Element.column [ Element.spacing Tokens.spacerXs, Element.width Element.fill ]
                    [ Element.el [ Font.color Tokens.colorTextSubtle ] (Element.text "Storage usage:")
                    , Progress.progress 72
                        |> Progress.withTitle "72% used"
                        |> Progress.toMarkup
                    ]
                ]
            ]
            |> Card.withTitle "Organization Overview"
            |> Card.toMarkup

        -- Alert
        , Alert.alert "Your trial period ends in 14 days. Upgrade to keep all features."
            |> Alert.withTitle "Trial expiring soon"
            |> Alert.withWarning
            |> Alert.withActions
                (Button.primary { label = "Upgrade now", onPress = Nothing }
                    |> Button.withSmallSize
                    |> Button.toMarkup
                )
            |> Alert.toMarkup
        ]


profileTabView : Model -> Element Msg
profileTabView model =
    Card.card
        [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
            [ TextInput.textInput { value = "Acme Corp", onChange = \_ -> NoOp }
                |> TextInput.withLabel "Organization name"
                |> TextInput.toMarkup
            , TextInput.textInput { value = "admin@acme.com", onChange = \_ -> NoOp }
                |> TextInput.withLabel "Contact email"
                |> TextInput.withEmailType
                |> TextInput.toMarkup
            , TextArea.textArea { value = model.settingsDescription, onChange = DescriptionChanged }
                |> TextArea.withLabel "Description"
                |> TextArea.withPlaceholder "Tell us about your organization..."
                |> TextArea.withRows 4
                |> TextArea.toMarkup
            , Element.row [ Element.spacing Tokens.spacerSm ]
                [ Button.primary { label = "Save changes", onPress = Nothing } |> Button.toMarkup
                , Button.secondary { label = "Cancel", onPress = Nothing } |> Button.toMarkup
                ]
            ]
        ]
        |> Card.withTitle "Organization Profile"
        |> Card.toMarkup


planTabView : Model -> Element Msg
planTabView model =
    Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
        [ Hint.hint "Select a plan that fits your team. You can upgrade or downgrade at any time."
            |> Hint.withTitle "Choose your plan"
            |> Hint.toMarkup
        , Element.wrappedRow [ Element.spacing Tokens.spacerMd ]
            [ Tile.tile { title = "Starter", onSelect = TierSelected "starter" }
                |> (if model.selectedTier == Just "starter" then
                        Tile.withSelected

                    else
                        identity
                   )
                |> Tile.withIcon (Element.text "\u{1F31F}")
                |> Tile.withStacked
                |> Tile.toMarkup
            , Tile.tile { title = "Professional", onSelect = TierSelected "pro" }
                |> (if model.selectedTier == Just "pro" || model.selectedTier == Nothing then
                        Tile.withSelected

                    else
                        identity
                   )
                |> Tile.withIcon (Element.text "\u{1F680}")
                |> Tile.withStacked
                |> Tile.toMarkup
            , Tile.tile { title = "Enterprise", onSelect = TierSelected "enterprise" }
                |> (if model.selectedTier == Just "enterprise" then
                        Tile.withSelected

                    else
                        identity
                   )
                |> Tile.withIcon (Element.text "\u{1F3E2}")
                |> Tile.withStacked
                |> Tile.toMarkup
            ]
        , Button.primary { label = "Update plan", onPress = Nothing } |> Button.toMarkup
        ]


mainContent : Model -> Element Msg
mainContent model =
    let
        bannerEl =
            if model.bannerVisible then
                Banner.banner "Welcome to UserHub! Your account is set up and ready to go."
                    |> Banner.withSuccess
                    |> Banner.toMarkup

            else
                Element.none

        pageContent =
            case model.page of
                Dashboard ->
                    dashboardView model

                Users ->
                    usersView model

                Settings ->
                    settingsView model
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
            , Bg.color Tokens.colorBackgroundSecondary
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
                [ mastheadView model
                , Element.row
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
                    ]
                    [ sidebarNav model
                    , mainContent model
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
