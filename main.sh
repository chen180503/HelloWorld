#!/bin/sh
## 提交做作业

# 变量初始化部分
# 项目根目录
rootDir=`dirname $0`
cd ${rootDir}/../
rootDir=`pwd`
# submit提交文件位置
submitPath=/opt/app/spark/bin/spark-submit
# hadoop可执行文件
hadoopPath=/opt/app/hadoop/bin/hadoop
# maven文件库
mavenRepPath=/opt/app/maven3/repository # 内网测试机
# hbase根目录
hbaseHome=/opt/app/hbase
# php命令
phpBin="/opt/app/php5/bin/php -c /opt/app/php5/etc/cron.ini"

logFile=${rootDir}/../logs/spark-main.log
rm -fr ${logFile}

mysqlJar=${mavenRepPath}/mysql/mysql-connector-java/6.0.6/mysql-connector-java-6.0.6.jar
# 额外的jar包
submitJars=${mavenRepPath}/org/nlpcn/nlp-lang/1.7.2/nlp-lang-1.7.2.jar,${rootDir}/lib/ansj_seg-5.1.3.jar
submitJars=${submitJars},${mysqlJar},${mavenRepPath}/redis/clients/jedis/2.9.0/jedis-2.9.0.jar
submitJars=${submitJars},${mavenRepPath}/org/apache/commons/commons-pool2/2.4.2/commons-pool2-2.4.2.jar
for jar in `ls ${hbaseHome}/lib/*.jar`;
do
    submitJars=${submitJars},${jar}
done

#${hadoopPath} fs -mkdir -p /guess.union2.50bang.org/ansj/
#${hadoopPath} fs -put -f ${rootDir}/cache/dictSet.txt /guess.union2.50bang.org/ansj/dictSet.txt


# 提交作业
${submitPath} \
    --master spark://hdfs-master:7077 \
#    --driver-class-path ${hbaseHome}/conf/:${mysqlJar} \
    --executor-memory 0.5g \
    --executor-cores 1 \
    --total-executor-cores 1 \
    --class org.wlbang.Hello \
#    --jars ${submitJars} \
    ${rootDir}/target/com.wlbang-1.0.jar >> ${logFile} 2>&1
