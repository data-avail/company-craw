Getting historical data for MICEX
=================================

No free sources.

[MICEX data access fees](http://rts.micex.ru/s846)

Getting stocks list : [MICEX stock list](http://www.rts.ru/ru/expitsecurities.html)

    `Not utf encoding, needs to be converted, most convinent way via word)`

Getting trades data : [finam web interface](http://www.finam.ru/analysis/profile041CA00007/default.asp)

finam.issuer-profile
aEmitentCodes

var index = $.inArray(this.quote(), aEmitentIds);
		if (index != -1) {
			return aEmitentCodes[index];
		} else {
			return null;
		}

#$(".finam-ui-dropdown-list:eq(1) li a").map(function(f, el){console.log($(el).attr("value"));});

