package swarmize.aws.dynamodb

import com.amazonaws.services.dynamodbv2.model._
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBAsyncClient

import collection.convert.decorateAll._

trait DynamoDBTable extends AttributeValues {
  def client: AmazonDynamoDBAsyncClient
  val tableName: String

  lazy val actualTable = tablePrefix map (prefix => s"$prefix$tableName") getOrElse tableName
  lazy val tablePrefix: Option[String] = None

  def get(key: Map[String, AttributeValue]): Option[Map[String, AttributeValue]] = Option(client.getItem(
    new GetItemRequest().withTableName(actualTable).withKey(key.asJava)).getItem) map (_.asScala.toMap)

  def query(keyConditions: Map[String, Condition], order: Order = Ascending): Seq[Map[String, AttributeValue]] = client.query(
    new QueryRequest().withTableName(actualTable).withKeyConditions(keyConditions.asJava).withScanIndexForward(order.value))
      .getItems.asScala.toSeq map (_.asScala.toMap)

  def scan: Seq[Map[String, AttributeValue]] = client.scan(
    new ScanRequest().withTableName(actualTable))
      .getItems.asScala map (_.asScala.toMap)

  def put(item: Map[String, AttributeValue]): Unit = client.putItem(
    new PutItemRequest().withTableName(actualTable).withItem(item.asJava)
  )

  def putWithoutOverwrite(item: Map[String, AttributeValue]): Unit = client.putItem(
    new PutItemRequest()
      .withTableName(actualTable)
      .withItem(item.asJava)
      .withExpected(
        item.mapValues(_ => new ExpectedAttributeValue().withExists(false)).asJava
      )
  )


  def delete(key: Map[String, AttributeValue]): Unit = client.deleteItem(
    new DeleteItemRequest().withTableName(actualTable).withKey(key.asJava)
  )
}

sealed trait Order {  def value: Boolean }
case object Ascending extends Order { val value = true }
case object Descending extends Order { val value = false }
