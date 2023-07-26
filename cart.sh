echo -e "\e[34m >>>>>>coping service file <<<<<<<\e[0m"
cp cart.service /etc/systemd/system/cart.service  &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>settingup repos<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>installing nodejs<<<<<<<\e[0m"
yum install nodejs -y   &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>creating repo<<<<<<<\e[0m"
useradd roboshop  &>> /tmp/roboshop.log
rm -rf /app  &>> /tmp/roboshop.log
mkdir /app  &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>downloading app<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip  &>> /tmp/roboshop.log
cd /app  &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>unzip<<<<<<<\e[0m"
unzip /tmp/cart.zip  &>> /tmp/roboshop.log
cd /app  &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>installing dependencies<<<<<<<\e[0m"
npm install  &>> /tmp/roboshop.log

echo -e "\e[34m >>>>>>systemctl starts<<<<<<<\e[0m"
systemctl daemon-reload  &>> /tmp/roboshop.log
systemctl enable cart  &>> /tmp/roboshop.log
systemctl start cart  &>> /tmp/roboshop.log