using Cxx = import "/capnp/c++.capnp";
using import "Exchanges.capnp".Exchange;

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
    working @3;
    partiallyFilled @4;
    filled @5;
    canceled @6;
    rejected @7;
}


enum TimeInForce {
    undefined @0;
    gtc @1;        # Good till cancel
    gtt @2;        # Good till time
    day @3;        # Day order
    ioc @4;        # Immediate or cancel
    fok @5;        # Fill or kill
}



#######################################################################################################
#                   MESSAGE
#######################################################################################################


struct TradeMessage {
    type :union {
        request @0 :Request;
        response @1 :Response;
    }
}



#######################################################################################################
#                   REQUEST
#######################################################################################################


struct Request {
    clientID @0 :Text;
    senderCompID @1 :Text;

    body :union {
        # system
        heartbeat @2 :Void;                          # response: heartbeat

        # logon-logoff
        logon @3 :AnyPointer;                        # response: logonAck
        logoff @4 :AnyPointer;                       # response: logoffAck
        
        # trading requests
        placeOrder @5 :PlaceOrder;                   # response: ExecutionReport
        replaceOrder @6 :ReplaceOrder;               # response: ExecutionReport
        cancelOrder @7 :CancelOrder;                 # response: ExecutionReport

        # account-related request
        getWorkingOrders @8 :GetWorkingOrders;       # response: OrderList
        getAccountBalances @9 :GetAccountBalances;   # response: AccountBalances
    }
}


struct PlaceOrder {
    clientOrderID @0 :UInt64;
    orderID @1 :Text;              # empty in client request
    accountID @2 :UInt64;
    symbol @3 :Text;
    orderSide @4 :OrderSide;
    orderType @5 :OrderType;
    orderQuantity @6 :Float64;
    orderPrice @7 :Float64;
    timeInForce @8 :TimeInForce;
    exchange @9 :Exchange;
}


struct ReplaceOrder {
    orderID @0 :Text;
    clientOrderID @1 :UInt64;       # empty in client request
    exchangeOrderID @2 :Text;       # empty in client request
    accountID @3 :UInt64;           # empty in client request
    symbol @4 :Text;                # empty in client request
    orderSide @5 :OrderSide;        # optional
    orderType @6 :OrderType;        # optional
    orderQuantity @7 :Float64;      # optional
    orderPrice @8 :Float64;         # optional
    timeInForce @9 :TimeInForce;    # optional
    exchange @10 :Exchange;         # empty in client request
}


struct CancelOrder {
    orderID @0 :Text;
    clientOrderID @1 :UInt64;       # empty in client request
    exchangeOrderID @2 :Text;       # empty in client request
    accountID @3 :UInt64;           # empty in client request
}


struct GetWorkingOrders {
    orderID @0 :Text;               # if empty, return all working orders for the account
    clientOrderID @1 :UInt64;       # empty in client request
    exchangeOrderID @2 :Text;       # empty in client request
    exchange @3 :Exchange; 
    accountID @4 :UInt64;
}


struct GetAccountBalances {
    exchange @0 :Exchange;
    accountID @1 :UInt64;
}


#######################################################################################################
#                   RESPONSE
#######################################################################################################


struct Response {
    clientID @0 :Text;
    senderCompID @1 :Text;
    body :union {
        # system
        heartbeat @2 :Void;
        system @3 : SystemMessage;

        # logon-logoff
        logonAck @4 :LogonAck;
        logoffAck @5 :LogoffAck;

        # trading
        executionReport @6 :ExecutionReport;

        #accounting
        workingOrders @7 :List(OrderData);
        accountBalances @8 :AccountBalances;
    }
}


# sends as respond to place, modify, cancel requests
struct ExecutionReport {
    orderID @0 :Text;
    clientOrderID @1 :UInt64;
    exchangeOrderID @2 :Text;
    accountID @3 :UInt64;
    orderStatus @4 :OrderStatus;

    type :union {
        orderAccepted @5 :Void;
        orderRejected @6 :OrderRejected;
        orderReplaced @7 :Void;
        replaceRejected @8 :OrderRejected;
        orderCanceled @9 :Void;
        cancelRejected @10 :OrderRejected;
        orderFilled @11 :OrderFilled;
    }
}


struct OrderFilled{
    filledQuantity @0 :Float64;
    avgFillPrice @1 :Float64;
}


struct OrderRejected {
    rejectionReason @0 :Text;
}



### OrderData ###
struct OrderData {
    orderID @0 :Text;
    clientOrderID @1 :UInt64;
    exchangeOrderID @2 :Text;
    accountID @3 :UInt64;
    symbol @4 :Text;
    orderSide @5 :OrderSide;
    orderType @6 :OrderType;
    orderQuantity @7 :Float64;
    orderPrice @8 :Float64;
    exchange @9 :Exchange;
    orderStatus @10 :OrderStatus;
    filledQuantity @11 :Float64;
    avgFillPrice @12 :Float64;
}


### Balances ###

struct Balance {
    currency @0 :Text;
    balance @1 :Float64;   
}


struct AccountBalances {
    exchange @0 :Exchange;
    accountID @1 :UInt64;
    balances @2 :List(Balance);
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


struct AccountCredentials {
    accountID @0 :UInt64;
    apiKey @1 :Text;
    secretKey @2 :Text;
    passphrase @3 :Text;
}


#######################################################################################################