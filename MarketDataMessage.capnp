using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb88da2a89ce6e0b2;

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct PairId {
    exchange @0 :Text;
    symbols @1 :List(Text);
}

struct EntriesById {
    pairId @0 :PairId;                  # required
    entries @1 :List(MarketDataEntry);  # required
}

#######################################################################################################
#                   MESSAGE
#######################################################################################################

struct MarketDataMessage {
    sequenceNumber @0 :UInt64;              # optional
    timestamp @1 :Float64;                  # required
    requestID @2 :UInt64;                   # empty in client request
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
    pairIds @0 :List(PairId);                    # required
    entryTypes @1 :List(MarketDataEntry.Type);      # required
    depth @2 :UInt8;                                # required, 0 = full, 1 = top of book; http://www.fixwiki.org/fixwiki/MarketDepth
    subscriptionType @3 :SubscriptionType;          # required
    enum SubscriptionType { # http://www.fixwiki.org/fixwiki/SubscriptionRequestType
        snapshot @0;
        snapshotAndUpdates @1;
        unsubscribe @2;
    }
}

#######################################################################################################
#                   RESPONSE
#######################################################################################################

struct MarketDataSnapshot { # http://fixwiki.org/fixwiki/MarketDataSnapshotFullRefresh/FIX.5.0SP2%2Bol
    timestamp @0 :Float64;                  # required
    entriesById @1 :List(EntriesById);      # required
}

struct MarketDataIncrementalRefresh { # http://fixwiki.org/fixwiki/MarketDataIncrementalRefresh/FIX.5.0SP2%2B
    timestamp @0 :Float64;                  # required
    entriesById @1 :List(EntriesById);      # required
}

#######################################################################################################
#                   COMMON TYPES
#######################################################################################################

struct MarketDataEntry {
    eventTimestamp @0 :Float64;             # required               
    action @1 :Action = undefined;          # required
    type @2 :Type = undefined;              # required
    price @3 :Float64;                      # required
    size @4 :Float64;                       # required
    position @5 :UInt8;                     # optional, position in orderbook, empty if the entry is not an orderbook update
    side @6 :Text;                          # required
    enum Action { # http://fixwiki.org/fixwiki/MDUpdateAction
        undefined @0;
        new @1;
        change @2;
        delete @3;
    }
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
