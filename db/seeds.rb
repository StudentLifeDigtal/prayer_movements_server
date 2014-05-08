user = User.create! email: 'user@example.com', \
                    password: '12345678', \
                    password_confirmation: '12345678'

app = Doorkeeper::Application.create! \
  name: 'Default',
  redirect_uri: 'http://www.prymv.com/callback'

puts 'Application: PRYMV'
puts "name: #{app.name}"
puts "redirect_uri: #{app.redirect_uri}"
puts "uid: #{app.uid}"
puts "secret: #{app.secret}"

access_token = Doorkeeper::AccessToken.create!(application_id: app.id,
                                               resource_owner_id: user.id)

puts "access_token: #{access_token.token}"
