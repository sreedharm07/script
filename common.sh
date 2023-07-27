log=/tmp/roboshop.log

function_status(){
  if  [ $? -eq 0 ] ; then 
  echo -e "\e[32m sucess \e[0m"
  else 
    echo -e "\e[31m failed \e[0m"
  fi
}
function_nodejs() {

echo -e "\e[32m>>>>>>copying the service an repos <<<<<<<<\e[0m"

cp ${component}.service /etc/systemd/system/${component}.service   &>>$log
function_status
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>nodejs settingup <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$log
 function_status

echo -e "\e[32m>>>>>>installing nodejs <<<<<<<<\e[0m"
yum install nodejs -y  &>>$log
function_status

echo -e "\e[32m>>>>>>creating user and directory<<<<<<<<\e[0m"
id roboshop &>>$log
if [$? -ne 0] ; then
useradd roboshop  &>>$log
fi
function_status
rm -rf /app  &>>$log
function_status
mkdir /app  &>>$log
function_status

echo -e "\e[32m>>>>>>downloading the app<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>$log
function_status
cd /app

echo -e "\e[32m>>>>>>unzipping<<<<<<<<\e[0m"
unzip /tmp/${component}.zip  &>>$log
function_status
cd /app
npm install  &>>$log
function_status

function_schema
function_systemd
}
#----------------------------------------------------------------------------------------------
function_schema() {
  if  [ "${schema_type}" == "mongodb" ]; then
  echo -e "\e[32m>>>>>>installing mongo<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y  &>>$log
  function_status

  echo -e "\e[32m>>>>>>setting schema<<<<<<<<\e[0m"
  mongo --host mongodb.cloudev7.online </app/schema/${component}.js  &>>$log
  function_status
  fi

  if [ "${schema_type}" == "mysql" ]; then

  echo -e "\e[36m <<<<<<<<installing mysql<<<<<<<<<<\e[0m"
  yum install mysql -y  &>>$log
  function_status

  echo -e "\e[36m>>>>>>>>>>loading schema<<<<<<<\e[0m"
  mysql -h mysql.cloudev7.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$log
  function_status
  fi
}
#-------------------------------------------------------------------------------------------------
function_payment() {


  echo -e "\e[35m >>>>>copying>>>>>>\e[0m"
  cp payment.service /etc/systemd/system/payment.service   &>>$log
  function_status

  echo -e "\e[35m >>>>>installing python>>>>>>\e[0m"
  yum install python36 gcc python3-devel -y  &>>$log
  function_status
  id roboshop
  if [$? -ne 0]; then
  useradd roboshop  &>>$log
  fi
  function_status
  rm -rf /app  &>>$log
function_status
  mkdir /app  &>>$log
  function_status

  echo -e "\e[35m >>>>>downloading app>>>>>>\e[0m"
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>$log
  function_status
  cd /app  &>>$log
  function_status

  echo -e "\e[35m >>>>>unzip app>>>>>>\e[0m"
  unzip /tmp/payment.zip  &>>$log
  function_status
  cd /app  &>>$log
  function_status

  echo -e "\e[35m >>>>>dependencies>>>>>>\e[0m"
  pip3.6 install -r requirements.txt  &>>$log
  function_status
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
function_status

echo -e "\e[36m <<<<<<<<<<<installing maven <<<<<<<<<<<\e[0m"
yum install maven -y  &>>$log
function_status
useradd roboshop  &>>$log
function_status
rm -rf /app  &>>$log
function_status

echo -e "\e[36m>>>>>>>>>>>downloading app <<<<<<<<<<<\e[0m"
mkdir /app  &>>$log
function_status
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>$log
function_status
cd /app  &>>$log
function_status

echo -e "\e[36m>>>>>>>>>unzipping<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip  &>>$log
function_status
cd /app  &>>$log
function_status
mvn clean package  &>>$log
function_status
mv target/shipping-1.0.jar shipping.jar  &>>$log
function_status

function_schema

function_systemd
}
#------------------------------------------------------------------------------------------

function_dispatch() {

echo -e "\e[35m   <<<<<<<<<<<copying service files  >>>>>>>>>>>>>\e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service  &>>$log
function_status

echo -e "\e[35m <<<<<<<<installing go lang   >>>>>>>>>>>\e[0m"
yum install golang -y   &>>$log
function_status
useradd roboshop   &>>$log
function_status
rm -rf /app   &>>$log
function_status
mkdir /app   &>>$log
function_status

echo -e "\e[35m <<<<<<<<<<downloading app >>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip   &>>$log
function_status
cd /app   &>>$log
function_status

echo -e "\e[35m <<<<<<<<<<unzipping >>>>>>>>\e[0m"
unzip /tmp/dispatch.zip   &>>$log
function_status
cd /app   &>>$log
function_status

echo -e "\e[35m <<<<<<<<<dependencied >>>>>>\e[0m"
go mod init dispatch   &>>$log
function_status
go get   &>>$log
function_status
go build   &>>$log
function_status

function_systemd
}