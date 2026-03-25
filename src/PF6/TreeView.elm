module PF6.TreeView exposing
    ( TreeView, TreeNode
    , treeView, node
    , withChildren
    , withExpanded
    , withSelected
    , withBadge
    , withIcon
    , withOnToggle
    , withOnSelect
    , toMarkup
    )

{-| PF6 TreeView component

Displays hierarchical data as an expandable/collapsible tree. The consumer
manages expansion and selection state; the component renders accordingly.

See: <https://www.patternfly.org/components/tree-view>


# Definition

@docs TreeView, TreeNode


# Constructors

@docs treeView, node


# Node modifiers

@docs withChildren
@docs withExpanded
@docs withSelected
@docs withBadge
@docs withIcon
@docs withOnToggle
@docs withOnSelect


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque TreeView type
-}
type TreeView msg
    = TreeView (Options msg)


{-| Opaque TreeNode type
-}
type TreeNode msg
    = TreeNode (NodeOptions msg)


type alias Options msg =
    { nodes : List (TreeNode msg)
    }


type alias NodeOptions msg =
    { id : String
    , label : String
    , icon : Maybe (Element msg)
    , badge : Maybe Int
    , isExpanded : Bool
    , isSelected : Bool
    , children : List (TreeNode msg)
    , onToggle : Maybe (String -> msg)
    , onSelect : Maybe (String -> msg)
    }


{-| Construct a TreeView with the given top-level nodes
-}
treeView : List (TreeNode msg) -> TreeView msg
treeView nodes =
    TreeView { nodes = nodes }


{-| Construct a TreeNode with the given id and label
-}
node : String -> String -> TreeNode msg
node id label =
    TreeNode
        { id = id
        , label = label
        , icon = Nothing
        , badge = Nothing
        , isExpanded = False
        , isSelected = False
        , children = []
        , onToggle = Nothing
        , onSelect = Nothing
        }


{-| Set the node's children
-}
withChildren : List (TreeNode msg) -> TreeNode msg -> TreeNode msg
withChildren kids (TreeNode opts) =
    TreeNode { opts | children = kids }


{-| Mark the node as expanded (children visible)
-}
withExpanded : TreeNode msg -> TreeNode msg
withExpanded (TreeNode opts) =
    TreeNode { opts | isExpanded = True }


{-| Mark the node as selected
-}
withSelected : TreeNode msg -> TreeNode msg
withSelected (TreeNode opts) =
    TreeNode { opts | isSelected = True }


{-| Show a badge count on the node
-}
withBadge : Int -> TreeNode msg -> TreeNode msg
withBadge count (TreeNode opts) =
    TreeNode { opts | badge = Just count }


{-| Set an icon element displayed before the label
-}
withIcon : Element msg -> TreeNode msg -> TreeNode msg
withIcon icon (TreeNode opts) =
    TreeNode { opts | icon = Just icon }


{-| Set the message sent with the node id when expand/collapse is toggled
-}
withOnToggle : (String -> msg) -> TreeNode msg -> TreeNode msg
withOnToggle f (TreeNode opts) =
    TreeNode { opts | onToggle = Just f }


{-| Set the message sent with the node id when the node label is clicked
-}
withOnSelect : (String -> msg) -> TreeNode msg -> TreeNode msg
withOnSelect f (TreeNode opts) =
    TreeNode { opts | onSelect = Just f }


renderNode : Theme -> Int -> TreeNode msg -> Element msg
renderNode theme depth (TreeNode opts) =
    let
        hasChildren =
            not (List.isEmpty opts.children)

        toggleEl =
            if hasChildren then
                Input.button
                    [ Font.color (Theme.textSubtle theme)
                    , Font.size Tokens.fontSizeSm
                    , Element.width (Element.px 16)
                    ]
                    { onPress = opts.onToggle |> Maybe.map (\f -> f opts.id)
                    , label =
                        Element.text
                            (if opts.isExpanded then
                                "▾"

                             else
                                "▸"
                            )
                    }

            else
                Element.el [ Element.width (Element.px 16) ] Element.none

        iconEl =
            case opts.icon of
                Just icon ->
                    Element.el [ Element.paddingEach { top = 0, right = Tokens.spacerXs, bottom = 0, left = 0 } ] icon

                Nothing ->
                    Element.none

        badgeEl =
            case opts.badge of
                Just count ->
                    Element.el
                        [ Bg.color (Theme.backgroundSecondary theme)
                        , Border.rounded Tokens.radiusPill
                        , Element.paddingXY Tokens.spacerXs 2
                        , Font.size Tokens.fontSizeSm
                        , Font.color (Theme.textSubtle theme)
                        ]
                        (Element.text (String.fromInt count))

                Nothing ->
                    Element.none

        labelBg =
            if opts.isSelected then
                Theme.backgroundSecondary theme

            else
                Theme.backgroundDefault theme

        labelColor =
            if opts.isSelected then
                Theme.primary theme

            else
                Theme.text theme

        labelEl =
            Input.button
                [ Element.width Element.fill
                , Bg.color labelBg
                , Border.rounded Tokens.radiusSm
                , Element.paddingXY Tokens.spacerXs Tokens.spacerXs
                ]
                { onPress = opts.onSelect |> Maybe.map (\f -> f opts.id)
                , label =
                    Element.row [ Element.spacing Tokens.spacerXs, Element.width Element.fill ]
                        [ iconEl
                        , Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.color labelColor
                            , Element.width Element.fill
                            ]
                            (Element.text opts.label)
                        , badgeEl
                        ]
                }

        nodeRow =
            Element.row
                [ Element.width Element.fill
                , Element.spacing Tokens.spacerXs
                , Element.paddingEach { top = 0, right = 0, bottom = 0, left = depth * 16 }
                ]
                [ toggleEl
                , labelEl
                ]

        childrenEl =
            if opts.isExpanded && hasChildren then
                Element.column
                    [ Element.width Element.fill
                    , Element.spacing 2
                    ]
                    (List.map (renderNode theme (depth + 1)) opts.children)

            else
                Element.none
    in
    Element.column [ Element.width Element.fill, Element.spacing 2 ]
        [ nodeRow
        , childrenEl
        ]


{-| Render the TreeView as an `Element msg`
-}
toMarkup : Theme -> TreeView msg -> Element msg
toMarkup theme (TreeView opts) =
    Element.column
        [ Element.width Element.fill
        , Element.spacing 2
        ]
        (List.map (renderNode theme 0) opts.nodes)
