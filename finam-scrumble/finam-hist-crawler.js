// Generated by CoffeeScript 1.6.2
(function() {
  var async, csv, daonloadAll, download, downloadPeriod, fs, moment, request;

  request = require("request");

  fs = require("fs");

  moment = require("moment");

  async = require("async");

  csv = require("csv");

  downloadPeriod = function(params, callback) {
    var dir, e, file, href, r, s, symbol;

    symbol = params.symbol;
    dir = params.outDirectory;
    s = params.momentStart;
    e = params.momentEnd;
    if (e == null) {
      e = moment();
    }
    file = "" + symbol + "_" + (s.format("YYMMDD")) + "_" + (e.format("YYMMDD"));
    href = ("http://195.128.78.52/" + file + ".txt?market=1&em=16842&code=" + symbol + "&") + ("df=" + (s.day()) + "&mf=" + (s.month()) + "&yf=" + (s.year()) + "&dt=" + (e.day()) + "&mt=" + (e.month()) + "&yt=" + (e.year())) + ("&p=8&f=" + file + "&e=.txt&cn=" + symbol + "&dtf=1&tmf=1&MSOR=1&mstime=on&mstimever=1&sep=1&sep2=2&datf=1&at=1");
    r = request(href).pipe(fs.createWriteStream("" + dir + "/" + file + ".txt"));
    return r.on("close", callback);
  };

  download = function(symbols, params, callback) {
    var arr, maxRequestsAtOnce, momentEnd, momentStart, outDirectory;

    console.log(symbols);
    momentStart = params.momentStart;
    momentEnd = params.momentEnd;
    maxRequestsAtOnce = params.maxRequestsAtOnce;
    outDirectory = params.outDirectory;
    if (maxRequestsAtOnce == null) {
      maxRequestsAtOnce = 1;
    }
    arr = symbols.map(function(m) {
      return {
        symbol: m,
        momentStart: momentStart,
        momentEnd: momentEnd,
        outDirectory: outDirectory
      };
    });
    console.log(arr);
    return async.eachLimit(arr, maxRequestsAtOnce, downloadPeriod, callback);
  };

  daonloadAll = function(params, callback) {
    return csv().from(params.symolsListFile, {
      trim: true
    }).transform(function(row, idx) {
      if (idx !== 0 && row[0]) {
        return row[params.symbolColumn];
      }
    }).to.array(function(data) {
      return download(data, params, callback);
    });
  };

  daonloadAll({
    symolsListFile: "data/dicts/rts-securities.csv",
    symbolColumn: 0,
    outDirectory: "data/micex_equity_per_day",
    momentStart: moment([2009, 0, 1]),
    maxRequestsAtOnce: 1
  }, function(err) {
    return console.log(" done : " + err);
  });

}).call(this);
