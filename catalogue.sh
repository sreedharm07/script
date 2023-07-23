cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install

yum install mongodb-org-shell -y
mongo --host mongodb.cloudev7.online </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue


