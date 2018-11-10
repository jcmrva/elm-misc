param([switch]$noformat)

elm make .\src\Main.elm --output=seg-stop.js

if ($noformat) { }
else {
elm-format src --yes
}