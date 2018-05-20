using Cxx = import "/capnp/c++.capnp";

$Cxx.namespace("proto");
@0xa9a26f2e477dc8ed;

struct ModelDataMessage {
    timestamp @0 :Float64;               # POSIX Time

    parameters @1 :List(Text);          # optional, similar to python *args
    payloadQuantity :union{
        timeDelta @2 :Float64;          # in miliseconds. expample: datetime.timedelta(days=1, hours=1, seconds=1, milliseconds=1).total_seconds()
                                        # differents in time from the first row to last row of the dataframe
        tickResolution @3 :Float64;     # in miliseconds. expample: datetime.timedelta(days=1, hours=1, seconds=1, milliseconds=1).total_seconds()
    }

    numTicks @4 :UInt64;                # number of rows of returned dataframe

    type :union {
        request @5 :Request;
        response @6 :Response;
    }
}

struct Request{ 
    modelID @0 :Text;
    repsonseType @1 :ResponseType;
}

struct Response{
    repsonseType @0 :ResponseType;
    columns @1 :List(Text);
    body @2 :Data;                        # binary dataframe in Feather format
}

enum ResponseType{
    snapshot @0;
    update @1;
}


#TODO: add Volume or Time bars