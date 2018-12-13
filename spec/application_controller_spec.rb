require_relative "spec_helper"

def app
  ApplicationController
end

# describe ApplicationController do
#   it "responds with a welcome message" do
#     get '/'
#     expect(last_response.status).to eq(200)
#     expect(last_response.body).to include("Welcome to the Sinatra Template!")
#   end
# end



describe 'User Login' do
  before do
  User.create(name: "Fred", username:"fred0123", password: "password")
  end

  # let!(:valid_user) {}
  
  it "allows a user to login" do
    visit '/' # visit gets DOM structure

    click_link('Log In')
    fill_in("username", :with => "fred0123")
    fill_in("password", :with => "password")
    
    click_on('Log In')
    expect(current_path).to eq('/users/fred0123')
    expect(page).to have_content("Fred")
  end

end
# visit     page     fill_in     check     uncheck     choose     click_link     click_button     click_on

# fill_in("ship_name_1", :with => "Flying Dutchman")

# expect(page).to have_content("Captain Jack Sparrow")

# expect(current_path).to eq('/users/home')

#https://travis-ci.org/