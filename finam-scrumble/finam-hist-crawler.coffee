request = require "request"
fs = require "fs"
moment = require "moment"
async = require "async"
csv = require "csv"
fs = require "fs"
#

downloadPeriod = (params, callback) ->

  kvp = params.symbol
  dir = params.outDirectory
  s = params.momentStart
  e = params.momentEnd
  e ?= moment()

  file = "#{kvp.val}_#{s.format("YYMMDD")}_#{e.format("YYMMDD")}"
  href = "http://195.128.78.52/#{file}.txt?market=1&em=#{kvp.key}&code=#{kvp.val}"+
  "df=#{s.day()}&mf=#{s.month()}&yf=#{s.year()}&dt=#{e.day()}&mt=#{e.month()}&yt=#{e.year()}"+
  "&p=8&f=#{file}&cn=#{kvp.val}&e=.txt&dtf=1&tmf=1&MSOR=1&mstime=on&mstimever=1&sep=1&sep2=2&datf=1&at=1"

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
  kvr = fs.readFileSync(params.symolsFile, "utf-8").split('\n')
  keys = kvr[0].split(',')
  vals = kvr[1].split(',')

  res =[]
  res.push(key : k, val : vals[i]) for k, i in keys
  console.log res
  download(res, params, callback)


daonloadAll
  symolsFile : "data/dicts/finam-id-symbol-dict.txt"
  symbolColumn :  0
  outDirectory : "data/micex-equity-per-day"
  momentStart : moment([2009, 0, 1])
  maxRequestsAtOnce : 1,
    (err) -> console.log " done : " + err

