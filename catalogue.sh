echo -e "\e[32m>>>>>>copying the service an repos <<<<<<<<[0m"

cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>nodejs settingup <<<<<<<<[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>installing nodejs <<<<<<<<[0m"
yum install nodejs -y

echo -e "\e[32m>>>>>>creating user and directory<<<<<<<<[0m"
useradd roboshop
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>downloading the app<<<<<<<<[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[32m>>>>>>unzipping<<<<<<<<[0m"
unzip /tmp/catalogue.zip
cd /app
npm install

echo -e "\e[32m>>>>>>installing mongo<<<<<<<<[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m>>>>>>setting schema<<<<<<<<[0m"
mongo --host mongodb.cloudev7.online </app/schema/catalogue.js

echo -e "\e[32m>>>>>>crestarting<<<<<<<<[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue


