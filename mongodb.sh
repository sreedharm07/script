cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

sed -i 's \127.0.0.1\0.0.0.0\' /etc/mongod.conf
#sed -i 's /127.0.0.1/0.0.0.0/' /etc/mongod/mongo.conf

systemctl restart mongod
