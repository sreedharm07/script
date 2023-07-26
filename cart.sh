log = /tmp/roboshop.log

echo -e "\e[34m >>>>>>coping service file <<<<<<<\e[0m"
cp cart.service /etc/systemd/system/cart.service  &>> $log

echo -e "\e[34m >>>>>>settingup repos<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>> $log

echo -e "\e[34m >>>>>>installing nodejs<<<<<<<\e[0m"
yum install nodejs -y   &>> $log

echo -e "\e[34m >>>>>>creating repo<<<<<<<\e[0m"
useradd roboshop  &>> $log
rm -rf /app  &>> $log
mkdir /app  &>> $log

echo -e "\e[34m >>>>>>downloading app<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip  &>> $log
cd /app  &>> $log

echo -e "\e[34m >>>>>>unzip<<<<<<<\e[0m"
unzip /tmp/cart.zip  &>> $log
cd /app  &>> $log

echo -e "\e[34m >>>>>>installing dependencies<<<<<<<\e[0m"
npm install  &>> $log

echo -e "\e[34m >>>>>>systemctl starts<<<<<<<\e[0m"
systemctl daemon-reload  &>> $log
systemctl enable cart  &>> $log
systemctl start cart  &>> $log