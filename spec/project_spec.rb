require_relative "spec_helper"

def app
  ApplicationController
end

describe 'projects' do

  before do
    User.create(name: "Fred", username:"fred0123", password: "password")
    visit '/'
    click_link('Log In')
    fill_in("username", :with => "fred0123")
    fill_in("password", :with => "password")
    click_on('Log In')
  end

  it "allows a user to create a project" do
    click_link('New Project')

    expect(current_path).to eq('/users/fred0123/projects/new')
    expect(page).to have_content("New Project")
    fill_in("name", :with => "Tile shower")
    fill_in("cost", :with => "3000")
    fill_in("duration", :with => "30")
    fill_in("new_room", :with => "Bathroom")
    page.choose("Not started")
    fill_in("description", :with => "Need to replace the tiles from 1969")
    fill_in("materials", :with => "Tiles, cement, tiling tools, grout.")
    
    click_on('Create Project')
    expect(current_path).to eq('/users/fred0123/projects/tile-shower')
    expect(page).to have_content("Tile shower")
    expect(page).to have_content("$3000")
    expect(page).to have_content("30 hours")
    expect(page).to have_content("Tile shower")
    expect(page).to have_content("Bathroom")
    expect(page).to have_content("Not started")
    expect(page).to have_content("Need to replace the tiles from 1969")
    expect(page).to have_content("Tiles, cement, tiling tools, grout.")
  end
end