using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb88da2a89ce6e0b2;

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct AOBMessage {
    # http://fixwiki.org/fixwiki/StandardHeader/FIX.5.0SP2%2B
    senderCompany @0 :Text;
    targetCompany @1 :Text;
    sendingTime @2 :Timestamp;
    sequenceNumber @3 :UInt16;
    type :union {
        request @4 :Request;
        response @5 :Response;
    }
}

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct Request { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    identifier @0 :Text; # http://fixwiki.org/fixwiki/MDReqID
    entryTypes @1 :List(EntryType);
    instruments @2 :List(Instrument);
    depth @3 :UInt8; # http://www.fixwiki.org/fixwiki/MarketDepth
    aggregated @4 :AggregatedBook;
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################

struct Response {
    body :union {
        incrementalRefresh @0 :IncrementalRefresh;
        fullRefresh @1 :FullRefresh;
    }
}

struct IncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    request @0 :Text; # http://fixwiki.org/fixwiki/MDReqID
    group :group { # http://fixwiki.org/fixwiki/MDIncGrp/FIX.5.0SP2%2B
        updateAction @1 :UpdateAction;
        instrument @2 :Instrument;
        entries @3 :List(Entry);
    }
}

struct FullRefresh { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2B
    request @0 :Text; # http://fixwiki.org/fixwiki/MDReqID
    instrument @1 :Instrument;
    group :group { # http://fixwiki.org/fixwiki/MDFullGrp/FIX.5.0SP2%2B
        entries @2 :List(Entry);
        currency @3 :Text;
    }
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct Entry {
    type @0 :EntryType;
    price @1 :Float64;
    size @2 :Float64;
    date @3 :Date;
    time @4 :Time;
    position @5 :UInt8; # http://fixwiki.org/fixwiki/MDEntryPositionNo
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

enum AggregatedBook { # http://www.fixwiki.org/fixwiki/AggregatedBook
    bookEntriesShouldNotBeAggregated @0;
    bookEntriesToBeAggregated @1;
}

struct Instrument { # http://fixwiki.org/fixwiki/Instrument/FIX.5.0SP2%2B
    symbol @0 :Text;
    exchange @1 :Text;
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