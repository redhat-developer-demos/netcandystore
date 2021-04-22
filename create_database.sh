## DELETE EVERYTHING EXISTING
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"
echo "-"
echo "DELETING *ALL* OLD MSSQL artifacts!"
echo "You have FIVE SECONDS to Ctrl-C cancel this!"
echo "-"
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"
echo "***************************************************"

sleep 1

oc delete dc mssql
oc delete pvc mssql-pvc 
oc delete svc mssql 
oc delete secret mssql-secret


# Get MS SQL Server Template
oc create -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore-persistent-ex/dotnetcore-3.1-mssql/openshift/mssql2019.json

# Create MS SQL Server Instance
s=$(oc new-app --template=mssql2019 -p ACCEPT_EULA=Y -p SA_PASSWORD=reallylongpassword99!)

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



sapassword='reallylongpassword99!'
echo "sa password is " $sapassword


# TODO Get ID of pod running MS SQL Server
thepods=$(oc get pods | grep mssql)
echo $thepods
until [ $(oc get pods | grep mssql | wc -l) = 2 ]; do
    echo 'Waiting for pods to start...'
    thepods=$(oc get pods | grep mssql)
    echo $thepods
    echo $(oc get pods | grep mssql | wc -l)
done

echo 'MS SQL Server pods have started.'

# Find NOT -deploy pod
i=0
podindex=0
podname=$(oc get pods -o=name | grep mssql | grep -v deploy | sed 's|.*\/||')
echo 'podname is:' $podname

# Loop until NOT -deploy pod is running, i.e. $thepods.items.status[1].phase = "Running"
podstatus=$(oc get pod $podname --no-headers -o custom-columns=":status.phase")
echo "SQL Server Pod status is:" $podstatus
echo "Will check on pod status every five seconds until pod is running..."
until [ $podstatus == 'Running' ]; do
    sleep 5
    podstatus=$(oc get pod $podname --no-headers -o custom-columns=":status.phase")
    echo "pod status is " $podstatus
done

# Report
echo "MS SQL Server pod is: " $podname
echo "Waiting for SQL Server to start..."
sleep 10

# Create database CandiesDB
echo "Create database CandiesDB"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-database-candiesdb.sql $podname:/tmp/create-database-candiesdb.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-database-candiesdb.sql

# Create table StatusCodes
echo "Create table StatusCodes"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-table-statuscodes.sql $podname:/tmp/create-table-statuscodes.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-table-statuscodes.sql

# Populate table StatusCodes
echo "Populate table StatusCodes"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./StatusCodes.csv $podname:/tmp/StatusCodes.csv
oc cp ./populate-table-statuscodes-linux.sql $podname:/tmp/populate-table-statuscodes.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/populate-table-statuscodes.sql

# Create table ProductCategories
echo "Create table ProductCategories"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-table-productcategories.sql $podname:/tmp/create-table-productcategories.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-table-productcategories.sql

# Populate table ProductCategories
echo "Populate table ProductCategories"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./ProductCategories.csv $podname:/tmp/ProductCategories.csv
oc cp ./populate-table-productcategories-linux.sql $podname:/tmp/populate-table-productcategories.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/populate-table-productcategories.sql

# Create table Products
echo "Create table Products"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-table-products.sql $podname:/tmp/create-table-products.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-table-products.sql

# Populate table Products
echo "Populate table Products"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./Products.csv $podname:/tmp/Products.csv
oc cp ./populate-table-products-linux.sql $podname:/tmp/populate-table-products.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/populate-table-products.sql

# Create table ShoppingCart
echo "Create table ShoppingCart"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-table-shoppingcart.sql $podname:/tmp/create-table-shoppingcart.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-table-shoppingcart.sql

# Create table ShoppingCartItem
echo "Create table ShoppingCartItem"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-table-shoppingcartitem.sql $podname:/tmp/create-table-shoppingcartitem.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-table-shoppingcartitem.sql

# Create view vwProducts
echo "Create view vwProducts"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-view-vwproducts.sql $podname:/tmp/create-view-vwproducts.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-view-vwproducts.sql

# Create view vwShoppingCart
echo "Create view vwShoppingCart"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-view-vwshoppingcart.sql $podname:/tmp/create-view-vwshoppingcart.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-view-vwshoppingcart.sql

# Create view vwShoppingCartItems
echo "Create view vwShoppingCartItems"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-view-vwshoppingcartitems.sql $podname:/tmp/create-view-vwshoppingcartitems.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-view-vwshoppingcartitems.sql

# Create sproc CalculateCartTotal
echo "Create sproc CalculateCartTotal"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-calculatecarttotal.sql $podname:/tmp/create-sproc-calculatecarttotal.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-calculatecarttotal.sql

# Create sproc AddToCart
echo "Create sproc AddToCart"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-addtocart.sql $podname:/tmp/create-sproc-addtocart.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-addtocart.sql

# Create sproc CreateShoppingCart
echo "Create sproc CreateShoppingCart"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-createshoppingcart.sql $podname:/tmp/create-sproc-createshoppingcart.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-createshoppingcart.sql

# Create sproc GetProductsByCategoryId
echo "Create sproc GetProductsByCategoryId"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-getproductsbycategoryid.sql $podname:/tmp/create-sproc-getproductsbycategoryid.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-getproductsbycategoryid.sql

# Create sproc GetProductsBySearch
echo "Create sproc GetProductsBySearch"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-getproductsbysearch.sql $podname:/tmp/create-sproc-getproductsbysearch.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-getproductsbysearch.sql

# Create sproc GetShoppingCart
echo "Create sproc GetShoppingCart"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-getshoppingcart.sql $podname:/tmp/create-sproc-getshoppingcart.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-getshoppingcart.sql

# Create sproc GetShoppingCartItems
echo "Create sproc GetShoppingCartItems"
echo "    Copying command..."
echo "    Executing command..."
oc cp ./create-sproc-getshoppingcartitems.sql $podname:/tmp/create-sproc-getshoppingcartitems.sql
oc exec $podname -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sapassword -i /tmp/create-sproc-getshoppingcartitems.sql

echo "Your CandieDB database is up and ready to go."