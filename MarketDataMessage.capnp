using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb88da2a89ce6e0b2;

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct MarketDataMessage {
    sequenceNumber @0 :UInt32;
    requestID @1 :UInt64;
    type :union {
        marketDataRequest @2 :MarketDataRequest;
        marketDataSnapshot @3 :MarketDataSnapshot;
        marketDataIncrementalRefresh @4 :MarketDataIncrementalRefresh;
    }
}

#######################################################################################################
#                   REQUEST
#######################################################################################################

struct MarketDataRequest { # http://www.fixwiki.org/fixwiki/MarketDataRequest/FIX.5.0SP2%2B
    symbols @0 :List(Text);
    entryTypes @1 :List(MarketDataEntry.Type);
    depth @2 :UInt8; # 0 = full, 1 = top of book; http://www.fixwiki.org/fixwiki/MarketDepth
    subscriptionType @3 :SubscriptionType;
    enum SubscriptionType { # http://www.fixwiki.org/fixwiki/SubscriptionRequestType
        snapshot @0;
        snapshotAndUpdates @1; # subscribe
        disablePreviousSnapshot @2; # unsubscribe
    }
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################

struct MarketDataSnapshot { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2Bol
    entriesBySymbols @0 :List(EntriesBySymbol);
    struct EntriesBySymbol {
        symbol @0 :Text;
        entries @1 :List(MarketDataEntry);
    }
}

struct MarketDataIncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    updatesBySymbols @0 :List(UpdatesBySymbol);
    struct UpdatesBySymbol {
        symbol @0 :Text;
        updates @1 :List(MarketDataUpdate);
    }
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct MarketDataEntry {
    type @0 :Type;
    position @1 :UInt8;
    size @2 :Float64;
    price @3 :Float64;
    enum Type { # http://www.fixwiki.org/fixwiki/MDEntryType
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
}

struct MarketDataUpdate {
    action @0 :Action;
    entry @1 :MarketDataEntry;
    enum Action { # http://fixwiki.org/fixwiki/MDUpdateAction
        new @0;
        change @1;
        delete @2;
    }
}