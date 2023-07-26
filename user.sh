echo -e "\e [32m >>>>>>> copying repos<<<<<<\e[0m"
cp user.service /etc/systemd/system/user.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e [32m >>>>>>>setting up repos<<<<<< \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

echo -e "\e [32m >>>>>>>nodejs<<<<<< \e[0m"
useradd roboshop

rm -rf /app
mkdir /app

echo -e "\e [32m >>>>>>>downloading app <<<<<< \e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app

echo -e "\e [32m >>>>>>>installing dependencies<<<<<< \e[0m"
npm install

echo -e "\e [32m >>>>>>>installing mongodb<<<<<< \e[0m"
yum install mongodb-org-shell -y

echo -e "\e [32m >>>>>>>mongodb schema<<<<<< \e[0m"
mongo --host mongodb.cloudev7.online </app/schema/user.js

echo -e "\e [32m >>>>>>>systemct restart<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user