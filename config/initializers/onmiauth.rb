Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user:email,user:follow"
  provider :github, 'e9f2f855529bdd3eb56b', '46904dcdc3d16c548e567529456a34ed755a6f3a', scope: "user:email,gist"
end