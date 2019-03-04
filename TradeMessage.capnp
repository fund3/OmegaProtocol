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
    stop @3;
    stopLimit @4;
    trailingStop @5;
    trailingStopLimit @6;
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
    failed @12;
}


enum ExecutionType {
    orderAccepted @0;
    orderRejected @1;
    orderReplaced @2;
    replaceRejected @3;
    orderCanceled @4;
    cancelRejected @5;
    orderFilled @6;
    statusUpdate @7;
    statusUpdateRejected @8;
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


enum AccountType {
    undefined @0;
    exchange @1;
    margin @2;
    combined @3;
}


struct AccountInfo {
    accountID @0 :UInt64;              # account ID, required

    # next parameters empty in client request
    exchange @1 :Exchange;             # exchange 
    accountType @2 :AccountType;       # exchange account type (exhange, margin, combined)
    exchangeAccountID @3 :Text;        # exchange account/wallet ID
    exchangeClientID @4 :Text;         # exchange client (customer) ID
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
    accessToken @2 :Text; 
    requestID @3 :UInt64;

    body :union {
        # system
        heartbeat @4 :Void;                               # response: Heartbeat
        test @5 :TestMessage;                             # response: TestMessage
        getServerTime @6 :Void;                           # response: UNIX timestamp

        # logon-logoff
        logon @7 :Logon;                                  # response: LogonAck
        logoff @8 :Void;                                  # response: LogoffAck
        authorizationRefresh @9 :AuthorizationRefresh;    # response: AuthorizationGrant 

        # trading requests
        placeSingleOrder @10 :PlaceOrder;                 # response: ExecutionReport
        replaceOrder @11 :ReplaceOrder;                   # response: ExecutionReport
        cancelOrder @12 :CancelOrder;                     # response: ExecutionReport
        getOrderStatus @13 :GetOrderStatus;               # response: ExecutionReport
        getOrderMassStatus @14 :GetOrderMassStatus;       # response: Individual ExecutionReport per message 

        # account-related request
        getAccountData @15 :GetAccountData;               # response: AccountDataReport
        getAccountBalances @16 :GetAccountBalances;       # response: AccountBalancesReport
        getOpenPositions @17 :GetOpenPositions;           # response: OpenPositionsReport
        getWorkingOrders @18 :GetWorkingOrders;           # response: WorkingOrdersReport
        getCompletedOrders @19 :GetCompletedOrders;       # response: CompletedOrdersReport
        getExchangeProperties @20 :GetExchangeProperties; # response: ExchangePropertiesReport
    }
}


struct Logon {
    clientSecret @0 :Text;                           # required
    credentials @1 :List(AccountCredentials);        # required
}


struct PlaceOrder {
    accountInfo @0 :AccountInfo;                     # required
    clientOrderID @1 :UInt64;                        # required
    clientOrderLinkID @2 :Text;                      # optional
    orderID @3 :Text;                                # empty in client request
    symbol @4 :Text;                                 # required
    side @5 :Side;                                   # required
    orderType @6 :OrderType = limit;                 # optional, default : LIMIT
    quantity @7 :Float64;                            # required
    price @8 :Float64;                               # required for LIMIT
    timeInForce @9 :TimeInForce = gtc;               # optional, default : GTC
    expireAt @10 :Float64;                           # optional, for GTT only
    leverageType @11 :LeverageType;                  # optional, default : None
    leverage @12 :Float64;                           # optional, default : 0 (no leverage)
}


struct ReplaceOrder {
    accountInfo @0 :AccountInfo;                     # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    clientOrderLinkID @3: Text;                      # empty in client request
    exchangeOrderID @4 :Text;                        # empty in client request
    symbol @5 :Text;                                 # empty in client request
    side @6 :Side;                                   # empty in client request
    orderType @7 :OrderType;                         # empty in client request
    quantity @8 :Float64;                            # optional
    price @9 :Float64;                               # optional
    timeInForce @10 :TimeInForce;                    # empty in client request
    expireAt @11 :Float64;                           # empty in client request
    leverageType @12 :LeverageType;                  # empty in client request
    leverage @13 :Float64;                           # empty in client request
}


struct CancelOrder {
    accountInfo @0 :AccountInfo;                     # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    clientOrderLinkID @3: Text;                      # empty in client request
    exchangeOrderID @4 :Text;                        # empty in client request
    symbol @5 :Text;                                 # empty in client request
}


struct GetOrderStatus {
    accountInfo @0 :AccountInfo;                     # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    clientOrderLinkID @3: Text;                      # empty in client request
    exchangeOrderID @4 :Text;                        # empty in client request
    symbol @5 :Text;                                 # empty in client request
}


struct GetOrderMassStatus {
    accountInfo @0 :AccountInfo;                     # required

    struct OrderInfo {
        orderID @0 :Text;                            # required
        clientOrderID @1 :UInt64;                    # empty in client request
        clientOrderLinkID @2: Text;                  # empty in client request
        exchangeOrderID @3 :Text;                    # empty in client request
        symbol @4 :Text;                             # empty in client request
    }

    orderInfo @1 :List(OrderInfo);
}


# return full account snapshot including balances and working orders in one transaction
struct GetAccountData {
    accountInfo @0 :AccountInfo;                     # required
}


struct GetAccountBalances {
    accountInfo @0 :AccountInfo;                     # required
}


struct GetOpenPositions {
    accountInfo @0 :AccountInfo;                     # required
}


struct GetWorkingOrders {
    accountInfo @0 :AccountInfo;                     # required
}


struct GetCompletedOrders {
    accountInfo @0 :AccountInfo;                     # required
    count @1 :UInt64;                                # optional, number of returned orders (most recent ones)
    since @2 :Float64;                               # optional, UNIX timestamp, limit orders by completion time, if both 'count' and 'since' skipped returns orders for last 24h
}


struct GetExchangeProperties {
    exchange @0 :Exchange;                           # required
}


struct AccountCredentials {
    accountInfo @0 :AccountInfo;
    apiKey @1 :Text = "<NONE>";
    secretKey @2 :Text = "<NONE>";
    passphrase @3 :Text = "<NONE>";
}


struct TestMessage {
    string @0 :Text;
}


struct AuthorizationRefresh {
    refreshToken @0 :Text;
}



#######################################################################################################
#                   RESPONSE
#######################################################################################################


struct Response {
    clientID @0 :UInt64;
    senderCompID @1 :Text;
    requestID @2 :UInt64;
    body :union {
        # system
        heartbeat @3 :Void;
        test @4 :TestMessage;
        serverTime @5 :Float64;
        system @6 : SystemMessage;

        # logon-logoff
        logonAck @7 :LogonAck;
        logoffAck @8 :LogoffAck;
        authorizationGrant @9 :AuthorizationGrant;

        # trading
        executionReport @10 :ExecutionReport;

        # accounting
        accountDataReport @11 :AccountDataReport;
        accountBalancesReport @12 :AccountBalancesReport;
        openPositionsReport @13 :OpenPositionsReport;
        workingOrdersReport @14 :WorkingOrdersReport;
        completedOrdersReport @15 :CompletedOrdersReport;
        exchangePropertiesReport @16 :ExchangePropertiesReport;
    }
}


# sends as respond to place, modify, cancel, getOrderStatus requests
struct ExecutionReport {
    orderID @0 :Text = "<UNDEFINED>";
    clientOrderID @1 :UInt64;
    clientOrderLinkID @2: Text;
    exchangeOrderID @3 :Text = "<UNDEFINED>";
    accountInfo @4 :AccountInfo;
    symbol @5 :Text = "<UNDEFINED>";
    side @6 :Side;
    orderType @7 :OrderType;
    quantity @8 :Float64;
    price @9 :Float64;
    timeInForce @10 :TimeInForce;
    expireAt @11 :Float64;
    leverageType @12 :LeverageType;
    leverage @13 :Float64;
    orderStatus @14 :OrderStatus;
    filledQuantity @15 :Float64;
    avgFillPrice @16 :Float64;
    fee @17 :Float64;
    creationTime @18 :Float64;
    submissionTime @19 :Float64;
    completionTime @20 :Float64;
    rejectionReason @21 :Message;
    executionType @22 :ExecutionType;
}



struct AccountDataReport {
    accountInfo @0 :AccountInfo;
    balances @1 :List(Balance);
    openPositions @2 :List(OpenPosition);
    orders @3 :List(ExecutionReport);
}


struct AccountBalancesReport {
    accountInfo @0 :AccountInfo;
    balances @1 :List(Balance);
}


struct OpenPositionsReport {
    accountInfo @0 :AccountInfo;
    openPositions @1 :List(OpenPosition);
}


struct WorkingOrdersReport{
    accountInfo @0 :AccountInfo;
    orders @1 :List(ExecutionReport);
}


struct CompletedOrdersReport{
    accountInfo @0 :AccountInfo;
    orders @1 :List(ExecutionReport);
}


struct ExchangePropertiesReport{
    exchange @0 :Exchange;
    currencies @1 :List(Text);
    symbolProperties @2 :List(SymbolProperties);
    timeInForces @3 :List(TimeInForce);
    orderTypes @4 :List(OrderType);
}


struct SymbolProperties{
    symbol @0 :Text;
    pricePrecision @1 :Float64;
    quantityPrecision @2 :Float64;
    minQuantity @3 :Float64;
    maxQuantity @4 :Float64;
    marginSupported @5 :Bool;
    leverage @6 :List(Float64);
}


struct LogonAck {
    success @0 :Bool;
    message @1 :Message;
    clientAccounts @2 :List(AccountInfo);
    authorizationGrant @3  :AuthorizationGrant;
}


struct LogoffAck {
    success @0 :Bool;
    message @1 :Message;
}


struct AuthorizationGrant {
    success @0 :Bool;
    message @1 :Message;
    accessToken @2 :Text;
    refreshToken @3 :Text;
    expireAt @4 :Float64; 
}


struct SystemMessage {
    accountInfo @0 :AccountInfo;
    message @1 :Message;
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


struct Message {
    code @0 :UInt32;
    body @1 :Text = "<NONE>";
}

#######################################################################################################
