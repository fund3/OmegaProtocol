using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xd6848063f12aa00b;



#######################################################################################################
#                   SUPPORTED EXCHANGES
#######################################################################################################


enum Exchange {
    undefined @0;
    poloniex  @1;
    gdax @2;
    kraken @3;
    gemini @4;
    bitfinex @5;
    bittrex @6;
    binance @7;
}
