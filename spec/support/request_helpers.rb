module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_authorization_header(token)
      request.headers['Authorization'] = token
    end

    def omniauth_headers(attributes)
      OmniAuth.config.add_mock(:facebook, attributes)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    def omniauth_mock_attributes(user)
      {
        provider: 'facebok',
        uid: user.uid,
        info: {
          email: user.email,
          name: user.name
        }
      }
    end
  end
end
