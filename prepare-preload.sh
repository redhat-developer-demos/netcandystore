echo 'Remove old preload.yaml'
rm preload.yaml

echo ' Make a new preload.yaml'
cp preload-netcandystore.yaml preload.yaml

echo 'Get node id into environment variable'
export JACK_SPARROW=`oc get nodes -l kubernetes.io/os=windows -o jsonpath='{.items[0].metadata.name}'`

echo 'Put node id into preload.yaml'
sed -i "s|{jacksparrow}|$JACK_SPARROW|g" preload.yaml

echo 'You can now run ./preload.yaml'