# Advent of Code 2024

My submissions for Advent of Code 2024! This project's aim is to get familiar with the OCaml ecosystem.

## Usage

This project is managed with `opam` and `dune`. Use `opam switch create <name> <compiler-version>` to create a new switch for this project.

This project also uses [Core](https://opensource.janestreet.com/core/) as an additional dependency.

* `opam exec -- dune build` builds the project. Inputs are expected to be stored in plaintext under `inputs/input<day>.txt`.
* `opam exec -- dune exec advent_of_code_2024 <day> <part>` executes the main driver with the given day and part. 
* `opam exec -- dune runtest` runs all of the inline tests.
