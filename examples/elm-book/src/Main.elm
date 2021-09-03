module Main exposing (main)

import ElmBook exposing (..)
import FirstChapter exposing (firstChapter)


main : Book ()
main =
    book "PF4 Book"
        |> withChapters
            [ firstChapter
            ]
