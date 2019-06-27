using Cxx = import "/capnp/c++.capnp";
using import "Exchanges.capnp".Exchange;

$Cxx.namespace("proto::marketdata");
@0xb58df63b06ce5a55;


#######################################################################################################
#                   COMMON TYPES
#######################################################################################################


struct Header {
    clientID @0 :UInt64;
    senderCompID @1 :Text = "<UNDEFINED>";
}


enum Channel { 
    ticker @0;          # ticker data
    orderbook @1;       # level 2 orderbook data
}


enum Side {
    undefined @0;
    buy  @1;
    sell @2;
}


#######################################################################################################
#                   MESSAGE
#######################################################################################################


struct MarketDataMessage {
    header @0 :Header;

    type :union {
        request @1 :Request;
        response @2 :Response;
    }

    version @3 :Text = "1.0";
}


#######################################################################################################
#                   REQUEST
#######################################################################################################


struct Request {
    channels @0 :List(Channel);
    exchange @1 :Exchange;
    symbols @2 :List(Text);
    marketDepth @3 :UInt8;    # book depth (number of levels), 0 for full book

    type :union {
        subscribe @4 :Void;
        unsubscribe @5 :Void;
    }
}


#######################################################################################################
#                   RESPONSE
#######################################################################################################


struct Response {
    type :union {
        ticker @0 :TickerData;
        orderbookSnapshot @1 :OrderBookData;
        orderbookUpdate @2 :OrderBookData;
        systemMessage @3 :SystemMessage;
    }
}


struct TickerData {
    exchange @0 :Exchange;
    symbol @1 :Text;
    side @2 :Side;
    price @3 :Float64;
    quantity @4 :Float64;
    timestamp @5 :Float64;
}


struct OrderBookData {
    exchange @0 :Exchange;
    symbol @1 :Text;
    bids @2 :List(MarketDataEntry);
    asks @3 :List(MarketDataEntry);
    timestamp @4 :Float64;
}


struct MarketDataEntry {
    price @0 :Float64;
    quantity @1 :Float64;
}


struct SystemMessage {
    code @0 :UInt32;
    body @1 :Text = "<NONE>";
}
