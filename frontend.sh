echo -e "\e[31 m >>>>>> copying the config file <<<<<<<<<<\e[0m"
cp nginx.conf /etc/nginx/default.d/roboshop.conf

echo ">>>>>>installing nginx <<<<<<<<<<"
yum install nginx -y

echo ">>>>>> installing app <<<<<<<<<<"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo ">>>>>> unzip app <<<<<<<<<<"
unzip /tmp/frontend.zip

echo ">>>>>> restarting  <<<<<<<<<<"
systemctl enable nginx
systemctl start nginx
systemctl restart nginx
