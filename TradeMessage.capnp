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
    pendingReplace @6;
    replaced @7;
    pendingCancel @8;
    canceled @9;
    rejected @10;
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
    accountID @0 :UInt64;               # required
    clientOrderID @1 :UInt64;           # required
    orderID @2 :Text;                   # empty in client request
    symbol @3 :Text;                    # required
    orderSide @4 :OrderSide;            # required
    orderType @5 :OrderType = limit;    # optional, default : LIMIT
    orderQuantity @6 :Float64;          # required
    orderPrice @7 :Float64;             # required for LIMIT
    timeInForce @8 :TimeInForce = gtc;  # optional, default : GTC 
    exchange @9 :Exchange;              # required
}


struct ReplaceOrder {
    accountID @0 :UInt64;           # required
    orderID @1 :Text;               # required
    clientOrderID @2 :UInt64;       # empty in client request
    exchangeOrderID @3 :Text;       # empty in client request
    symbol @4 :Text;                # empty in client request
    orderSide @5 :OrderSide;        # optional
    orderType @6 :OrderType;        # optional
    orderQuantity @7 :Float64;      # optional
    orderPrice @8 :Float64;         # optional
    timeInForce @9 :TimeInForce;    # optional
    exchange @10 :Exchange;         # empty in client request
}


struct CancelOrder {
    accountID @0 :UInt64;           # required
    orderID @1 :Text;               # required
    clientOrderID @2 :UInt64;       # empty in client request
    exchangeOrderID @3 :Text;       # empty in client request
}


struct GetWorkingOrders {
    accountID @0 :UInt64;           # required
    orderID @1 :Text;               # if empty, return all working orders for the account
    clientOrderID @2 :UInt64;       # empty in client request
    exchangeOrderID @3 :Text;       # empty in client request
}


struct GetAccountBalances {
    accountID @0 :UInt64;           # required
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
        workingOrders @7 :WorkingOrders;
        accountBalances @8 :AccountBalances;
    }
}


# sends as respond to place, modify, cancel requests
struct ExecutionReport {
    orderID @0 :Text = "<UNDEFINED>";
    clientOrderID @1 :UInt64;
    exchangeOrderID @2 :Text = "<UNDEFINED>";
    accountID @3 :UInt64;
    exchange @4 :Exchange;
    orderStatus @5 :OrderStatus;
    filledQuantity @6 :Float64;
    avgFillPrice @7 :Float64;

    type :union {
        orderAccepted @8 :Void;
        orderRejected @9 :RequestRejected;
        orderReplaced @10 :Void;
        replaceRejected @11 :RequestRejected;
        orderCanceled @12 :Void;
        cancelRejected @13 :RequestRejected;
        orderFilled @14 :Void;
    }
}


struct RequestRejected {
    rejectionReason @0 :Text = "<NONE>";
}



### OrderData ###
struct OrderData {
    orderID @0 :Text = "<UNDEFINED>";
    clientOrderID @1 :UInt64;
    exchangeOrderID @2 :Text = "<UNDEFINED>";
    accountID @3 :UInt64;
    symbol @4 :Text = "<UNDEFINED>";
    orderSide @5 :OrderSide;
    orderType @6 :OrderType;
    orderQuantity @7 :Float64;
    orderPrice @8 :Float64;
    timeInForce @9 :TimeInForce;
    exchange @10 :Exchange;
    orderStatus @11 :OrderStatus;
    filledQuantity @12 :Float64;
    avgFillPrice @13 :Float64;
}


struct WorkingOrders{
    exchange @0 :Exchange;
    accountID @1 :UInt64;
    orderList @2 :List(OrderData);
}


### Balances ###

struct Balance {
    currency @0 :Text = "<UNDEFINED>";
    balance @1 :Float64;   
}


struct AccountBalances {
    exchange @0 :Exchange;
    accountID @1 :UInt64;
    balances @2 :List(Balance);
}


struct SystemMessage {
    exchange @0 :Exchange;
    accountID @1 :UInt64;
    message @2 :Text = "<NONE>";
}


struct LogonAck {
    success @0 :Bool;
    message @1 :Text = "<NONE>";
}


struct LogoffAck {
    success @0 :Bool;
    message @1 :Text = "<NONE>";
}


struct AccountCredentials {
    accountID @0 :UInt64;
    apiKey @1 :Text = "<NONE>";
    secretKey @2 :Text = "<NONE>";
    passphrase @3 :Text = "<NONE>";
}


#######################################################################################################