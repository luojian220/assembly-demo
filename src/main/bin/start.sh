#!/bin/bash
source /etc/profile

cd `dirname $0`
BIN_DIR=`pwd`
echo "bin:"$BIN_DIR

cd ..
#spring-boot
DEPLOY_DIR=`pwd`
echo "deploy:"$DEPLOY_DIR


#jar
JAR=`find -name *.jar`
echo "jar:"$JAR

#appName
APP_NAME=`echo ${JAR%-*} |awk -F "/" '{print $NF}'`
echo "app:"$APP_NAME

# 防止重复启动
COUNT=`ps -ef|grep $JAR |grep -v grep | wc -l`
PIDS=`ps -ef | grep java | grep $DEPLOY_DIR |awk '{print $2}'`
if [ $COUNT -gt 0 ]; then
	echo "ERROR: $APP_NAME already started!"
	echo "PID: $PIDS"
	exit 1
fi

#log
LOG_DIR=$DEPLOY_DIR/logs
echo "log:"$LOG_DIR
#log
LOG_FILE=$LOG_DIR/catalina.out

if [ ! -d logs  ];then
  mkdir logs
fi

#JVM参数
#JVM_OPTS="-Xmx250m -Xms512g -Xmn256m -Xss256k -XX:MaxMetaspaceSize=4g -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"


JVM_OPTS="-Xmx512m -Xms256m -Xmn256m -Xss256k "
echo "jvm:"$JVM_OPTS

START_OPTS="-Dspring.config.location=classpath:/,classpath:/config/,file:./,file:./config/,$DEPLOY_DIR/properties/"

#启动变量
#START_VAR="--spring.datasource.password=tour1234 --server.port=8099"

echo "start:"$START_OPTS

echo "Start $APP_NAME begin"
nohup java -jar  $JVM_OPTS $START_OPTS $JAR $START_VAR >> $LOG_FILE 2>&1  &
#nohup java -jar $JVM_OPTS $START_OPTS $JAR $START_VAR >> /dev/null 2>&1  &
#check
COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    COUNT=`ps -ef|grep $JAR |grep -v grep | wc -l`
    if [ $COUNT -gt 0 ]; then
        break
    fi
done
echo -e "\n Start $APP_NAME ok"
#!/bin/bash
