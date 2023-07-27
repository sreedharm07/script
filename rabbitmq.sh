curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

yum install rabbitmq-server -y

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

 id roboshop
if [$? -ne 0 ] ; then
rabbitmqctl add_user roboshop roboshop123
fi
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
