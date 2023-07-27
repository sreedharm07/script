log=/tmp/roboshop.log

function_nodejs() {

echo -e "\e[32m>>>>>>copying the service an repos <<<<<<<<\e[0m"

cp ${component}.service /etc/systemd/system/${component}.service   &>>$log
echo -e "\e[34m $? \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>nodejs settingup <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$log
 echo -e "\e[34m $? \e[0m"

echo -e "\e[32m>>>>>>installing nodejs <<<<<<<<\e[0m"
yum install nodejs -y  &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[32m>>>>>>creating user and directory<<<<<<<<\e[0m"
useradd roboshop  &>>$log
echo -e "\e[34m $? \e[0m"
rm -rf /app  &>>$log
echo -e "\e[34m $? \e[0m"
mkdir /app  &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[32m>>>>>>downloading the app<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>$log
echo -e "\e[34m $? \e[0m"
cd /app

echo -e "\e[32m>>>>>>unzipping<<<<<<<<\e[0m"
unzip /tmp/${component}.zip  &>>$log
echo -e "\e[34m $? \e[0m"
cd /app
npm install  &>>$log
echo -e "\e[34m $? \e[0m"

function_schema
function_systemd
}
#----------------------------------------------------------------------------------------------
function_schema() {
  if  [ "${schema_type}" == "mongodb" ]; then
  echo -e "\e[32m>>>>>>installing mongo<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y  &>>$log
  echo -e "\e[34m $? \e[0m"

  echo -e "\e[32m>>>>>>setting schema<<<<<<<<\e[0m"
  mongo --host mongodb.cloudev7.online </app/schema/${component}.js  &>>$log
  echo -e "\e[34m $? \e[0m"
  fi

  if [ "${schema_type}" == "mysql" ]; then

  echo -e "\e[36m <<<<<<<<installing mysql<<<<<<<<<<\e[0m"
  yum install mysql -y  &>>$log
  echo -e "\e[34m $? \e[0m"

  echo -e "\e[36m>>>>>>>>>>loading schema<<<<<<<\e[0m"
  mysql -h mysql.cloudev7.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$log
  echo -e "\e[34m $? \e[0m"
  fi
}
#-------------------------------------------------------------------------------------------------
function_payment() {


  echo -e "\e[35m >>>>>copying>>>>>>\e[0m"
  cp payment.service /etc/systemd/system/payment.service   &>>$log
  echo -e "\e[34m $? \e[0m"

  echo -e "\e[35m >>>>>installing python>>>>>>\e[0m"
  yum install python36 gcc python3-devel -y  &>>$log
  echo -e "\e[34m $? \e[0m"
  useradd roboshop  &>>$log
  echo -e "\e[34m $? \e[0m"
  rm -rf /app  &>>$log
echo -e "\e[34m $? \e[0m"
  mkdir /app  &>>$log
  echo -e "\e[34m $? \e[0m"

  echo -e "\e[35m >>>>>downloading app>>>>>>\e[0m"
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>$log
  echo -e "\e[34m $? \e[0m"
  cd /app  &>>$log
  echo -e "\e[34m $? \e[0m"

  echo -e "\e[35m >>>>>unzip app>>>>>>\e[0m"
  unzip /tmp/payment.zip  &>>$log
  echo -e "\e[34m $? \e[0m"
  cd /app  &>>$log
  echo -e "\e[34m $? \e[0m"

  echo -e "\e[35m >>>>>dependencies>>>>>>\e[0m"
  pip3.6 install -r requirements.txt  &>>$log
  echo -e "\e[34m $? \e[0m"
  function_systemd
}
#--------------------------------------------------------------------------------------------------
function_systemd () {
   echo -e "\e[35m >>>>> systemctl restarting>>>>>>\e[0m"
    systemctl daemon-reload  &>>$log
    systemctl enable ${component} &>>$log
    systemctl start ${component} &>>$log
}
#----------------------------------------------------------------------------------------------------
function_shipping(){
  echo  -e "\e[36m >>>>>>>>>>copying service file <<<<<<<<<<<\e[0m"
cp shipping.service /etc/systemd/system/shipping.service   &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[36m <<<<<<<<<<<installing maven <<<<<<<<<<<\e[0m"
yum install maven -y  &>>$log
echo -e "\e[34m $? \e[0m"
useradd roboshop  &>>$log
echo -e "\e[34m $? \e[0m"
rm -rf /app  &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[36m>>>>>>>>>>>downloading app <<<<<<<<<<<\e[0m"
mkdir /app  &>>$log
echo -e "\e[34m $? \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>$log
echo -e "\e[34m $? \e[0m"
cd /app  &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[36m>>>>>>>>>unzipping<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip  &>>$log
echo -e "\e[34m $? \e[0m"
cd /app  &>>$log
echo -e "\e[34m $? \e[0m"
mvn clean package  &>>$log
echo -e "\e[34m $? \e[0m"
mv target/shipping-1.0.jar shipping.jar  &>>$log
echo -e "\e[34m $? \e[0m"

function_schema

function_systemd
}
#------------------------------------------------------------------------------------------

function_dispatch() {

echo -e "\e[35m   <<<<<<<<<<<copying service files  >>>>>>>>>>>>>\e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service  &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[35m <<<<<<<<installing go lang   >>>>>>>>>>>\e[0m"
yum install golang -y   &>>$log
echo -e "\e[34m $? \e[0m"
useradd roboshop   &>>$log
echo -e "\e[34m $? \e[0m"
rm -rf /app   &>>$log
echo -e "\e[34m $? \e[0m"
mkdir /app   &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[35m <<<<<<<<<<downloading app >>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip   &>>$log
echo -e "\e[34m $? \e[0m"
cd /app   &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[35m <<<<<<<<<<unzipping >>>>>>>>\e[0m"
unzip /tmp/dispatch.zip   &>>$log
echo -e "\e[34m $? \e[0m"
cd /app   &>>$log
echo -e "\e[34m $? \e[0m"

echo -e "\e[35m <<<<<<<<<dependencied >>>>>>\e[0m"
go mod init dispatch   &>>$log
echo -e "\e[34m $? \e[0m"
go get   &>>$log
echo -e "\e[34m $? \e[0m"
go build   &>>$log
echo -e "\e[34m $? \e[0m"

function_systemd
}