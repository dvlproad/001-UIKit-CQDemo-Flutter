TARGETENVTYPE=$1
InFileName=$2
echo "TARGETENVTYPE=$TARGETENVTYPE"

ENVDEV1="(globalKey, PackageType.develop1);"
ENVDEV2="(globalKey, PackageType.develop2);"
ENVPREPRODUDT="(globalKey, PackageType.preproduct);"
ENVPRODUCT="(globalKey, PackageType.product);"

if [ $TARGETENVTYPE == "develop1" ] ; then
    TargetEnv=$ENVDEV1
elif [ $TARGETENVTYPE == "develop2" ] ; then
    TargetEnv=$ENVDEV2
elif [ $TARGETENVTYPE == "preproduct" ] ; then
    TargetEnv=$ENVPREPRODUDT
else
    TargetEnv=$ENVPRODUCT
fi
    #无论当前是什么环境，都给切过来
    sed -i '' "s/$ENVDEV1/$TargetEnv/g" $InFileName
    sed -i '' "s/$ENVDEV2/$TargetEnv/g" $InFileName
    sed -i '' "s/$ENVPREPRODUDT/$TargetEnv/g" $InFileName
    sed -i '' "s/$ENVPRODUCT/$TargetEnv/g" $InFileName

