using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct MarketDataRequest { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    reqID @0 :Text;
    mdReqGrp @1 :List(MDEntryType);
    instrmtMDReqGrp @2 :List(Instrument);
    marketDepth @3 :UInt8; # http://www.fixwiki.org/fixwiki/MarketDepth
    aggregatedBook @4 :AggregatedBook;
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################


struct MarketDataIncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    reqID @0 :Text;
    incGroup @1 :MDIncGrp;
    struct MDIncGrp {
        updateAction @0 :MDUpdateAction;
        instrument @1 :Instrument;
        entries @2 :List(MDEntry);
    }
}

struct MarketDataSnapshotFullRefresh { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2B
    reqID @0 :Text;
    instrument @1 :Instrument;
    fullGroup @2 :MDFullGrp;
    struct MDFullGrp {
        entries @0 :List(MDEntry);
    }
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

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