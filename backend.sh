#!/bin/bash
us=$(id -u)
time=$(date +%F-%H-%M-%S)
file=$(echo $0 | cut -d "." -f1)
log=/tmp/$file-$time.log

if[ us -ne 0 ]
then
    echo "is this sudo"
    exit 1
else
    echo "IN SUDO"
fi

val(){
    if [ $1 -ne 0 ]
    then
        echo "$2 failed"
    else
        echo "$2 success"
    fi
}

dnf module list nodejs -y
val $? "listing"

dnf module disable nodejs:18 -y

dnf module enable nodejs:20 -y
val $? "enabling and disabling"

dnf install nodejs -y
val $? "installing"

id expense
if [ $? -ne 0 ]
then
    useradd expense
    val $? "adding user"
else
    echo "already added"
fi

mkdir -p /app
val $? "dir created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
val $? "code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
val $? "unzipping"

cd /app
npm install
val $? "installing"

cp /home/ec2-user/bash-practice/backend.service /etc/systemd/system/backend.service
val $? "copying"

systemctl daemon-reload
systemctl start backend
systemctl enable backend
val $? "starting and enabling"

dnf install mysql -y
val $? "installing"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql
val $? "schema"

systemctl restart backend
val $? "restarting"
