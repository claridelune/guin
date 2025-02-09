import json, strformat, os

proc saveToMarkdown*(jsonData: JsonNode, filename: string) =
  var markdownContent = ""

  let title = jsonData["name"].getStr()
  let artist = jsonData["artist"].getStr()
  let url = jsonData["cifraclub_url"].getStr()

  markdownContent.add(fmt"# {title} - {artist}" & "\n")
  markdownContent.add(fmt"Fuente: [{url}]({url})" & "\n")
  markdownContent.add("```\n")

  for line in jsonData["cifra"]:
    markdownContent.add(line.getStr() & "\n")

  markdownContent.add("```\n")

  writeFile(filename, markdownContent)
  echo fmt"📄 Markdown file saved  {getCurrentDir() / filename}"
