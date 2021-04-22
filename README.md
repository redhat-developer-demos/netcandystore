# NetCandyStore
.NET Framework online Candy Store using Windows Containers in OpenShift

# Prerequisites
1. Access to an OpenShift cluster that supports Windows Containers
1. The `oc` command-line interface for OpenShift

# Table of Contents/Steps
1. Create a cluster that supports Windows Containers
1. Create a project
1. Create and populate the MS SQL Server database
1. Prepare Windows Container node
1. Create the service 'netcandystore'
1. Create route for service 'netcandystore'
1. Create the service 'getcategories'
1. COMING SOON: Replace the service 'netcandystore" using image netcandystore:v2

## Step 1: Create a cluster the supports Windows Containers
(some RHPDS magic here)

## Step 2: Create a project
At the command line, run the command  
`oc new-project netcandystore`

Alternatively, you can use the OpenShift console to create the new project "netcandystore".

## Step 3: Create and populate the MS SQL Server database
For the purposes of this demo, this instance of MS SQL Server will run in our OpenShift cluster.

### Linux and macOS
Run the script `create_database.sh`  

### PowerShell
Run the script `create_database.ps1`

## Step 4: Prepare Windows Container node
This step will pull the image into the node running Windows Containers.

### Linux and macOS  
Run the command:  
`./prepare-preload.sh`  

### PowerShell  

Run the command:  
`./preload.ps1`  

## Step 5: Create the service 'netcandystore'
The service runs in a Windows Container and uses the image quay.io/donschenck/netcandystore:2021mar8.1

Run the command:  
`oc create -f preload.yaml`  

Run the following command and wait until the preload job is finished:  
`oc get jobs -n openshift-windows-machine-config-operator -w`

When the job is completed, press Ctrl-C to exit the wait command.

Run the command:  
`oc apply -f netcandystore.yaml`

## Step 6: Create route for service 'netcandystore'

### PowerShell
Run the command:  
`oc apply -f netcandystore-route.yaml`  

## Step 7: Create the service 'getcategories'
### PowerShell  
Run the command:  
`oc apply -f getcategories.yaml`

