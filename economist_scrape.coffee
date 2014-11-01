# Ajay Jain
# Oct 27, 2014

cheerio = require('cheerio')
http = require('http')
fs = require('fs')
request = require("request")

APIURL = "https://www.kimonolabs.com/api/4ad6vz88?apikey=ee09c7d2594a96034af2389c999528b9"

got_sections = (sections) ->
  for section, section_id of sections
    APIURL + section_id
  

request "https://www.kimonolabs.com/api/cxilgs84?apikey=ee09c7d2594a96034af2389c999528b9", (err, response, body) ->
  console.log(body)
  sections = {}

  for section in JSON.parse(body).results.collection1
    href = section.section.href
    start = href.lastIndexOf('/') + 1
    section_id = href.substring(start, href.length)
    sections[section.section.text] = section_id

  console.log(sections)
  got_sections(sections)