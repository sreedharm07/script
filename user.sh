echo -e "\e [32m >>>>>>> copying repos<<<<<< [0m"
cp user.service /etc/systemd/system/user.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e [32m >>>>>>>setting up repos<<<<<< [0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

echo -e "\e [32m >>>>>>>nodejs<<<<<< [0m"
useradd roboshop

rm -rf /app
mkdir /app

echo -e "\e [32m >>>>>>>downloading app <<<<<< [0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app

echo -e "\e [32m >>>>>>>installing dependencies<<<<<< [0m"
npm install

echo -e "\e [32m >>>>>>>installing mongodb<<<<<< [0m"
yum install mongodb-org-shell -y

echo -e "\e [32m >>>>>>>mongodb schema<<<<<< [0m"
mongo --host mongodb.cloudev7.online </app/schema/user.js

echo -e "\e [32m >>>>>>>systemct restart<<<<<< [0m"
systemctl daemon-reload
systemctl enable user
systemctl start user