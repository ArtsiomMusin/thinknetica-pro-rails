# in spec/support/omniauth_macros.rb
module OmniauthMacros
  def mock_auth_hash(user=nil)
    email = user ? user.email : 'mockuser@test.com'
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => 'mockuser@test.com'
      }
    }
  end
end
