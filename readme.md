Getting market data
===================

##erp-scrumble (Org names)##

 Get organization company names, from [www.erpr.ru]. Store them directly in mongo.

##finam-scrumble (MICEX historical data)##

No free sources for MICEX historical data.

[MICEX data access fees](http://rts.micex.ru/s846)

Stocks list : [MICEX stock list](http://www.rts.ru/ru/expitsecurities.html)
`No utf encoding, needs to be converted, most convinent way via word)`

[Finam web interface](http://www.finam.ru/analysis/profile041CA00007/default.asp) for getting historical data.

Project facilitate getting data from finam mot by hands, but scrumble them from web.

The js code to get internal-finam-id code to stock symbol:

     finam.issuer-profile.js

     aEmitentCodes

     var index = $.inArray(this.quote(), aEmitentIds);
            if (index != -1) {
                return aEmitentCodes[index];
            } else {
                return null;
            }

     #$(".finam-ui-dropdown-list:eq(1) li a").map(function(f, el){console.log($(el).attr("value"));});


