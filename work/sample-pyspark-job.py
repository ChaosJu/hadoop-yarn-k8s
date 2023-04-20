from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

df = spark.read.text("hdfs:///hello.txt")

df.show()
