// Generated by CoffeeScript 1.6.2
(function() {
  var async, csv, daonloadAll, download, downloadPeriod, fs, moment, request;

  request = require("request");

  fs = require("fs");

  moment = require("moment");

  async = require("async");

  csv = require("csv");

  fs = require("fs");

  downloadPeriod = function(params, callback) {
    var dir, e, file, href, kvp, r, s;

    kvp = params.symbol;
    dir = params.outDirectory;
    s = params.momentStart;
    e = params.momentEnd;
    if (e == null) {
      e = moment();
    }
    file = "" + kvp.val + "_" + (s.format("YYMMDD")) + "_" + (e.format("YYMMDD"));
    href = ("http://195.128.78.52/" + file + ".txt?market=1&em=" + kvp.key + "&code=" + kvp.val) + ("df=" + (s.day()) + "&mf=" + (s.month()) + "&yf=" + (s.year()) + "&dt=" + (e.day()) + "&mt=" + (e.month()) + "&yt=" + (e.year())) + ("&p=8&f=" + file + "&cn=" + kvp.val + "&e=.txt&dtf=1&tmf=1&MSOR=1&mstime=on&mstimever=1&sep=1&sep2=2&datf=1&at=1");
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
    var i, k, keys, kvr, res, vals, _i, _len;

    kvr = fs.readFileSync(params.symolsFile, "utf-8").split('\n');
    keys = kvr[0].split(',');
    vals = kvr[1].split(',');
    res = [];
    for (i = _i = 0, _len = keys.length; _i < _len; i = ++_i) {
      k = keys[i];
      res.push({
        key: k,
        val: vals[i]
      });
    }
    console.log(res);
    return download(res, params, callback);
  };

  daonloadAll({
    symolsFile: "data/dicts/finam-id-symbol-dict.txt",
    symbolColumn: 0,
    outDirectory: "data/micex-equity-per-day",
    momentStart: moment([2009, 0, 1]),
    maxRequestsAtOnce: 1
  }, function(err) {
    return console.log(" done : " + err);
  });

}).call(this);
