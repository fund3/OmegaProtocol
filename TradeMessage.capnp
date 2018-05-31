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
    expired @11;
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
        heartbeat @2 :Void;                          # response: Heartbeat
        test @3 :TestMessage;                        # response: TestMessage

        # logon-logoff
        logon @4 :Logon;                             # response: LogonAck
        logoff @5 :Logoff;                           # response: LogoffAck
        
        # trading requests
        placeOrder @6 :PlaceOrder;                   # response: ExecutionReport
        replaceOrder @7 :ReplaceOrder;               # response: ExecutionReport
        cancelOrder @8 :CancelOrder;                 # response: ExecutionReport
        getOrderStatus @9 :GetOrderStatus;           # response: ExecutionReport

        # account-related request
        getAccountData @10 :GetAccountData;          # response: AccountDataReport
        getWorkingOrders @11 :GetWorkingOrders;      # response: WorkingOrdersReport
        getAccountBalances @12 :GetAccountBalances;  # response: AccountBalancesReport
    }
}


struct Logon {
    credentials @0 :List(AccountCredentials);        # should not be set in client request, for internal usage only
}


struct Logoff {
    clientAccounts @0 :List(UInt64);                 # should not be set in client request, for internal usage only
}


struct PlaceOrder {
    accountID @0 :UInt64;                            # required
    clientOrderID @1 :UInt64;                        # required
    orderID @2 :Text;                                # empty in client request
    symbol @3 :Text;                                 # required
    orderSide @4 :OrderSide;                         # required
    orderType @5 :OrderType = limit;                 # optional, default : LIMIT
    orderQuantity @6 :Float64;                       # required
    orderPrice @7 :Float64;                          # required for LIMIT
    timeInForce @8 :TimeInForce = gtc;               # optional, default : GTC 
}


struct ReplaceOrder {
    accountID @0 :UInt64;                            # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    exchangeOrderID @3 :Text;                        # empty in client request
    symbol @4 :Text;                                 # empty in client request
    orderSide @5 :OrderSide;                         # optional
    orderType @6 :OrderType;                         # optional
    orderQuantity @7 :Float64;                       # optional
    orderPrice @8 :Float64;                          # optional
    timeInForce @9 :TimeInForce;                     # optional
}


struct CancelOrder {
    accountID @0 :UInt64;                            # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    exchangeOrderID @3 :Text;                        # empty in client request
    symbol @4 :Text;                                 # empty in client request
}


struct GetOrderStatus {
    accountID @0 :UInt64;                            # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    exchangeOrderID @3 :Text;                        # empty in client request
}


# return full account snapshot including balances and working orders in one transaction
struct GetAccountData {
    accountID @0 :UInt64;                            # required
}


struct GetWorkingOrders {
    accountID @0 :UInt64;                            # required
}


struct GetAccountBalances {
    accountID @0 :UInt64;                            # required
}




struct AccountCredentials {
    accountID @0 :UInt64;
    apiKey @1 :Text = "<NONE>";
    secretKey @2 :Text = "<NONE>";
    passphrase @3 :Text = "<NONE>";
}


struct TestMessage {
    string @0 :Text;
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
        test @3 :TestMessage;
        system @4 : SystemMessage;

        # logon-logoff
        logonAck @5 :LogonAck;
        logoffAck @6 :LogoffAck;

        # trading
        executionReport @7 :ExecutionReport;

        #accounting
        accountDataReport @8 :AccountDataReport;
        workingOrdersReport @9 :WorkingOrdersReport;
        accountBalancesReport @10 :AccountBalancesReport;
    }
}


# sends as respond to place, modify, cancel, getOrderStatus requests
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
        statusRequested @15 :Void;
    }
}


struct AccountDataReport {
    accountID @0 :UInt64;
    exchange @1 :Exchange;
    balances @2 :List(Balance);
    orderList @3 :List(OrderData);
    ready @4 :Bool;
}


struct WorkingOrdersReport{
    accountID @0 :UInt64;
    exchange @1 :Exchange;
    orderList @2 :List(OrderData);
}


struct AccountBalancesReport {
    accountID @0 :UInt64;
    exchange @1 :Exchange;
    balances @2 :List(Balance);
}


struct LogonAck {
    success @0 :Bool;
    message @1 :Text = "<NONE>";
    clientAccounts @2 :List(UInt64);
}


struct LogoffAck {
    success @0 :Bool;
    message @1 :Text = "<NONE>";
}


struct SystemMessage {
    accountID @0 :UInt64;
    exchange @1 :Exchange;
    message @2 :Text = "<NONE>";
}


struct RequestRejected {
    rejectionReason @0 :Text = "<NONE>";
}


struct OrderData {
    orderID @0 :Text = "<UNDEFINED>";
    clientOrderID @1 :UInt64;
    exchangeOrderID @2 :Text = "<UNDEFINED>";
    symbol @3 :Text = "<UNDEFINED>";
    orderSide @4 :OrderSide;
    orderType @5 :OrderType;
    orderQuantity @6 :Float64;
    orderPrice @7 :Float64;
    timeInForce @8 :TimeInForce;
    orderStatus @9 :OrderStatus;
    filledQuantity @10 :Float64;
    avgFillPrice @11 :Float64;
}


struct Balance {
    currency @0 :Text = "<UNDEFINED>";
    fullBalance @1 :Float64;
    availableBalance @2 :Float64;   
}


#######################################################################################################