json.success do
  json.message "Profile updated"
  json.user     @user
  json.profile  @user.profile
end
