usr=$(id -u)
time=$(date +%F-%H-%M-%S)
script=$(echo $0 | cut -d "." -f1)
log=/tmp/$script-$time.log



val(){
    if [ $1 -ne 0 ]
    then    
        echo "$2 failed"
        exit 1
    else
        echo "$2 success"
    fi
}

if [ usr -ne 0 ]
then
    echo "is this sudo"
    exit 1
else
    echo "IN SUDO"
fi


dnf install mysql-server -y
val $? "installing"

systemctl enable mysqld

systemctl start mysqld
val $? "starting and enabling"

mysql -h db.vjeeth.site -uroot -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1
    val $? "passwd creation"
else
    echo "already created skipping"
fi

