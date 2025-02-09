import os, strutils, json, parseopt, strformat
import cifra
import generateMd

proc writeHelp() = discard
proc writeVersion() = discard

proc main() =
  var artist = ""
  var song = ""

  for kind, key, value in getopt():
    case kind
    of cmdArgument:
      if artist == "":
        artist = key
      elif song == "":
        song = key
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h": writeHelp()
      of "version", "v": writeVersion()
    of cmdEnd: assert(false)

  if artist == "" or song == "":
    echo "❌ You should enter artist and song name."
    echo "Example: nim c -r app.nim '<artist>' '<song>'"
    quit(1)

  let scraper = cifra.newCifraClubScraper()
  let result = scraper.getCifra(artist, song)

  if result.hasKey("error"):
    echo "Error", result["error"].getStr()
    quit(1)

  let fileName = fmt"{artist.replace(' ', '_').toLower()}_{song.replace(' ', '_').toLower()}.md"

  saveToMarkdown(result, filename)

main()
