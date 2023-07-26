log=/tmp/roboshop.log

function_nodejs() {

echo -e "\e[32m>>>>>>copying the service an repos <<<<<<<<\e[0m"

cp ${component}.service /etc/systemd/system/${component}.service   &>>$log
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>nodejs settingup <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$log

echo -e "\e[32m>>>>>>installing nodejs <<<<<<<<\e[0m"
yum install nodejs -y  &>>$log

echo -e "\e[32m>>>>>>creating user and directory<<<<<<<<\e[0m"
useradd roboshop  &>>$log
rm -rf /app  &>>$log
mkdir /app  &>>$log

echo -e "\e[32m>>>>>>downloading the app<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>$log
cd /app

echo -e "\e[32m>>>>>>unzipping<<<<<<<<\e[0m"
unzip /tmp/${component}.zip  &>>$log
cd /app
npm install  &>>$log

systemctl enable ${component}

echo -e "\e[32m>>>>>>installing mongo<<<<<<<<\e[0m"
yum install mongodb-org-shell -y  &>>$log

echo -e "\e[32m>>>>>>setting schema<<<<<<<<\e[0m"
mongo --host mongodb.cloudev7.online </app/schema/${component}.js  &>>$log

echo -e "\e[32m>>>>>>crestarting<<<<<<<<\e[0m"
systemctl daemon-reload  &>>$log
systemctl enable ${component}  &>>$log
systemctl start ${component}  &>>$log
}