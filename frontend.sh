echo -e "\e[31m>>>>>> copying the config file <<<<<<<<<<\e[0m"
cp nginx.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31 m >>>>>> installing nginx <<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[31 m >>>>>> downloading <<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo -e "\e[31 m >>>>>> unziping <<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[31 m >>>>>> restarting <<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx
systemctl restart nginx
