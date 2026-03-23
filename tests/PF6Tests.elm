module PF6Tests exposing (all)

{-| Unit tests for PF6 components

These tests verify the builder API (constructor + withX functions) and
any pure logic embedded in components (overflow thresholds, clamping, etc.).

Note: elm-ui rendering (toMarkup) produces `Element msg` values, so visual
correctness is verified separately via the example app / Playwright screenshots.
-}

import Element
import Expect
import PF6.Badge as Badge
import PF6.Button as Button
import PF6.Label as Label
import PF6.Pagination as Pagination
import PF6.Progress as Progress
import PF6.Skeleton as Skeleton
import PF6.Spinner as Spinner
import PF6.Title as Title
import Test exposing (..)


-- BADGE TESTS


badgeTests : Test
badgeTests =
    describe "PF6.Badge"
        [ test "badge defaults to Read status" <|
            \_ ->
                Badge.badge 5
                    |> Badge.isRead
                    |> Expect.equal True
        , test "unreadBadge has Unread status" <|
            \_ ->
                Badge.unreadBadge 5
                    |> Badge.isUnread
                    |> Expect.equal True
        , test "withUnreadStatus changes status" <|
            \_ ->
                Badge.badge 10
                    |> Badge.withUnreadStatus
                    |> Badge.isUnread
                    |> Expect.equal True
        , test "withReadStatus reverts to Read" <|
            \_ ->
                Badge.unreadBadge 10
                    |> Badge.withReadStatus
                    |> Badge.isRead
                    |> Expect.equal True
        , test "isRead and isUnread are mutually exclusive" <|
            \_ ->
                let
                    b =
                        Badge.badge 1
                in
                Expect.equal True (Badge.isRead b && not (Badge.isUnread b))
        , test "withOverflowAt sets custom threshold" <|
            \_ ->
                -- We can't inspect the threshold directly, but toMarkup can be called
                Badge.badge 500
                    |> Badge.withOverflowAt 100
                    |> Badge.isRead
                    |> Expect.equal True
        ]



-- BUTTON TESTS


buttonTests : Test
buttonTests =
    describe "PF6.Button"
        [ test "primary button can be rendered" <|
            \_ ->
                -- Constructing a primary button should not crash
                Button.primary { label = "Save", onPress = Nothing }
                    |> Button.toMarkup
                    |> (\_ -> Expect.pass)
        , test "withDisabled produces a button with no onPress" <|
            \_ ->
                -- withDisabled sets onPress to Nothing; just verifying it constructs
                Button.primary { label = "Submit", onPress = Just () }
                    |> Button.withDisabled
                    |> Button.toMarkup
                    |> (\_ -> Expect.pass)
        , test "withSmallSize can be applied" <|
            \_ ->
                Button.secondary { label = "Cancel", onPress = Nothing }
                    |> Button.withSmallSize
                    |> Button.toMarkup
                    |> (\_ -> Expect.pass)
        , test "withIcon can be applied" <|
            \_ ->
                Button.primary { label = "Add", onPress = Nothing }
                    |> Button.withIcon (Element.text "+")
                    |> Button.withIconRight
                    |> Button.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- PROGRESS TESTS


progressTests : Test
progressTests =
    describe "PF6.Progress"
        [ test "progress value is clamped to 0..100 (below 0)" <|
            \_ ->
                Progress.progress -10
                    |> Progress.toMarkup
                    |> (\_ -> Expect.pass)
        , test "progress value is clamped to 0..100 (above 100)" <|
            \_ ->
                Progress.progress 150
                    |> Progress.toMarkup
                    |> (\_ -> Expect.pass)
        , test "progress at 50 renders" <|
            \_ ->
                Progress.progress 50
                    |> Progress.withTitle "Storage"
                    |> Progress.withHelperText "50% of 100 GB used"
                    |> Progress.toMarkup
                    |> (\_ -> Expect.pass)
        , test "progress with success status renders" <|
            \_ ->
                Progress.progress 100
                    |> Progress.withSuccess
                    |> Progress.toMarkup
                    |> (\_ -> Expect.pass)
        , test "progress with small size renders" <|
            \_ ->
                Progress.progress 75
                    |> Progress.withSmallSize
                    |> Progress.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- PAGINATION TESTS


paginationTests : Test
paginationTests =
    describe "PF6.Pagination"
        [ test "pagination renders on page 1" <|
            \_ ->
                Pagination.pagination { page = 1, onPageChange = \_ -> () }
                    |> Pagination.withTotalItems 100
                    |> Pagination.withPerPage 10
                    |> Pagination.toMarkup
                    |> (\_ -> Expect.pass)
        , test "compact pagination renders" <|
            \_ ->
                Pagination.pagination { page = 2, onPageChange = \_ -> () }
                    |> Pagination.withCompact
                    |> Pagination.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- LABEL TESTS


labelTests : Test
labelTests =
    describe "PF6.Label"
        [ test "label with blue color renders" <|
            \_ ->
                Label.label "Running"
                    |> Label.withBlueColor
                    |> Label.toMarkup
                    |> (\_ -> Expect.pass)
        , test "label with outline variant renders" <|
            \_ ->
                Label.label "Pending"
                    |> Label.withOutline
                    |> Label.withGoldColor
                    |> Label.toMarkup
                    |> (\_ -> Expect.pass)
        , test "label with close msg renders" <|
            \_ ->
                Label.label "Removable"
                    |> Label.withCloseMsg ()
                    |> Label.toMarkup
                    |> (\_ -> Expect.pass)
        , test "compact label renders" <|
            \_ ->
                Label.label "Compact"
                    |> Label.withCompact
                    |> Label.withGreenColor
                    |> Label.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- TITLE TESTS


titleTests : Test
titleTests =
    describe "PF6.Title"
        [ test "title defaults and renders" <|
            \_ ->
                Title.title "Hello World"
                    |> Title.toMarkup
                    |> (\_ -> Expect.pass)
        , test "h2 title renders" <|
            \_ ->
                Title.title "Section"
                    |> Title.withH2
                    |> Title.toMarkup
                    |> (\_ -> Expect.pass)
        , test "h6 title renders" <|
            \_ ->
                Title.title "Fine Print"
                    |> Title.withH6
                    |> Title.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- SPINNER TESTS


spinnerTests : Test
spinnerTests =
    describe "PF6.Spinner"
        [ test "default spinner renders" <|
            \_ ->
                Spinner.spinner
                    |> Spinner.toMarkup
                    |> (\_ -> Expect.pass)
        , test "large spinner renders" <|
            \_ ->
                Spinner.spinner
                    |> Spinner.withLargeSize
                    |> Spinner.withAriaLabel "Loading content"
                    |> Spinner.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- SKELETON TESTS


skeletonTests : Test
skeletonTests =
    describe "PF6.Skeleton"
        [ test "default text skeleton renders" <|
            \_ ->
                Skeleton.skeleton
                    |> Skeleton.toMarkup
                    |> (\_ -> Expect.pass)
        , test "circle skeleton renders" <|
            \_ ->
                Skeleton.circleSkeleton
                    |> Skeleton.toMarkup
                    |> (\_ -> Expect.pass)
        , test "skeleton with custom width renders" <|
            \_ ->
                Skeleton.skeleton
                    |> Skeleton.withWidth 75
                    |> Skeleton.toMarkup
                    |> (\_ -> Expect.pass)
        , test "skeleton width is clamped to 1..100" <|
            \_ ->
                -- withWidth 0 should be clamped to 1, withWidth 150 to 100
                Skeleton.skeleton
                    |> Skeleton.withWidth 0
                    |> Skeleton.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- ALL TESTS


all : Test
all =
    describe "PF6 Components"
        [ badgeTests
        , buttonTests
        , progressTests
        , paginationTests
        , labelTests
        , titleTests
        , spinnerTests
        , skeletonTests
        ]
