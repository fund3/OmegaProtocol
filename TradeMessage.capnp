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

    body :union {
        # system
        heartbeat @2 :Void;                               # response: Heartbeat
        test @3 :TestMessage;                             # response: TestMessage

        # logon-logoff
        logon @4 :Logon;                                  # response: LogonAck
        logoff @5 :Void;                                  # response: LogoffAck

        # trading requests
        placeOrder @6 :PlaceOrder;                        # response: ExecutionReport
        replaceOrder @7 :ReplaceOrder;                    # response: ExecutionReport
        cancelOrder @8 :CancelOrder;                      # response: ExecutionReport
        getOrderStatus @9 :GetOrderStatus;                # response: ExecutionReport
        getOrderMassStatus @10 :GetOrderMassStatus;       # response: WorkingOrdersReport

        # account-related request
        getAccountData @11 :GetAccountData;               # response: AccountDataReport
        getAccountBalances @12 :GetAccountBalances;       # response: AccountBalancesReport
        getOpenPositions @13 :GetOpenPositions;           # response: OpenPositionsReport
        getWorkingOrders @14 :GetWorkingOrders;           # response: WorkingOrdersReport
        getCompletedOrders @15 :GetCompletedOrders;       # response: CompletedOrdersReport
        getExchangeProperties @16 :GetExchangeProperties; # response: ExchangePropertiesReport
    }
}


struct Logon {
    credentials @0 :List(AccountCredentials);        # required
}


struct PlaceOrder {
    accountInfo @0 :AccountInfo;                     # required
    clientOrderID @1 :UInt64;                        # required
    clientOrderLinkID @2: Text;                      # optional
    orderID @3 :Text;                                # empty in client request
    symbol @4 :Text;                                 # required
    side @5 :Side;                                   # required
    orderType @6 :OrderType = limit;                 # optional, default : LIMIT
    quantity @7 :Float64;                            # required
    price @8 :Float64;                               # required for LIMIT
    timeInForce @9 :TimeInForce = gtc;               # optional, default : GTC
    leverageType @10 :LeverageType;                  # optional, default : None
    leverage @11 :Float64;                           # optional, default : 0 (no leverage)
}


struct ReplaceOrder {
    accountInfo @0 :AccountInfo;                     # required
    orderID @1 :Text;                                # required
    clientOrderID @2 :UInt64;                        # empty in client request
    clientOrderLinkID @3: Text;                      # empty in client request
    exchangeOrderID @4 :Text;                        # empty in client request
    symbol @5 :Text;                                 # empty in client request
    side @6 :Side;                                   # empty in client request
    orderType @7 :OrderType;                         # optional
    quantity @8 :Float64;                            # optional
    price @9 :Float64;                               # optional
    timeInForce @10 :TimeInForce;                    # optional
    leverageType @11 :LeverageType;                  # empty in client request
    leverage @12 :Float64;                           # empty in client request
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
        completedOrdersReport @12 :CompletedOrdersReport;
        exchangePropertiesReport @13 :ExchangePropertiesReport;
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
    leverageType @11 :LeverageType;
    leverage @12 :Float64;
    orderStatus @13 :OrderStatus;
    filledQuantity @14 :Float64;
    avgFillPrice @15 :Float64;
    rejectionReason @16 :Text;

    type :union {
        orderAccepted @17 :Void;
        orderRejected @18 :RequestRejected;
        orderReplaced @19 :Void;
        replaceRejected @20 :RequestRejected;
        orderCanceled @21 :Void;
        cancelRejected @22 :RequestRejected;
        orderFilled @23 :Void;
        statusUpdate @24 :Void;
        statusUpdateRejected @25 :RequestRejected;
    }
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
    message @1 :Text = "<NONE>";
    clientAccounts @2 :List(UInt64);
}


struct LogoffAck {
    success @0 :Bool;
    message @1 :Text = "<NONE>";
}


struct SystemMessage {
    accountInfo @0 :AccountInfo;
    errorCode @1 :UInt32;
    message @2 :Text = "<NONE>";
}


struct RequestRejected {
    rejectionCode @0 :UInt32;
    message @1 :Text = "<NONE>";
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
