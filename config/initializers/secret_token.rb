# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

# Rails 4 
# require 'securerandom'

# def secure_token
#    token_file = Rails.root.join('.secret')
#    if File.exist?(token_file)
#      #  Use the existing token.
#      File.read(token_file).chomp
#    else
#    #  Generate a new token and store it in token_file.
#      token = SecureRandom.hex(64)
#      File.write(token_file, token)
#      token
#    end
#  end

#  SampleApp::Application.config.secret_key_base = secure_token

SampleApp::Application.config.secret_token = '809a314ad0686195918e47398a4d3734be072a044aaa7adaec38a984b80cc619e410a37c6ecc57eac1c52c7d1850ca324a7a9ad06f57f4ec8e8c37b6100d7904'
