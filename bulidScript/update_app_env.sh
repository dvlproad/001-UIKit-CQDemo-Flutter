#!/bin/bash
#sh update_app_env.sh develop1 pgyer ../wish/lib/main.dart

TARGETENVTYPE=$1
PackageTargetType=$2
InFileName=$3
echo "TARGETENVTYPE=$TARGETENVTYPE"
echo "PackageTargetType=$PackageTargetType"

if [ $TARGETENVTYPE == "develop1" ] ; then
    PackageEnvString="develop1"
elif [ $TARGETENVTYPE == "develop2" ] ; then
    PackageEnvString="develop2"
elif [ $TARGETENVTYPE == "preproduct" ] ; then
    PackageEnvString="preproduct"
else
    PackageEnvString="product"
fi

if [ $PackageTargetType == "formal" ] ; then
    PackageTargetString="formal"
else
    PackageTargetString="pgyer"
fi

TargetEnv="globalKey, PackageType.${PackageEnvString}, PackageTargetType.${PackageTargetString});"
echo "最后的环境为TargetEnv=$TargetEnv"

SpecialFlag1="globalKey, PackageType.develop1, PackageTargetType.pgyer);"
SpecialFlag2="globalKey, PackageType.develop2, PackageTargetType.pgyer);"
SpecialFlag3="globalKey, PackageType.preproduct, PackageTargetType.pgyer);"
SpecialFlag4="globalKey, PackageType.product, PackageTargetType.pgyer);"
SpecialFlag21="globalKey, PackageType.develop1, PackageTargetType.formal);"
SpecialFlag22="globalKey, PackageType.develop2, PackageTargetType.formal);"
SpecialFlag23="globalKey, PackageType.preproduct, PackageTargetType.formal);"
SpecialFlag24="globalKey, PackageType.product, PackageTargetType.formal);"
    #无论当前是什么环境，都给切过来
    sed -i '' "s/$SpecialFlag1/$TargetEnv/g" $InFileName
    sed -i '' "s/$SpecialFlag2/$TargetEnv/g" $InFileName
    sed -i '' "s/$SpecialFlag3/$TargetEnv/g" $InFileName
    sed -i '' "s/$SpecialFlag4/$TargetEnv/g" $InFileName

