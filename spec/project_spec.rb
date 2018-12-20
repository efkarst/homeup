require_relative "spec_helper"

def app
  ApplicationController
end

describe 'projects' do
  before do
    user = User.create(name: "Fred", username:"fred0123", password: "password")
    project = Project.create(name:"channel board ceiling", room: Room.create(name: "Second bedroom", user: user), cost: 900, duration: 15)
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
    expect(page).to have_content("Bathroom")
    expect(page).to have_content("Not started")
    expect(page).to have_content("Need to replace the tiles from 1969")
    expect(page).to have_content("Tiles, cement, tiling tools, grout.")
  end

  it "allows a user to edit a project" do
    visit '/users/fred0123/projects/channel-board-ceiling/edit'
    expect(current_path).to eq('/users/fred0123/projects/channel-board-ceiling/edit')
    expect(page).to have_content("Edit channel board ceiling")
    fill_in("cost", :with => "1800")
    fill_in("duration", :with => "45")
    page.choose("In progress")
    fill_in("description", :with => "Add a description")
    fill_in("materials", :with => "Add materials")
    click_on('Update Project')
    expect(current_path).to eq('/users/fred0123/projects/channel-board-ceiling')
    expect(page).to have_content("Channel board ceiling")
    expect(page).to have_content("$1800")
    expect(page).to have_content("45 hours")
    expect(page).to have_content("Second bedroom")
    expect(page).to have_content("In progress")
    expect(page).to have_content("Add a description")
    expect(page).to have_content("Add materials")
  end
end

# visit     page     fill_in     check     uncheck     choose     click_link     click_button     click_on
