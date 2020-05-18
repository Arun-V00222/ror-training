class JsonWebToken

  SECRET_KEY = Rails.application.secrets.secret_key_base. to_s

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    begin
      JWT.decode token, SECRET_KEY, true, { algorithm: 'HS256' }
    rescue JWT::ExpiredSignature
      # Handle expired token, e.g. logout user or deny access
    end
  end

end
