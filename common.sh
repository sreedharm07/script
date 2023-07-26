#log=/tmp/roboshop.log

function_nodejs() {

echo -e "\e[32m>>>>>>copying the service an repos <<<<<<<<\e[0m"

cp ${component}.service /etc/systemd/system/${component}.service   #&>>$log
#echo $?
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>nodejs settingup <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  #&>>$log
 #echo $?

echo -e "\e[32m>>>>>>installing nodejs <<<<<<<<\e[0m"
yum install nodejs -y  #&>>$log
#echo $?

echo -e "\e[32m>>>>>>creating user and directory<<<<<<<<\e[0m"
useradd roboshop  #&>>$log
#echo $?
rm -rf /app  #&>>$log
#echo $?
mkdir /app  #&>>$log
#echo $?

echo -e "\e[32m>>>>>>downloading the app<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  #&>>$log
#echo $?
cd /app

echo -e "\e[32m>>>>>>unzipping<<<<<<<<\e[0m"
unzip /tmp/${component}.zip  #&>>$log
#echo $?
cd /app
npm install  #&>>$log
#echo $?

function_schema
function_systemd
}
#----------------------------------------------------------------------------------------------
function_schema() {
  if  [ "${schema_type}" == "mongodb" ]; then
  echo -e "\e[32m>>>>>>installing mongo<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y  #&>>$log
  #echo $?

  echo -e "\e[32m>>>>>>setting schema<<<<<<<<\e[0m"
  mongo --host mongodb.cloudev7.online </app/schema/${component}.js  #&>>$log
  #echo $?
  fi

  if [ "${schema_type}" == "mysql" ]; then

  echo -e "\e[36m <<<<<<<<installing mysql<<<<<<<<<<\e[0m"
  yum install mysql -y  #&>>$log
  #echo $?

  echo -e "\e[36m>>>>>>>>>>loading schema<<<<<<<\e[0m"
  mysql -h mysql.cloudev7.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  #&>>$log
  #echo $?
  fi
}
#-------------------------------------------------------------------------------------------------
function_payment() {


  echo -e "\e[35m >>>>>copying>>>>>>\e[0m"
  cp payment.service /etc/systemd/system/payment.service   #&>>$log
  #echo $?

  echo -e "\e[35m >>>>>installing python>>>>>>\e[0m"
  yum install python36 gcc python3-devel -y  #&>>$log
  #echo $?
  useradd roboshop  #&>>$log
  #echo $?
  rm -rf /app  #&>>$log
#echo $?
  mkdir /app  #&>>$log
  #echo $?

  echo -e "\e[35m >>>>>downloading app>>>>>>\e[0m"
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  #&>>$log
  #echo $?
  cd /app  #&>>$log
  #echo $?

  echo -e "\e[35m >>>>>unzip app>>>>>>\e[0m"
  unzip /tmp/payment.zip  #&>>$log
  #echo $?
  cd /app  #&>>$log
  #echo $?

  echo -e "\e[35m >>>>>dependencies>>>>>>\e[0m"
  pip3.6 install -r requirements.txt  #&>>$log
  #echo $?
  function_systemd
}
#--------------------------------------------------------------------------------------------------
function_systemd () {
   echo -e "\e[35m >>>>> systemctl restarting>>>>>>\e[0m"
    systemctl daemon-reload  #&>>$log
    systemctl enable {component} #&>>$log
    systemctl start {component} #&>>$log
}
#----------------------------------------------------------------------------------------------------
function_shipping(){
  echo  -e "\e[36m >>>>>>>>>>copying service file <<<<<<<<<<<\e[0m"
cp shipping.service /etc/systemd/system/shipping.service   #&>>$log
#echo $?

echo -e "\e[36m <<<<<<<<<<<installing maven <<<<<<<<<<<\e[0m"
yum install maven -y  #&>>$log
#echo $?
useradd roboshop  #&>>$log
#echo $?
rm -rf /app  #&>>$log
#echo $?

echo -e "\e[36m>>>>>>>>>>>downloading app <<<<<<<<<<<\e[0m"
mkdir /app  #&>>$log
#echo $?
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  #&>>$log
#echo $?
cd /app  #&>>$log
#echo $?

echo -e "\e[36m>>>>>>>>>unzipping<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip  #&>>$log
#echo $?
cd /app  #&>>$log
#echo $?
mvn clean package  #&>>$log
#echo $?
mv target/shipping-1.0.jar shipping.jar  #&>>$log
#echo $?

function_schema

function_systemd
}
#------------------------------------------------------------------------------------------

function_dispatch() {

echo -e "\e[35m   <<<<<<<<<<<copying service files  >>>>>>>>>>>>>\e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service  #&>>$log
#echo $?

echo -e "\e[35m <<<<<<<<installing go lang   >>>>>>>>>>>\e[0m"
yum install golang -y   #&>>$log
#echo $?
useradd roboshop   #&>>$log
#echo $?
rm -rf /app   #&>>$log
#echo $?
mkdir /app   #&>>$log
#echo $?

echo -e "\e[35m <<<<<<<<<<downloading app >>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip   #&>>$log
#echo $?
cd /app   #&>>$log
#echo $?

echo -e "\e[35m <<<<<<<<<<unzipping >>>>>>>>\e[0m"
unzip /tmp/dispatch.zip   #&>>$log
#echo $?
cd /app   #&>>$log
#echo $?

echo -e "\e[35m <<<<<<<<<dependencied >>>>>>\e[0m"
go mod init dispatch   #&>>$log
#echo $?
go get   #&>>$log
#echo $?
go build   #&>>$log
#echo $?

function_systemd
}