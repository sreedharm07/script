echo -e "\e[32m>>>>>>copying the service an repos <<<<<<<<\e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service   &>>/tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>nodejs settingup <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>installing nodejs <<<<<<<<\e[0m"
yum install nodejs -y  &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>creating user and directory<<<<<<<<\e[0m"
useradd roboshop  &>>/tmp/roboshop.log
rm -rf /app  &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>downloading the app<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[32m>>>>>>unzipping<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip  &>>/tmp/roboshop.log
cd /app
npm install  &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>installing mongo<<<<<<<<\e[0m"
yum install mongodb-org-shell -y  &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>setting schema<<<<<<<<\e[0m"
mongo --host mongodb.cloudev7.online </app/schema/catalogue.js  &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>crestarting<<<<<<<<\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable catalogue  &>>/tmp/roboshop.log
systemctl start catalogue  &>>/tmp/roboshop.log


