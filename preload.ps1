remove-item preload.yaml -force
cp preload-netcandystore.yaml preload.yaml
$env:JACK_SPARROW=oc get nodes -l kubernetes.io/os=windows -o jsonpath='{.items[0].metadata.name}'
(Get-Content preload.yaml).replace('{jacksparrow}', $env:JACK_SPARROW) | Set-Content preload.yaml