using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb88da2a89ce6e0b2;

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct MarketDataMessage {
    sequenceNumber @0 :UInt64;
    timestamp @1 :Float64;
    requestID @2 :UInt64;
    type :union {
        request @3 :MarketDataRequest;
        snapshot @4 :MarketDataSnapshot;
        update @5 :MarketDataIncrementalRefresh;
    }
}

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct MarketDataRequest { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    symbolsByExchange @0 :List(SymbolsByExchange);
    struct SymbolsByExchange {
        exchange @0 :Text;
        symbols @1 :List(Text);
    }
    entryTypes @1 :List(MarketDataEntry.Type);
    depth @2 :UInt8; # 0 = full, 1 = top of book; http://www.fixwiki.org/fixwiki/MarketDepth
    subscriptionType @3 :SubscriptionType;
    enum SubscriptionType { # http://www.fixwiki.org/fixwiki/SubscriptionRequestType
        undefined @0;
        snapshot @1;
        subscribe @2;
        unsubscribe @3;
    }
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################

struct MarketDataSnapshot { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2Bol
    timestamp @0 :Float64;
    entriesBySymbolAndExchange @1 :List(EntriesBySymbolAndExchange);
    struct EntriesBySymbolAndExchange {
        symbol @0 :Text;
        exchange @1 :Text;
        entries @2 :List(MarketDataEntry);
    }
}

struct MarketDataIncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    timestamp @0 :Float64;
    updatesBySymbolAndExchange @1 :List(UpdatesBySymbolAndExchange);
    struct UpdatesBySymbolAndExchange {
        symbol @0 :Text;
        exchange @1 :Text;
        updates @2 :List(MarketDataUpdate);
    }
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct MarketDataEntry {
    eventTimestamp @0 :Float64;
    type @1 :Type;
    price @2 :Float64;
    size @3 :Float64;
    position @4 :UInt8; # Position in orderbook, empty if the entry is not an orderbook update
    side @5 :Text;
    enum Type { # http://www.fixwiki.org/fixwiki/MDEntryType
        undefined @0;
        bid @1;
        ask @2;
        trade @3;
        indexValue @4;
        openingPrice @5;
        closingPrice @6;
        settlementPrice @7;
        tradingSessionHighPrice @8;
        tradingSessionLowPrice @9;
    }
}

struct MarketDataUpdate {
    eventTimestamp @0 :Float64;
    action @1 :Action;
    entry @2 :MarketDataEntry;
    enum Action { # http://fixwiki.org/fixwiki/MDUpdateAction
        undefined @0;
        new @1;
        change @2;
        delete @3;
    }
}
