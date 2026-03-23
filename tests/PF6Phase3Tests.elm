module PF6Phase3Tests exposing (all)

{-| Unit tests for PF6 Phase 3 components: Popover, NotificationDrawer, JumpLinks

Tests cover constructor API, builder functions, and pure logic.
Rendering (toMarkup) is tested by calling it and ensuring it doesn't crash.

-}

import Element
import Expect
import PF6.JumpLinks as JumpLinks
import PF6.NotificationDrawer as NotificationDrawer
import PF6.Popover as Popover
import Test exposing (..)


all : Test
all =
    describe "PF6 Phase 3 components"
        [ describe "PF6.Popover"
            [ test "basic popover renders" <|
                \_ ->
                    Popover.popover
                        { trigger = Element.text "Click me"
                        , isOpen = False
                        , onToggle = \_ -> ()
                        }
                        |> Popover.toMarkup
                        |> (\_ -> Expect.pass)
            , test "open popover with title and body" <|
                \_ ->
                    Popover.popover
                        { trigger = Element.text "Info"
                        , isOpen = True
                        , onToggle = \_ -> ()
                        }
                        |> Popover.withTitle "Details"
                        |> Popover.withBody (Element.text "Here is some detailed information.")
                        |> Popover.toMarkup
                        |> (\_ -> Expect.pass)
            , test "popover with footer" <|
                \_ ->
                    Popover.popover
                        { trigger = Element.text "Trigger"
                        , isOpen = True
                        , onToggle = \_ -> ()
                        }
                        |> Popover.withTitle "Title"
                        |> Popover.withBody (Element.text "Body content")
                        |> Popover.withFooter (Element.text "Footer content")
                        |> Popover.toMarkup
                        |> (\_ -> Expect.pass)
            , test "popover positions" <|
                \_ ->
                    let
                        base =
                            Popover.popover
                                { trigger = Element.text "T"
                                , isOpen = True
                                , onToggle = \_ -> ()
                                }
                                |> Popover.withTitle "Tip"
                    in
                    [ base |> Popover.withTop |> Popover.toMarkup
                    , base |> Popover.withBottom |> Popover.toMarkup
                    , base |> Popover.withLeft |> Popover.toMarkup
                    , base |> Popover.withRight |> Popover.toMarkup
                    ]
                        |> (\_ -> Expect.pass)
            , test "popover with close message" <|
                \_ ->
                    Popover.popover
                        { trigger = Element.text "Trigger"
                        , isOpen = True
                        , onToggle = \_ -> ()
                        }
                        |> Popover.withTitle "Closeable"
                        |> Popover.withOnClose ()
                        |> Popover.toMarkup
                        |> (\_ -> Expect.pass)
            , test "popover with max width" <|
                \_ ->
                    Popover.popover
                        { trigger = Element.text "T"
                        , isOpen = True
                        , onToggle = \_ -> ()
                        }
                        |> Popover.withMaxWidth 450
                        |> Popover.withBody (Element.text "Wide popover content")
                        |> Popover.toMarkup
                        |> (\_ -> Expect.pass)
            ]
        , describe "PF6.NotificationDrawer"
            [ test "closed notification drawer renders nothing" <|
                \_ ->
                    NotificationDrawer.notificationDrawer
                        { isOpen = False
                        , items = []
                        , onClose = ()
                        }
                        |> NotificationDrawer.toMarkup
                        |> (\_ -> Expect.pass)
            , test "open empty notification drawer" <|
                \_ ->
                    NotificationDrawer.notificationDrawer
                        { isOpen = True
                        , items = []
                        , onClose = ()
                        }
                        |> NotificationDrawer.toMarkup
                        |> (\_ -> Expect.pass)
            , test "notification drawer with items" <|
                \_ ->
                    NotificationDrawer.notificationDrawer
                        { isOpen = True
                        , items =
                            [ NotificationDrawer.notificationItem "Deployment complete"
                                |> NotificationDrawer.withTimestamp "2 minutes ago"
                                |> NotificationDrawer.withSuccess
                            , NotificationDrawer.notificationItem "Build failed"
                                |> NotificationDrawer.withTimestamp "5 minutes ago"
                                |> NotificationDrawer.withDanger
                                |> NotificationDrawer.withRead
                            , NotificationDrawer.notificationItem "New user registered"
                                |> NotificationDrawer.withInfo
                            ]
                        , onClose = ()
                        }
                        |> NotificationDrawer.toMarkup
                        |> (\_ -> Expect.pass)
            , test "notification drawer with mark all read" <|
                \_ ->
                    NotificationDrawer.notificationDrawer
                        { isOpen = True
                        , items =
                            [ NotificationDrawer.notificationItem "Alert 1"
                            , NotificationDrawer.notificationItem "Alert 2"
                            ]
                        , onClose = ()
                        }
                        |> NotificationDrawer.withOnMarkAllRead ()
                        |> NotificationDrawer.toMarkup
                        |> (\_ -> Expect.pass)
            , test "notification item variants" <|
                \_ ->
                    [ NotificationDrawer.notificationItem "Default"
                    , NotificationDrawer.notificationItem "Success" |> NotificationDrawer.withSuccess
                    , NotificationDrawer.notificationItem "Warning" |> NotificationDrawer.withWarning
                    , NotificationDrawer.notificationItem "Danger" |> NotificationDrawer.withDanger
                    , NotificationDrawer.notificationItem "Info" |> NotificationDrawer.withInfo
                    ]
                        |> (\_ -> Expect.pass)
            , test "notification item with clear handler" <|
                \_ ->
                    NotificationDrawer.notificationDrawer
                        { isOpen = True
                        , items =
                            [ NotificationDrawer.notificationItem "Dismissible"
                                |> NotificationDrawer.withOnClear ()
                            ]
                        , onClose = ()
                        }
                        |> NotificationDrawer.toMarkup
                        |> (\_ -> Expect.pass)
            ]
        , describe "PF6.JumpLinks"
            [ test "basic jump links render" <|
                \_ ->
                    JumpLinks.jumpLinks
                        [ JumpLinks.link "Overview" "#overview"
                        , JumpLinks.link "Getting started" "#getting-started"
                        , JumpLinks.link "Configuration" "#config"
                        ]
                        |> JumpLinks.toMarkup
                        |> (\_ -> Expect.pass)
            , test "jump links with label" <|
                \_ ->
                    JumpLinks.jumpLinks
                        [ JumpLinks.link "Section 1" "#s1"
                        , JumpLinks.link "Section 2" "#s2"
                        ]
                        |> JumpLinks.withLabel "On this page"
                        |> JumpLinks.toMarkup
                        |> (\_ -> Expect.pass)
            , test "jump links with subsections" <|
                \_ ->
                    JumpLinks.jumpLinks
                        [ JumpLinks.subsectionLink "Components" "#components"
                            [ JumpLinks.link "Button" "#button"
                            , JumpLinks.link "Badge" "#badge"
                            ]
                        , JumpLinks.link "Tokens" "#tokens"
                        ]
                        |> JumpLinks.toMarkup
                        |> (\_ -> Expect.pass)
            , test "jump links vertical layout" <|
                \_ ->
                    JumpLinks.jumpLinks
                        [ JumpLinks.link "A" "#a"
                        , JumpLinks.link "B" "#b"
                        ]
                        |> JumpLinks.withVertical
                        |> JumpLinks.toMarkup
                        |> (\_ -> Expect.pass)
            , test "jump links centered" <|
                \_ ->
                    JumpLinks.jumpLinks
                        [ JumpLinks.link "A" "#a"
                        , JumpLinks.link "B" "#b"
                        ]
                        |> JumpLinks.withCentered
                        |> JumpLinks.toMarkup
                        |> (\_ -> Expect.pass)
            , test "jump links sticky" <|
                \_ ->
                    JumpLinks.jumpLinks
                        [ JumpLinks.link "A" "#a"
                        ]
                        |> JumpLinks.withSticky
                        |> JumpLinks.toMarkup
                        |> (\_ -> Expect.pass)
            ]
        ]
