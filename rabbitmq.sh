source common.sh
log = /tmp/roboshop.log

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>log
function_status
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>log
function_status

yum install rabbitmq-server -y  &>>log
function_status

systemctl enable rabbitmq-server  &>>log
function_status
systemctl start rabbitmq-server  &>>log
function_status

 id roboshop  &>>log
if [$? -ne 0 ] ; then
rabbitmqctl add_user roboshop roboshop123  &>>log
fi
function_status
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>log
function_status
