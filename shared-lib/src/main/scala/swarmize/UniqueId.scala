package swarmize

import java.security.SecureRandom

import org.apache.commons.codec.binary.Base64


object UniqueId {
  private val random = new SecureRandom()

  private def generate(numBytes: Int = 16): String = {
    val randomBytes = new Array[Byte](numBytes)
    random.nextBytes(randomBytes)

    Base64.encodeBase64URLSafeString(randomBytes)
  }

  def generateSwarmToken = generate(5)

  def generateSubmissionId = generate(16)
}
