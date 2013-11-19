Etsy.protocol = "https"
Etsy.environment = :production
Etsy.api_key = App::CONFIG["etsy"]["key"]
Etsy.api_secret = App::CONFIG["etsy"]["secret"]
authenticated_user = User.first(:authenticated => true)
Etsy.myself(authenticated_user.oauth_token, authenticated_user.oauth_token_secret) if authenticated_user