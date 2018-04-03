using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb88da2a89ce6e0b2;

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct AOBMessage {
    # http://fixwiki.org/fixwiki/StandardHeader/FIX.5.0SP2%2B
    type @0 :MessageType;
    senderCompany @1 :Text;
    targetCompany @2 :Text;
    sendingTime @3 :Timestamp;
    sequenceNumber @4 :UInt16;
    type :union {
        request @5 :Request;
        response @6 :Response;
    }
}

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct Request { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    header @0 :Header;
    request @1 :Text; # http://fixwiki.org/fixwiki/MDReqID
    entryTypes @2 :List(EntryType);
    instruments @3 :List(Instrument);
    markets @4 :List(Exchange); # http://fixwiki.org/fixwiki/MarketSegmentScopeGrp/FIX.5.0SP2%2B
    depth @5 :UInt8; # http://www.fixwiki.org/fixwiki/MarketDepth
    aggregated @6 :AggregatedBook;
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
    header @0 :Header;
    request @1 :Text; # http://fixwiki.org/fixwiki/MDReqID
    market @2 :Exchange; # http://fixwiki.org/fixwiki/MarketID
    group :group { # http://fixwiki.org/fixwiki/MDIncGrp/FIX.5.0SP2%2B
        updateAction @3 :UpdateAction;
        instrument @4 :Instrument;
        entries @5 :List(Entry);
    }
}

struct FullRefresh { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2B
    header @0 :Header;
    request @1 :Text; # http://fixwiki.org/fixwiki/MDReqID
    instrument @2 :Instrument;
    market @3 :Exchange; # http://fixwiki.org/fixwiki/MarketID
    group :group { # http://fixwiki.org/fixwiki/MDFullGrp/FIX.5.0SP2%2B
        entries @4 :List(Entry);
        currency @5 :Text;
    }
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

enum MessageType { # http://fixwiki.org/fixwiki/MsgType
    request @0;
    incrementalRefresh @1;
    fullRefresh @2;
}

struct Entry {
    type @0 :EntryType;
    price @1 :Float64;
    size @2 :Float64;
    date @3 :Date;
    time @4 :Time;
    position @5 :UInt8; # http://fixwiki.org/fixwiki/MDEntryPositionNo
    market @6 :Exchange; # http://fixwiki.org/fixwiki/MDMkt
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