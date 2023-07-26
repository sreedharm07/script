echo -e "\e[32m>>>>>> copying the config file <<<<<<<<<<\e[0m"
cp nginx.conf /etc/nginx/default.d/roboshop.conf  &>>/tmp/roboshop.log

echo -e "\e[32m >>>>>> installing nginx <<<<<<<<<<\e[0m"
yum install nginx -y  &>>/tmp/roboshop.log

echo -e "\e[32m >>>>>> downloading <<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/roboshop.log   &>>/tmp/roboshop.log
cd /usr/share/nginx/html  &>>/tmp/roboshop.log

echo -e "\e[32m >>>>>> unziping <<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip  &>>/tmp/roboshop.log

echo -e "\e[32m >>>>>> restarting <<<<<<<<<<\e[0m"
systemctl enable nginx  &>>/tmp/roboshop.log
systemctl start nginx   &>>/tmp/roboshop.log
systemctl restart nginx