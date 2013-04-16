request = require "request"
fs = require "fs"
moment = require "moment"
async = require "async"
csv = require "csv"

#

downloadPeriod = (params, callback) ->

  symbol = params.symbol
  dir = params.outDirectory
  s = params.momentStart
  e = params.momentEnd
  e ?= moment()

  file = "#{symbol}_#{s.format("YYMMDD")}_#{e.format("YYMMDD")}"
  href = "http://195.128.78.52/#{file}.txt?market=1&em=#{symbol}&"+
  "df=#{s.day()}&mf=#{s.month()}&yf=#{s.year()}&dt=#{e.day()}&mt=#{e.month()}&yt=#{e.year()}"+
  "&p=8&f=#{file}&e=.txt&dtf=1&tmf=1&MSOR=1&mstime=on&mstimever=1&sep=1&sep2=2&datf=1&at=1"

  r = request(href).pipe(fs.createWriteStream("#{dir}/#{file}.txt"))
  r.on "close", callback

download = (symbols, params, callback) ->
  console.log symbols

  momentStart = params.momentStart
  momentEnd = params.momentEnd
  maxRequestsAtOnce = params.maxRequestsAtOnce
  outDirectory = params.outDirectory

  maxRequestsAtOnce ?= 1
  arr = symbols.map((m) -> symbol : m, momentStart : momentStart, momentEnd : momentEnd, outDirectory : outDirectory)
  console.log arr
  async.eachLimit arr, maxRequestsAtOnce, downloadPeriod, callback

daonloadAll = (params, callback) ->
  csv().from(params.symolsListFile, trim : true)
    .transform((row, idx) ->
      if idx != 0 and row[0] then row[params.symbolColumn]
    )
    .to.array((data) -> download(data, params, callback))

daonloadAll
  symolsListFile : "data/dicts/finam-micex-equity-codes.txt"
  symbolColumn :  0
  outDirectory : "data/micex-equity-per-day-finam-codes"
  momentStart : moment([2009, 0, 1])
  maxRequestsAtOnce : 1,
    (err) -> console.log " done : " + err

