echo -e "\e[33m>>>>>>> copying repos<<<<<<\e [0m"
cp user.service /etc/systemd/system/user.service  &>> /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>> /tmp/roboshop.log

echo -e "\e[33m >>>>>>> setting up repos <<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash   &>> /tmp/roboshop.log
yum install nodejs -y  &>> /tmp/roboshop.log

echo -e "\e[32m>>>>>>>nodejs<<<<<<\e[0m"
useradd roboshop  &>> /tmp/roboshop.log

rm -rf /app &>> /tmp/roboshop.log
mkdir /app  &>> /tmp/roboshop.log

echo -e "\e [32m>>>>>>>downloading app <<<<<< \e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip  &>> /tmp/roboshop.log
cd /app  &>> /tmp/roboshop.log
unzip /tmp/user.zip  &>> /tmp/roboshop.log
cd /app  &>> /tmp/roboshop.log

echo -e "\e [32m>>>>>>>installing dependencies<<<<<< \e[0m"
npm install  &>> /tmp/roboshop.log

echo -e "\e [32m>>>>>>>installing mongodb<<<<<< \e[0m"
yum install mongodb-org-shell -y  &>> /tmp/roboshop.log

echo -e "\e [32m>>>>>>>mongodb schema<<<<<< \e[0m"
mongo --host mongodb.cloudev7.online </app/schema/user.js  &>> /tmp/roboshop.log

echo -e "\e [32m>>>>>>>systemct restart<<<<<< \e[0m"
systemctl daemon-reload  &>> /tmp/roboshop.log
systemctl enable user  &>> /tmp/roboshop.log
systemctl start user