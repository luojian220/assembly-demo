
#!/bin/bash


#bin
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

#log
LOG_DIR=$DEPLOY_DIR/logs
echo "log:"$LOG_DIR
#log
LOG_FILE=$LOG_DIR/catalina.out


PIDS=`ps -ef | grep java | grep 'jar' | grep $APP_NAME |awk '{print $2}'`
echo "pid:"$PIDS
if [ -z "$PIDS" ]; then
echo "ERROR: The app does not started!"
else
echo "Stop $APP_NAME "
for PID in $PIDS ; do
sudo kill $PID > $LOG_FILE 2>&1
done
echo "stop OK!"
fi


