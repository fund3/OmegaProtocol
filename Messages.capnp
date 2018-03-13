using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("proto");
@0xb1f6c0f74d970d0c;


#######################################################################################################
#                   COMMON TYPES
#######################################################################################################


enum OrderSide {
    undefined @0;
    buy  @1;
    sell @2;
}


enum OrderType {
    undefined @0;
    market @1;
    limit @2;
}


enum OrderStatus {
    undefined @0;
    received @1;
    adopted @2;
    validated @3;
    rejected @4;
    sentToExchange @5;
    working @6;
    filled @7;
    partiallyFilled @8;
    pendingCancel @9;
    pendingReplace @10;
    canceled @11;
}


struct Map(Key, Value) {
  entries @0 :List(Entry);
  struct Entry {
    key @0 :Key;
    value @1 :Value;
  }
}


#######################################################################################################
#                   MESSAGE
#######################################################################################################


struct TESMessage {
    type :union {
        request @0 :Request;
        response @1 :Response;
        internal @2 :Internal;
    }
}



#######################################################################################################
#                   REQUEST
#######################################################################################################


struct Request {
    clientID @0 :Text;

    body :union {
        # system
        heartbeat @1 :Void;                          # response: heartbeat

        # logon-logoff
        logon @2 :Void;                              # response: logon
        logoff @3 :Void;                             # response: logoff
        
        # trading requests
        placeOrder @4 :PlaceOrder;                   # response: execution report
        replaceOrder @5 :ReplaceOrder;               # response: execution report
        cancelOrder @6 :CancelOrder;                 # response: execution report
        cancelAllOrders @7 :CancelAllOrders;         # response: execution report

        # account-related request
        getWorkingOrder @8 :GetWorkingOrder;         # response: execution report
        getAccountBalances @9 :GetAccountBalances;   # response: account balances
    }
}


struct PlaceOrder {
    clOrderID @0 :Int64;
    orderID @1 :Text;           # empty in client request
    currencyPair @2 :Text;
    orderSide @3 :OrderSide;
    orderType @4 :OrderType;
    orderQuantity @5 :Float64;
    orderPrice @6 :Float64;
    exchange @7 :Text;
    margin @8 :Bool;
}


struct ReplaceOrder {
    orderID @0 :Text;
    clOrderID @1 :Int64;        # empty in client request
    exOrderID @2 :Text;         # empty in client request
    orderPrice @3 :Float64;     # if 0, change quantity only
    orderQuantity @4 :Float64;  # if 0, change price only
}


struct CancelOrder {
    orderID @0 :Text;
    clOrderID @1 :Int64;        # empty in client request
    exOrderID @2 :Text;         # empty in client request
}


struct CancelAllOrders {
    exchange @0 :Text;          # if empty, cancel all working orders on all supported exchanges
}


struct GetAccountBalances {
    exchange @0 :Text;          # if empty, return balances from all account
}


struct GetWorkingOrder {
    orderID @0 :Text;           # if empty, return all working orders by exchange specified in <exchange> field
    exchange @1 :Text;          # if empty, return all working orders from all supported exchanges
}



#######################################################################################################
#                   RESPONSE
#######################################################################################################


struct Response {
    clientID @0 :Text;
    body :union {
        # system
        heartbeat @1 :Void;

        # logon-logoff
        logon @2 :Void;
        logoff @3 :Void;

        # trading
        executionReport @4 :ExecutionReport;
        exchangeAccountBalances @5 :List(ExchangeAccountBalances);
    }
}


# sends as respond to place, modify, cancel, cancel all request
struct ExecutionReport {
    orderID @0 :Text;
    clOrderID @1 :Int64;
    exOrderID @2 :Text;
    orderStatus @3 :OrderStatus;

    type :union {
        orderAccepted @4 :Void;
        orderRejected @5 :Rejected;
        orderReplaced @6 :Void;
        replaceRejected @7 :Rejected;
        orderCanceled @8 :Void;
        cancelRejected @9 :Rejected;
        orderExecuted @10 :Executed;
    }
}


struct Executed {
    filledQuantity @0 :Float64;
    avgFillPrice @1 :Float64;
}


struct Rejected {
    rejectionReason @0 :Text;
}

###

struct Balance {
    currency @0 :Text;
    balance @1 :Float64;   
}


struct AccountBalances {
    account @0 :Text;
    balances @1 :List(Balance);
}


struct ExchangeAccountBalances {
    exchange @0 :Text;
    accountBalances @1 :List(AccountBalances);    
}


#######################################################################################################
#                   INTERNAL MESSAGES
#######################################################################################################


struct Internal {
    body :union {
        logon @0 :LogonInternal;
        logoff @1 :LogoffInternal;
    }
}


struct LogonInternal {
    clientID @0 :Text;
    credentials @1 :Credentials;
}


struct LogoffInternal {
    clientID @0 :Text;
}


struct Credentials {
    apiKey @0 :Text;
    secretKey @1 :Text;
    passphrase @2 :Text;
}


#######################################################################################################