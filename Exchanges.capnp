using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xd6848063f12aa00b;



#######################################################################################################
#                   SUPPORTED EXCHANGES
#######################################################################################################


enum Exchange {
    undefined @0;
    poloniex  @1;
    kraken @2;
    gemini @3;
    bitfinex @4;
    bittrex @5;
    binance @6;
    coinbasePro @7;
    coinbasePrime @8;
    bitstamp @9;
}
