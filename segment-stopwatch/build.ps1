param([switch]$format)

elm make .\src\Main.elm --output=seg-stop.js

if ($format) { 
elm-format src --yes
}