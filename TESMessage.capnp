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
        placeOrder @4 :PlaceOrder;                   # response: ExecutionReport
        replaceOrder @5 :ReplaceOrder;               # response: ExecutionReport
        cancelOrder @6 :CancelOrder;                 # response: ExecutionReport

        # account-related request
        getWorkingOrders @7 :GetWorkingOrders;       # response: OrderList
        getAccountBalances @8 :GetAccountBalances;   # response: AccountBalances
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


struct GetAccountBalances {
    exchange @0 :Text;          # if empty, return balances from all account
}


struct GetWorkingOrders {
    orderID @0 :Text;           # if empty, return all working orders by exchange specified in <exchange> field
    clOrderID @1 :Int64;        # empty in client request
    exOrderID @2 :Text;         # empty in client request
    exchange @3 :Text;          # if empty, return all working orders from all supported exchanges
}



#######################################################################################################
#                   RESPONSE
#######################################################################################################


struct Response {
    clientID @0 :Text;
    body :union {
        # system
        heartbeat @1 :Void;
        system @2 : SystemMessage;

        # logon-logoff
        logonAck @3 :LogonAck;
        logoffAck @4 :LogoffAck;

        # trading
        executionReport @5 :ExecutionReport;

        #accounting
        workingOrders @6 :List(OrderData);
        exchangeAccountBalances @7 :List(ExchangeAccountBalances);
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
        orderRejected @5 :OrderRejected;
        orderReplaced @6 :OrderReplaced;
        replaceRejected @7 :OrderRejected;
        orderCanceled @8 :Void;
        cancelRejected @9 :OrderRejected;
        orderFilled @10 :OrderFilled;
    }
}


struct OrderFilled{
    filledQuantity @0 :Float64;
    avgFillPrice @1 :Float64;
}


struct OrderReplaced {
    newOrderPrice @0 :Float64;
    newOrderQuantity @1 :Float64;
}


struct OrderRejected {
    rejectionReason @0 :Text;
}



### Balances ###

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



### OrderData ###
struct OrderData {
    orderID @0 :Text;
    clOrderID @1 :Int64;
    exOrderID @2 :Text;
    currencyPair @3 :Text;
    orderSide @4 :OrderSide;
    orderType @5 :OrderType;
    orderQuantity @6 :Float64;
    orderPrice @7 :Float64;
    exchange @8 :Text;
    margin @9 :Bool;
    orderStatus @10 :OrderStatus;
    filledQuantity @11 :Float64;
    avgFillPrice @12 :Float64;
}



struct SystemMessage {
    message @0 :Text;
}


struct LogonAck {
	success @0 :Bool;
    message @1 :Text;
}


struct LogoffAck {
	success @0 :Bool;
    message @1 :Text;
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