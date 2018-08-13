using Cxx = import "/capnp/c++.capnp";
using import "Exchanges.capnp".Exchange;

$Cxx.namespace("proto::trade");
@0xb1f6c0f74d970d0c;


#######################################################################################################
#                   COMMON TYPES
#######################################################################################################


enum Side {
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


enum LeverageType {
    none @0;               # no leverage (by default)
    exchangeDefault @1;    # use predefined exchange leverage
    custom @2;             # use custom leverage
}


struct Account {
    id @0 :UInt64;         # AccountID, required
    label @1 :Text;        # exchange account lavel (default, margin, exchange, etc), empty in client request  
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
    clientID @0 :UInt64;
    senderCompID @1 :Text;

    body :union {
        # system
        heartbeat @2 :Void;                          # response: Heartbeat
        test @3 :TestMessage;                        # response: TestMessage

        # logon-logoff
        logon @4 :Logon;                             # response: LogonAck
        logoff @5 :Void;                             # response: LogoffAck
        
        # trading requests
        placeOrder @6 :PlaceOrder;                   # response: ExecutionReport
        replaceOrder @7 :ReplaceOrder;               # response: ExecutionReport
        cancelOrder @8 :CancelOrder;                 # response: ExecutionReport
        getOrderStatus @9 :GetOrderStatus;           # response: ExecutionReport

        # account-related request
        getAccountData @10 :GetAccountData;          # response: AccountDataReport
        getAccountBalances @11 :GetAccountBalances;  # response: AccountBalancesReport
        getOpenPositions @12 :GetOpenPositions;      # response: OpenPositionsReport
        getWorkingOrders @13 :GetWorkingOrders;      # response: WorkingOrdersReport
    }
}


struct Logon {
    credentials @0 :List(AccountCredentials);        # required
}


struct PlaceOrder {
    account @0 :Account;                             # required
    clientOrderID @1 :UInt64;                        # required
    orderID @2 :Text;                                # empty in client request
    symbol @3 :Text;                                 # required
    side @4 :Side;                                   # required
    orderType @5 :OrderType = limit;                 # optional, default : LIMIT
    quantity @6 :Float64;                            # required
    price @7 :Float64;                               # required for LIMIT
    timeInForce @8 :TimeInForce = gtc;               # optional, default : GTC 
    leverageType @9 :LeverageType;                   # optional, default : None
    leverage @10 :Float64;                           # optional, default : 0 (no leverage)
}


struct ReplaceOrder {
    account @0 :Account;                             # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    exchangeOrderID @3 :Text;                        # empty in client request
    symbol @4 :Text;                                 # empty in client request
    side @5 :Side;                                   # optional
    orderType @6 :OrderType;                         # optional
    quantity @7 :Float64;                            # optional
    price @8 :Float64;                               # optional
    timeInForce @9 :TimeInForce;                     # optional
    leverageType @10 :LeverageType;                  # empty in client request
    leverage @11 :Float64;                           # empty in client request
}


struct CancelOrder {
    account @0 :Account;                             # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    exchangeOrderID @3 :Text;                        # empty in client request
    symbol @4 :Text;                                 # empty in client request
}


struct GetOrderStatus {
    account @0 :Account;                             # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    exchangeOrderID @3 :Text;                        # empty in client request
    symbol @4 :Text;                                 # empty in client request
}


# return full account snapshot including balances and working orders in one transaction
struct GetAccountData {
    account @0 :Account;                             # required
}


struct GetAccountBalances {
    account @0 :Account;                             # required
}


struct GetOpenPositions {
    account @0 :Account;                             # required
}


struct GetWorkingOrders {
    account @0 :Account;                             # required
}



struct AccountCredentials {
    account @0 :Account;
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
    clientID @0 :UInt64;
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

        # accounting
        accountDataReport @8 :AccountDataReport;
        accountBalancesReport @9 :AccountBalancesReport;
        openPositionsReport @10 :OpenPositionsReport;
        workingOrdersReport @11 :WorkingOrdersReport;
    }
}


# sends as respond to place, modify, cancel, getOrderStatus requests
struct ExecutionReport {
    orderID @0 :Text = "<UNDEFINED>";
    clientOrderID @1 :UInt64;
    exchangeOrderID @2 :Text = "<UNDEFINED>";
    account @3 :Account; 
    exchange @4 :Exchange;
    symbol @5 :Text = "<UNDEFINED>";
    side @6 :Side;
    orderType @7 :OrderType;
    quantity @8 :Float64;
    price @9 :Float64;
    timeInForce @10 :TimeInForce;
    leverageType @11 :LeverageType;
    leverage @12 :Float64;      
    orderStatus @13 :OrderStatus;
    filledQuantity @14 :Float64;
    avgFillPrice @15 :Float64;

    type :union {
        orderAccepted @16 :Void;
        orderRejected @17 :RequestRejected;
        orderReplaced @18 :Void;
        replaceRejected @19 :RequestRejected;
        orderCanceled @20 :Void;
        cancelRejected @21 :RequestRejected;
        orderFilled @22 :Void;
        statusUpdate @23 :Void;
    }
}



struct AccountDataReport {
    account @0 :Account;
    exchange @1 :Exchange;
    balances @2 :List(Balance);
    openPositions @3 :List(OpenPosition);
    orders @4 :List(ExecutionReport);
}


struct AccountBalancesReport {
    account @0 :Account;
    exchange @1 :Exchange;
    balances @2 :List(Balance);
}


struct OpenPositionsReport {
    account @0 :Account;
    exchange @1 :Exchange;
    openPositions @2 :List(OpenPosition);
}


struct WorkingOrdersReport{
    account @0 :Account;
    exchange @1 :Exchange;
    orders @2 :List(ExecutionReport);
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
    account @0 :Account;
    exchange @1 :Exchange;
    message @2 :Text = "<NONE>";
}


struct RequestRejected {
    rejectionReason @0 :Text = "<NONE>";
}


struct Balance {
    currency @0 :Text = "<UNDEFINED>";
    fullBalance @1 :Float64;
    availableBalance @2 :Float64;   
}


struct OpenPosition {
    symbol @0 :Text = "<UNDEFINED>";    # symbol
    side @1 :Side;                      # position side (buy or sell)
    quantity @2 :Float64;               # positiion quantity
    initialPrice @3 :Float64;           # initial price
    unrealizedPL @4 :Float64;           # unrealized profit/loss before fees
}


#######################################################################################################