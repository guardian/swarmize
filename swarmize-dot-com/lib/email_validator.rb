class EmailValidator
  def self.is_valid_email?(email)
    email = email.downcase
    (email == 'tom@infovore.org') || (email =~ /@theguardian\.com$/) || (email =~ /@guardian\.co\.uk$/)
  end

  def self.normalize_email(email)
    email.downcase.gsub('theguardian.com', 'guardian.co.uk')
  end
end
