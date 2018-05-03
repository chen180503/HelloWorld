import org.apache.spark.{SparkConf, SparkContext}
import org.apache.log4j.Logger

object Hello {
  def main(args: Array[String]): Unit = {
    //只显示错误日志
    Logger.getLogger("org").setLevel(org.apache.log4j.Level.ERROR)
    //set master 本机使用local 远程写ip;打包的时候去掉 setMaster 因为会在参数中指定
    val conf = new SparkConf().setAppName("Hello")
      conf.setMaster("local")
//      conf.setMaster("spark://172.17.20.231:7077")
    val sc = new SparkContext(conf)
    val rdd = sc.parallelize(List(1, 2, 3, 4, 5, 6)).map(_ * 3)
    //求和
    println(rdd.reduce(_ + _))
    val mappedRdd = rdd.filter(_ > 10).collect()
    //数据大于10的元素
    for (arg <- mappedRdd)
      print(arg + "\n")
    println()
    println("math is work")
  }
}
