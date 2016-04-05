#!/bin/bash
# Shell script to run sql files from command line.
# Pre-Req: sqlplus client shall be installed already.
###########################################################
# Variables Section (DB Details)
###########################################################
DB_HostName="127.0.0.1"
DB_Port="1521"
DB_SID="xe"
DB_UserName="system"
DB_Password="oracle"
DIR_SqlFiles="/tmp/sqlscripts"

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
/usr/sbin/startup.sh
##########################################################
# All Script Functions Goes Here
##########################################################
db_statuscheck() {
echo "`date` :Checking DB connectivity...";
echo "`date` :Trying to connect "${DB_UserName}"/"${DB_Password}"@"${DB_SID}" ..."
echo "exit" | /u01/app/oracle/product/11.2.0/xe/bin/sqlplus "${DB_UserName}/${DB_Password}@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HostName})(PORT=${DB_Port})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${DB_SID})))" | grep -q "Connected to:" > /dev/null
if [ $? -eq 0 ]
then
DB_STATUS="UP"
export DB_STATUS
echo "`date` :Status: ${DB_STATUS}. Able to Connect..."
else
DB_STATUS="DOWN"
export DB_STATUS
echo "`date` :Status: DOWN . Not able to Connect."
echo "`date` :Not able to connect to database with Username: "${DB_UserName}" Password: "${DB_Password}" DB HostName: "${DB_HostName}" DB Port: "${DB_Port}" SID: "${DB_SID}"."
echo "`date` :Exiting Script Run..."
exit
fi
}

runsqls() {
echo "`date` :Checking DB status..."
db_statuscheck
if [[ "$DB_STATUS" == "DOWN" ]] ; then
echo "`date` :DB status check failed..."
echo "`date` :Skipping to run extra sqls and exiting..."
exit
fi
echo "`date` :DB status check completed"
echo "`date` :Connecting To ${DB_UserName}/******@${DB_SID}";
if [[ "$DB_STATUS" == "UP" ]] ; then
for file in `dir -d $DIR_SqlFiles/*` ; do
#for file in `cat extrasqlslist.txt` ;do
echo "`date` :Executing file $file..."
echo "`date` :__________________________________________";
echo "`date` :SQL OUTPUT:";
echo "`date` :__________________________________________";
 /u01/app/oracle/product/11.2.0/xe/bin/sqlplus -s ""${DB_UserName}"/"${DB_Password}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}")))" <<EOF
@$file;
commit;
quit;
echo "`date` :__________________________________________";
EOF
done
echo "`date` :completed running all extra sqls to create DM violations table"
else
echo "`date` :Either the DB is down or the exit status returned by script shows ERROR."
echo "`date` :Exiting ..."
exit
fi

}

Main() {
echo "`date` :Starting Sql auto run script."
runsqls
echo "`date` :Sql auto run script execution completed."
}

Main | tee autosql.log

 /usr/sbin/sshd -D