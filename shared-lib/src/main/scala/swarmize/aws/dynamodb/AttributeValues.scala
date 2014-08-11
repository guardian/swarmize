package swarmize.aws.dynamodb

import java.nio.ByteBuffer

import com.amazonaws.services.dynamodbv2.model.AttributeValue

trait AttributeValues {
  def S(str: String) = new AttributeValue().withS(str)
  def N(number: Long) = new AttributeValue().withN(number.toString)
  def N(number: Double) = new AttributeValue().withN(number.toString)
  def B(bytes: ByteBuffer) = new AttributeValue().withB(bytes)
}

object AttributeValues extends AttributeValues

