#!/bin/bash

us=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
file=$(echo $0 | cut -d "." -f1)
log=/tmp/$file-$timestamp.log

if [ us -ne 0 ]
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

dnf install nginx -y
val $? "installing"

systemctl enable nginx

systemctl start nginx
val $? "starting and enabling"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
val $? "removing and taking"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip
val $? "extarcting and unzipping"

cp /home/ec2-user/bash-practice1/fe.conf /etc/nginx/default.d/fe.conf
val $? "copying"

systemctl restart nginx
val $? "restarting"
