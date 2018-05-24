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
}
