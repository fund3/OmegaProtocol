using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb88da2a89ce6e0b2;

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct MarketDataMessage {
    # http://fixwiki.org/fixwiki/StandardHeader/FIX.5.0SP2%2B
    sequenceNumber @0 :UInt32;
    type :union {
        marketDataRequest @1 :MarketDataRequest;
        marketDataIncrementalRefresh @2 :MarketDataIncrementalRefresh;
        marketDataSnapshotRefresh @3 :MarketDataSnapshotRefresh;
    }
}

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct MarketDataRequest { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    requestID @0 :UInt64; # http://fixwiki.org/fixwiki/MDReqID
    entryTypes @1 :List(EntryType);
    instruments @2 :List(Instrument);
    depth @3 :UInt8; # http://www.fixwiki.org/fixwiki/MarketDepth
    aggregated @4 :Bool;
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################

struct MarketDataIncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    requestID @0 :UInt64; # http://fixwiki.org/fixwiki/MDReqID
    updateAction @1 :UpdateAction;
    instrument @2 :Instrument;
    entries @3 :List(Entry);
}

struct MarketDataSnapshotRefresh { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2B
    requestID @0 :UInt64; # http://fixwiki.org/fixwiki/MDReqID
    instrument @1 :Instrument;
    entries @2 :List(Entry);
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct Entry {
    type @0 :EntryType;
    price @1 :Float64;
    size @2 :Float64;
    timestamp @3 :UInt64;
    position @4 :UInt8; # http://fixwiki.org/fixwiki/MDEntryPositionNo
}

enum EntryType { # http://www.fixwiki.org/fixwiki/MDEntryType
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

enum UpdateAction { # http://fixwiki.org/fixwiki/MDUpdateAction
    new @0;
    change @1;
    delete @2;
}

struct Instrument { # http://fixwiki.org/fixwiki/Instrument/FIX.5.0SP2%2B
    symbol @0 :Text;
    currency @1 :Text;
    exchange @2 :Text;
}