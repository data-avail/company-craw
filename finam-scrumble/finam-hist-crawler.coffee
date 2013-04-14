request = require "request"
fs = require "fs"
moment = require "moment"
async = require "async"



downloadPeriod = (data, callback) ->

  symbol = data.symbol
  s = data.momentStart
  e = data.momentEnd
  e ?= moment()

  file = "#{symbol}_#{s.format("YYMMDD")}_#{e.format("YYMMDD")}"
  href = "http://195.128.78.52/#{file}.txt?market=1&em=16842&code=#{symbol}&"+
  "df=#{s.day()}&mf=#{s.month()}&yf=#{s.year()}&dt=#{e.day()}&mt=#{e.month()}&yt=#{e.year()}"+
  "&p=8&f=#{file}&e=.txt&cn=#{symbol}&dtf=1&tmf=1&MSOR=1&mstime=on&mstimever=1&sep=1&sep2=2&datf=1&at=1"

  r = request(href).pipe(fs.createWriteStream("data/#{file}.txt"))
  r.on "close", callback

download = (symbols, momentStart, momentEnd, maxRequestsAtOnce) ->
  maxRequestsAtOnce ?= 1
  ###
  momentEnd ?= moment().add "d", -1
  splitInDays ?= momentEnd.diff momentStart, "days"
  maxRequestsAtOnce ?= 1
  arr = []
  splitDate = momentStart
  while splitDate.diff(momentEnd) < 0
    s = splitDate
    e = moment(splitDate).add "d", splitInDays
    if e.diff(moment()) > 0 then e = moment()
    arr = arr.concat symbols.map((m) -> symbol : m, momentStart : s, momentEnd : e)
    splitDate = e
  ###
  arr = symbols.map((m) -> symbol : m, momentStart : momentStart, momentEnd : momentEnd)
  console.log arr
  async.eachLimit arr, maxRequestsAtOnce, downloadPeriod, (err) ->
    console.log "done !"

download ["GAZP", "AVAN"], moment([2009, 0, 1])

