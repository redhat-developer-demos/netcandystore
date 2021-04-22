## DELETE EVERYTHING EXISTING
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "-"
Write-Output "DELETING *ALL* OLD MSSQL artifacts!"
Write-Output "You have FIVE SECONDS to Ctrl-C cancel this!"
Write-Output "-"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Write-Output "***************************************************"
Start-Sleep -Seconds 5

oc delete dc mssql
oc delete pvc mssql-pvc 
oc delete svc mssql 
oc delete secret mssql-secret


# Get MS SQL Server Template
oc create -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore-persistent-ex/dotnetcore-3.1-mssql/openshift/mssql2019.json

# Create MS SQL Server Instance
$s = oc new-app --template=mssql2019 -p ACCEPT_EULA=Y -p SA_PASSWORD=reallylongpassword99!

# Example out from previous statement
#--> Deploying template "netcandystore/mssql2019" to project netcandystore

#     Microsoft SQL Server 2019
#     ---------
#     Relational database management system developed by Microsoft.

#     * With parameters:
#        * Name=mssql
#        * Administrator Password=aA1aeQWoEya # generated
#        * Accept the End-User Licensing Agreement=Y
#        * Product ID or Edition=Developer
#        * Persistent Volume Capacity=512Mi



$sapassword = "reallylongpassword99!"
Write-Output "sa password is " ${sapassword}


# TODO Get ID of pod running MS SQL Server
$thepods = oc get pods | Select-String 'mssql'
echo $thepods
DO {
    Write-Output 'Waiting for pods to start...'
    $thepods = oc get pods | Select-String 'mssql'
    echo $thepods
    echo $thepods.length
} Until ($thepods.length -eq 2)

# Find NOT -deploy pod
$i = 0
$podindex = 0
$podname = "no pod name found"

$thepods = oc get pods -o json | ConvertFrom-JSON
ForEach ($pod in $thepods.items) {
    Write-Output "inspecting pod" $pod.metadata.name
    if (($pod.metadata.name -like "*mssql*" -and $pod.metadata.name -notlike "*deploy*")) {
        # This is our pod!
        $podindex = $i
        $podname = $pod.metadata.name
        Write-Output "Pod FOUND: " $podname
    }
    $i = $i + 1
}

# Loop until NOT -deploy pod is running, i.e. $thepods.items.status[1].phase = "Running"
Write-Output "SQL Server Pod status is " $thepods.items.status[${podindex}].phase
Write-Output "Will check on pod status every five seconds until pod is running..."
DO {
    Start-Sleep -Seconds 5
    $thepods = oc get pods -o json | ConvertFrom-JSON
    Write-Output "pod status is " $thepods.items.status[${podindex}].phase
} UNTIL ($thepods.items.status[${podindex}].phase -eq "Running")

# Report
Write-Output "MS SQL Server pod is: " $podname
Write-Output "Waiting for SQL Server to start..."
Start-Sleep -Seconds 10

# Create database CandiesDB
Write-Output "Create database CandiesDB"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-database-candiesdb.sql ${podname}:/tmp/create-database-candiesdb.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-database-candiesdb.sql

# Create table StatusCodes
Write-Output "Create table StatusCodes"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-table-statuscodes.sql ${podname}:/tmp/create-table-statuscodes.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-table-statuscodes.sql

# Populate table StatusCodes
Write-Output "Populate table StatusCodes"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\StatusCodes.csv ${podname}:/tmp/StatusCodes.csv
oc cp .\populate-table-statuscodes.sql ${podname}:/tmp/populate-table-statuscodes.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/populate-table-statuscodes.sql

# Create table ProductCategories
Write-Output "Create table ProductCategories"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-table-productcategories.sql ${podname}:/tmp/create-table-productcategories.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-table-productcategories.sql

# Populate table ProductCategories
Write-Output "Populate table ProductCategories"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\ProductCategories.csv ${podname}:/tmp/ProductCategories.csv
oc cp .\populate-table-productcategories.sql ${podname}:/tmp/populate-table-productcategories.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/populate-table-productcategories.sql

# Create table Products
Write-Output "Create table Products"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-table-products.sql ${podname}:/tmp/create-table-products.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-table-products.sql

# Populate table Products
Write-Output "Populate table Products"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\Products.csv ${podname}:/tmp/Products.csv
oc cp .\populate-table-products.sql ${podname}:/tmp/populate-table-products.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/populate-table-products.sql

# Create table ShoppingCart
Write-Output "Create table ShoppingCart"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-table-shoppingcart.sql ${podname}:/tmp/create-table-shoppingcart.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-table-shoppingcart.sql

# Create table ShoppingCartItem
Write-Output "Create table ShoppingCartItem"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-table-shoppingcartitem.sql ${podname}:/tmp/create-table-shoppingcartitem.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-table-shoppingcartitem.sql

# Create view vwProducts
Write-Output "Create view vwProducts"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-view-vwproducts.sql ${podname}:/tmp/create-view-vwproducts.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-view-vwproducts.sql

# Create view vwShoppingCart
Write-Output "Create view vwShoppingCart"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-view-vwshoppingcart.sql ${podname}:/tmp/create-view-vwshoppingcart.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-view-vwshoppingcart.sql

# Create view vwShoppingCartItems
Write-Output "Create view vwShoppingCartItems"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-view-vwshoppingcartitems.sql ${podname}:/tmp/create-view-vwshoppingcartitems.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-view-vwshoppingcartitems.sql

# Create sproc CalculateCartTotal
Write-Output "Create sproc CalculateCartTotal"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-calculatecarttotal.sql ${podname}:/tmp/create-sproc-calculatecarttotal.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-calculatecarttotal.sql

# Create sproc AddToCart
Write-Output "Create sproc AddToCart"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-addtocart.sql ${podname}:/tmp/create-sproc-addtocart.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-addtocart.sql

# Create sproc CreateShoppingCart
Write-Output "Create sproc CreateShoppingCart"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-createshoppingcart.sql ${podname}:/tmp/create-sproc-createshoppingcart.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-createshoppingcart.sql

# Create sproc GetProductsByCategoryId
Write-Output "Create sproc GetProductsByCategoryId"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-getproductsbycategoryid.sql ${podname}:/tmp/create-sproc-getproductsbycategoryid.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-getproductsbycategoryid.sql

# Create sproc GetProductsBySearch
Write-Output "Create sproc GetProductsBySearch"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-getproductsbysearch.sql ${podname}:/tmp/create-sproc-getproductsbysearch.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-getproductsbysearch.sql

# Create sproc GetShoppingCart
Write-Output "Create sproc GetShoppingCart"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-getshoppingcart.sql ${podname}:/tmp/create-sproc-getshoppingcart.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-getshoppingcart.sql

# Create sproc GetShoppingCartItems
Write-Output "Create sproc GetShoppingCartItems"
Write-Output "    Copying command..."
Write-Output "    Executing command..."
oc cp .\create-sproc-getshoppingcartitems.sql ${podname}:/tmp/create-sproc-getshoppingcartitems.sql
oc exec ${podname} -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${sapassword} -i /tmp/create-sproc-getshoppingcartitems.sql

Write-Output "Your CandieDB database is up and ready to go."