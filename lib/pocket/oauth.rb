module Pocket
  # Defines HTTP request methods
  module OAuth
    # Return URL for OAuth authorization
    def authorize_url(options={})
      params = access_token_params.merge(options)
      # Pocket renames `code` to `request_token` for some reason in this call
      params[:request_token] = params[:code]
      connection.build_url("/auth/authorize", params).to_s
    end

    # Return a Pocket code
    def get_code(options={})
      params = access_token_params.merge(options)
      response = connection.post 'oauth/request', params
      results = Hash[URI.decode_www_form(response.body)]
      code = results['code']
    end

    # Return an access token from authorization
    def get_access_token(code, options={})
      results = authorize_request(code, options)
      access_token = results['access_token']
    end

    def get_access_token_and_username(code, options={})
      return authorize_request(code, options)
    end

    private

    def access_token_params
      {
        :consumer_key => consumer_key
      }
    end

    def authorize_request(code, options)
      params = access_token_params.merge(:code => code).merge(options)
      response = connection.post 'oauth/authorize', params
      return Hash[URI.decode_www_form(response.body)]
    end
  end
end

