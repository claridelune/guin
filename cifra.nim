import std/httpclient
import std/json
import std/os
import std/xmltree
import std/strutils
import std/streams

import nimquery
import htmlparser

const BASE_URL = "https://www.cifraclub.com/"

type
  CifraClubScrapper = object
    client: HttpClient

proc newCifraClubScraper*(): CifraClubScrapper = 
  result.client = newHttpClient()


proc fetchHtml(scraper: CifraClubScrapper, url: string): XmlNode =
  try:
    let html = scraper.client.getContent(url)
    return parseHtml(newStringStream(html))
  except CatchableError as e:
    echo e.msg
    return nil

proc extractDetails(doc: XmlNode, result: var JsonNode) =
  let titleNode = doc.querySelector("h1.t1")
  let artistNode = doc.querySelector("h2.t3")
  if titleNode != nil:
    result["name"] = %titleNode.innerText().strip()
  if artistNode != nil:
    result["artist"] = %artistNode.innerText().strip()

proc extractCifra(doc: XmlNode, result: var JsonNode) =
  let cifraNode = doc.querySelector(".cifra_cnt pre")
  if cifraNode != nil:
    result["cifra"] = %cifraNode.innerText().strip().split("\n")

proc getCifra*(scraper: CifraClubScrapper, artist: string, song: string): JsonNode =
  var result = newJObject()
  let url = BASE_URL & artist.replace(" ", "-").toLower() & "/" & song.replace(" ", "-").toLower()
  result["cifraclub_url"] = %url

  echo "Downloading: ", url
  let doc = scraper.fetchHtml(url)
  if doc == nil:
    result["error"] = %"Couldn't download the page."
    return result

  extractDetails(doc, result)
  extractCifra(doc, result)
  return result
