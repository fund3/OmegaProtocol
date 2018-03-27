using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct AOBMessage {
    type :union {
        request @0 :Request;
        response @1 :Response;
    }
}

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct Request {
    body :union {
        marketDataRequest @0 :MarketDataRequest;
    }
}

struct MarketDataRequest { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    header @0 :StandardHeader;
    reqID @1 :Text;
    mdReqGrp @2 :List(MDEntryType);
    instrmtMDReqGrp @3 :List(Instrument);
    marketDepth @4 :UInt8; # http://www.fixwiki.org/fixwiki/MarketDepth
    aggregatedBook @5 :AggregatedBook;
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################

struct Response {
    body :union {
        MarketDataIncrementalRefresh @0 :MarketDataIncrementalRefresh;
        MarketDataSnapshotFullRefresh @1 :MarketDataSnapshotFullRefresh;
    }
}

struct MarketDataIncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    header @0 :StandardHeader;
    reqID @1 :Text;
    incGroup @2 :MDIncGrp;
    marketID @3 :Exchange;
    struct MDIncGrp {
        updateAction @0 :MDUpdateAction;
        instrument @1 :Instrument;
        entries @2 :List(MDEntry);
    }
}

struct MarketDataSnapshotFullRefresh { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2B
    header @0 :StandardHeader;
    reqID @1 :Text;
    instrument @2 :Instrument;
    fullGroup @3 :MDFullGrp;
    marketID @4 :Exchange;
    struct MDFullGrp {
        entries @0 :List(MDEntry);
    }
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct StandardHeader { # http://fixwiki.org/fixwiki/StandardHeader/FIX.5.0SP2%2B
    msgType @0 :MsgType;
    senderCompID @1 :Text;
    targetCompID @2 :Text;
    sendingTime @3 :Timestamp;
    msgSeqNum @4 :UInt16;
}

enum MsgType { # http://fixwiki.org/fixwiki/MsgType
    request @0;
    incrementalRefresh @1;
    snapshotFullRefresh @2;
}

struct MDEntry {
    type @0 :MDEntryType;
    px @1 :Float64;
    size @2 :Float64;
    date @3 :Date;
    time @4 :Time;
    positionNo @5 :UInt8;
}

enum MDEntryType { # http://www.fixwiki.org/fixwiki/MDEntryType
    bid @0;
    offer @1;
    trade @2;
    indexValue @3;
    openingPrice @4;
    closingPrice @5;
    settlementPrice @6;
    tradingSessionHighPrice @7;
    tradingSessionLowPrice @8;
}

enum MDUpdateAction { # http://fixwiki.org/fixwiki/MDUpdateAction
    new @0;
    change @1;
    delete @2;
}

enum AggregatedBook { # http://www.fixwiki.org/fixwiki/AggregatedBook
    bookEntriesShouldNotBeAggregated @0;
    bookEntriesToBeAggregated @1;
}

struct Instrument { # http://fixwiki.org/fixwiki/Instrument/FIX.5.0SP2%2B
    symbol @0 :Text;
}

struct Exchange { # http://fixwiki.org/fixwiki/ExchangeDataType
    code @0 :Text;
}

struct Date {
    year @0 :Int16;
    month @1 :UInt8;
    day @2 :UInt8;
}

struct Time {
    hour @0 :UInt8;
    minute @1 :UInt8;
    second @2 :UInt8;
    millisecond @3 :UInt16;
}

struct Timestamp {
    date @0 :Date;
    time @1 :Time;
}