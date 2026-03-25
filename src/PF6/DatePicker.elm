module PF6.DatePicker exposing
    ( DatePicker, Date
    , datePicker
    , withSelectedDate
    , withOnSelect
    , withOnPrevMonth
    , withOnNextMonth
    , toMarkup
    )

{-| PF6 DatePicker component

Renders a calendar month grid. The consumer controls which month is displayed
and which date is selected. Navigation (prev/next month) is handled via msgs.

See: <https://www.patternfly.org/components/date-picker>


# Definition

@docs DatePicker, Date


# Constructor

@docs datePicker


# Selection modifiers

@docs withSelectedDate


# Event modifiers

@docs withOnSelect, withOnPrevMonth, withOnNextMonth


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| A calendar date
-}
type alias Date =
    { year : Int
    , month : Int
    , day : Int
    }


{-| Opaque DatePicker type
-}
type DatePicker msg
    = DatePicker (Options msg)


type alias Options msg =
    { displayYear : Int
    , displayMonth : Int
    , selectedDate : Maybe Date
    , onSelect : Maybe (Date -> msg)
    , onPrevMonth : Maybe msg
    , onNextMonth : Maybe msg
    }


{-| Construct a DatePicker showing the given year and month (1–12)
-}
datePicker : { year : Int, month : Int } -> DatePicker msg
datePicker { year, month } =
    DatePicker
        { displayYear = year
        , displayMonth = clamp 1 12 month
        , selectedDate = Nothing
        , onSelect = Nothing
        , onPrevMonth = Nothing
        , onNextMonth = Nothing
        }


{-| Set the currently selected date
-}
withSelectedDate : Maybe Date -> DatePicker msg -> DatePicker msg
withSelectedDate d (DatePicker opts) =
    DatePicker { opts | selectedDate = d }


{-| Set the message sent when a date is clicked
-}
withOnSelect : (Date -> msg) -> DatePicker msg -> DatePicker msg
withOnSelect f (DatePicker opts) =
    DatePicker { opts | onSelect = Just f }


{-| Set the message sent when the previous-month button is clicked
-}
withOnPrevMonth : msg -> DatePicker msg -> DatePicker msg
withOnPrevMonth msg (DatePicker opts) =
    DatePicker { opts | onPrevMonth = Just msg }


{-| Set the message sent when the next-month button is clicked
-}
withOnNextMonth : msg -> DatePicker msg -> DatePicker msg
withOnNextMonth msg (DatePicker opts) =
    DatePicker { opts | onNextMonth = Just msg }



-- DATE MATH


isLeapYear : Int -> Bool
isLeapYear y =
    (modBy 4 y == 0 && modBy 100 y /= 0) || modBy 400 y == 0


daysInMonth : Int -> Int -> Int
daysInMonth year month =
    case month of
        1 ->
            31

        2 ->
            if isLeapYear year then
                29

            else
                28

        3 ->
            31

        4 ->
            30

        5 ->
            31

        6 ->
            30

        7 ->
            31

        8 ->
            31

        9 ->
            30

        10 ->
            31

        11 ->
            30

        12 ->
            31

        _ ->
            0


{-| Day of week for day 1 of the given year/month.
Returns 0 = Sunday, 1 = Monday, … 6 = Saturday.
Uses Tomohiko Sakamoto's algorithm.
-}
firstDayOfWeek : Int -> Int -> Int
firstDayOfWeek year month =
    let
        offsets =
            [ 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 ]

        y =
            if month < 3 then
                year - 1

            else
                year

        t =
            offsets
                |> List.drop (month - 1)
                |> List.head
                |> Maybe.withDefault 0
    in
    modBy 7 (y + y // 4 - y // 100 + y // 400 + t + 1)


monthName : Int -> String
monthName month =
    case month of
        1 ->
            "January"

        2 ->
            "February"

        3 ->
            "March"

        4 ->
            "April"

        5 ->
            "May"

        6 ->
            "June"

        7 ->
            "July"

        8 ->
            "August"

        9 ->
            "September"

        10 ->
            "October"

        11 ->
            "November"

        12 ->
            "December"

        _ ->
            ""


chunk : Int -> List a -> List (List a)
chunk size list =
    if List.isEmpty list then
        []

    else
        List.take size list :: chunk size (List.drop size list)



-- RENDERING


dayHeaders : Theme -> Element msg
dayHeaders theme =
    let
        days =
            [ "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" ]
    in
    Element.row [ Element.width Element.fill ]
        (List.map
            (\d ->
                Element.el
                    [ Element.width (Element.fillPortion 1)
                    , Element.padding Tokens.spacerXs
                    , Font.size Tokens.fontSizeSm
                    , Font.bold
                    , Font.color (Theme.textSubtle theme)
                    , Element.htmlAttribute (Html.Attributes.style "text-align" "center")
                    ]
                    (Element.text d)
            )
            days
        )


{-| Render the DatePicker as an `Element msg`
-}
toMarkup : Theme -> DatePicker msg -> Element msg
toMarkup theme (DatePicker opts) =
    let
        year =
            opts.displayYear

        month =
            opts.displayMonth

        days =
            daysInMonth year month

        startOffset =
            firstDayOfWeek year month

        emptyCells =
            List.repeat startOffset Nothing

        dayCells =
            List.range 1 days |> List.map Just

        allCells =
            emptyCells ++ dayCells

        remainder =
            modBy 7 (List.length allCells)

        paddedCells =
            if remainder == 0 then
                allCells

            else
                allCells ++ List.repeat (7 - remainder) Nothing

        weeks =
            chunk 7 paddedCells

        isSelected day =
            case opts.selectedDate of
                Just d ->
                    d.year == year && d.month == month && d.day == day

                Nothing ->
                    False

        dayCell maybeDay =
            case maybeDay of
                Nothing ->
                    Element.el
                        [ Element.width (Element.fillPortion 1)
                        , Element.height (Element.px 32)
                        ]
                        Element.none

                Just day ->
                    let
                        selected =
                            isSelected day

                        bgColor =
                            if selected then
                                Theme.primary theme

                            else
                                Theme.backgroundDefault theme

                        textColor =
                            if selected then
                                Theme.textOnDark theme

                            else
                                Theme.text theme

                        pressMsg =
                            opts.onSelect
                                |> Maybe.map (\f -> f { year = year, month = month, day = day })
                    in
                    Input.button
                        [ Element.width (Element.fillPortion 1)
                        , Element.height (Element.px 32)
                        , Bg.color bgColor
                        , Font.color textColor
                        , Font.size Tokens.fontSizeSm
                        , Border.rounded Tokens.radiusMd
                        ]
                        { onPress = pressMsg
                        , label =
                            Element.el [ Element.centerX, Element.centerY ]
                                (Element.text (String.fromInt day))
                        }

        weekRow week =
            Element.row [ Element.width Element.fill, Element.spacing 2 ]
                (List.map dayCell week)

        prevBtn =
            Input.button
                [ Font.color (Theme.primary theme)
                , Font.size Tokens.fontSizeLg
                , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                ]
                { onPress = opts.onPrevMonth
                , label = Element.text "‹"
                }

        nextBtn =
            Input.button
                [ Font.color (Theme.primary theme)
                , Font.size Tokens.fontSizeLg
                , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                ]
                { onPress = opts.onNextMonth
                , label = Element.text "›"
                }

        header =
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY 0 Tokens.spacerSm
                ]
                [ prevBtn
                , Element.el
                    [ Element.centerX
                    , Font.bold
                    , Font.size Tokens.fontSizeMd
                    , Font.color (Theme.text theme)
                    ]
                    (Element.text (monthName month ++ " " ++ String.fromInt year))
                , nextBtn
                ]
    in
    Element.column
        [ Element.width (Element.px 280)
        , Bg.color (Theme.backgroundDefault theme)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        , Element.padding Tokens.spacerMd
        , Element.spacing Tokens.spacerXs
        ]
        ([ header
         , dayHeaders theme
         ]
            ++ List.map weekRow weeks
        )
