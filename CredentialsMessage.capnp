using Cxx = import "/capnp/c++.capnp";

$Cxx.namespace("proto");
@0xc880f6db4d43d655;



struct AccountCredentials {
    accountID @0 :UInt64;
    apiKey @1 :Text = "<NONE>";
    secretKey @2 :Text = "<NONE>";
    passphrase @3 :Text = "<NONE>";
}



struct CredentialsMessage {
    type :union {
        request @0 :Request;
        response @1 :Response;
    }
}


struct Request {
    clientID @0 :Text;
}



struct Response {
    clientID @0 :Text;
    accountCredentials @1 :List(AccountCredentials);
}


#######################################################################################################