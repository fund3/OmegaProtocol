# enriched_tick.capnp
@0xe31eadfe6b56a4c1;

struct EnrichedTick
{
    timestamp @0 :UInt32;
    features @1 :List(Feature);
}

struct Feature
{
    name @0 :Text;
    value @1 :Float32;
}

# === Configuration messages ===

struct FeatureParam
{
    union{
        timespanSeconds @0 :UInt32;
        integer @1 :UInt32;
        real @2 :Float32;
        string @3 :Text;
        uintList @4 :List(UInt32);
    }
}

struct FeatureConfig
{
    name @0 :Text;
    param @1 : List(FeatureParam);
}

struct FeatureGeneratorConfig
{
    resolutionSeconds @0 :UInt32;
    inputValues @1 :List(Text);
    featuresToCalculate @2 :List(FeatureConfig);
}

struct StandardScalerConfig
{
    mean @0 :List(Float32);
    scale @1 :List(Float32);
}

struct MinmaxScalerConfig
{
    min @0 :List(Float32);
    scale @1 :List(Float32);
}

struct ScalerConfig
{
    union {
        standardScaler @0 :StandardScalerConfig;
        minmaxScaler @1 :MinmaxScalerConfig;
        none @2 :Void;
    }
}

struct GdaxBootstrap
{
    pairName @0 :Text;
    granularity @1 :UInt32;
    sinceTimestamp @2 :UInt32;
    untilTimestamp @3 :UInt32;
}

struct PoloBootstrap
{
    pairName @0 :Text;
    granularity @1 :UInt32;
    sinceTimestamp @2 :UInt32;
    untilTimestamp @3 :UInt32;
}

struct KrakenBootstrap
{
    pairName @0 :Text;
    granularity @1 :UInt32;
    sinceTimestamp @2 :UInt32;
    untilTimestamp @3 :UInt32;
}

struct BootstrapInfo
{
    union
    {
        internalCacheBootstrap @0 :Void;
        gdaxBootstrap @1 :GdaxBootstrap;
        poloBootstrap @2 :PoloBootstrap;
        krakenBootstrap @3 :KrakenBootstrap;
    }
}

struct TripleBarrierConfig
{
    tripleBarrierFraction @0: Float32;
    pt @1: Bool;
    sl @2: Bool;
    t1 @3: Bool;
}


struct LabelerConfig
{
# predictionHorizon: seconds for now, can be treated as anything later for e.g.
# dollar bars
    predictionHorizon @0 :UInt32;
    filterColumnName @1 :Text;
    tripleBarrierConfig :union
    {
        none @2 :Void;
        tripleBarrier @3 :TripleBarrierConfig;
    }
}

struct DppConfig
{
    fgConfig @0 :FeatureGeneratorConfig;
    scalerConfig @1 :ScalerConfig;
# TODO - maybe group into publisher config
    publishTo @2 :Text;
    publishToTopic @3 :Text;
# TODO - maybe group into subscriber config
    subscribeTo @4 :Text;
    subscribeToSymbol @5 :Text;
    subscribeToExchange @6 :Text;
    subscribeToTopic @7 :Text;
    bootstrapInfo @8 :BootstrapInfo;
    labelerConfig :union
    {
        none @9 :Void;
        labeler @10 :LabelerConfig;
    }
}
