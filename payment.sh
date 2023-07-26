log=/log/roboshop.log

echo -e "\e[35m >>>>>copying>>>>>>\e[0m"
cp payment.service /etc/systemd/system/payment.service   &>>$log

echo -e "\e[35m >>>>>installing python>>>>>>\e[0m"
yum install python36 gcc python3-devel -y  &>>$log
useradd roboshop  &>>$log
rm -rf /app  &>>$log
mkdir /app  &>>$log

echo -e "\e[35m >>>>>downloading app>>>>>>\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>$log
cd /app  &>>$log

echo -e "\e[35m >>>>>unzip app>>>>>>\e[0m"
unzip /tmp/payment.zip  &>>$log
cd /app  &>>$log

echo -e "\e[35m >>>>>dependencies>>>>>>\e[0m"
pip3.6 install -r requirements.txt  &>>$log

echo -e "\e[35m >>>>> systemctl restarting>>>>>>\e[0m"
systemctl daemon-reload  &>>$log
systemctl enable payment  &>>$log
systemctl start payment  &>>$log