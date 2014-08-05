package swarmize

import java.security.SecureRandom

import org.apache.commons.codec.binary.Base64


object UniqueId {
  private val random = new SecureRandom()

  def generate: String = {
    val randomBytes = new Array[Byte](16)
    random.nextBytes(randomBytes)

    Base64.encodeBase64URLSafeString(randomBytes)
  }
}
