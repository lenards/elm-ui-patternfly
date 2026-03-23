module ReviewConfig exposing (config)

{-| elm-review configuration for elm-ui-patternfly

Enables unused code detection and common best practices.
-}

import NoUnused.CustomTypeConstructors
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule exposing (Rule)


config : List Rule
config =
    [ NoUnused.Modules.rule
    , NoUnused.Exports.rule
    , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.Variables.rule
    , NoUnused.Parameters.rule
    , NoUnused.Patterns.rule
    ]
