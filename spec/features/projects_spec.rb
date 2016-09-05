require 'rails_helper'

describe "Projects" do

  before(:each) do
    sign_in user
  end

  let(:user)  { create :user, :with_team_and_is_admin, email: 'user@example.com', password: 'password' }

  describe "list projects" do

    before do
      create :project,  name: 'Test Project',
                        users: [user],
                        teams: [user.teams.first]
      create :project,  name: 'Archived Project',
                        users: [user],
                        teams: [user.teams.first],
                        archived_at: Time.current
    end

    it "shows the project list", js: true do
      visit projects_path

      expect(page).to have_selector('#title_bar', text: 'New Project')

      within('#projects') do
        click_on 'Test Project'
      end

      expect(page).not_to have_selector('h1', text: 'Archived Project')
    end

  end

  describe "create project" do

    it "creates a project", js: true do
      visit projects_path
      click_on 'New Project'

      fill_in 'Name', with: 'New Project'
      click_on 'Create Project'

      expect(current_path).to eq(project_path(Project.find_by_name('New Project')))
    end

  end

  describe "edit project" do

    let(:project) {
      create :project,  name: 'Test Project',
                        users: [user],
                        teams: [user.teams.first]
    }

    before do
      project
    end

    it "edits a project" do
      visit projects_path
      within('#projects') do
        click_on 'Edit'
      end

      fill_in 'Name', with: 'New Project Name'
      click_on 'Update Project'

      expect(current_path).to eq(project_path(project))
    end

    it "shows form errors" do
      visit projects_path
      within('#projects') do
        click_on 'Edit'
      end

      fill_in 'Name', with: ''
      click_on 'Update Project'

      expect(page).to have_content("Name can't be blank")
    end
  end

  describe "delete project" do

    let(:project) {
      create :project,  name: 'Test Project',
                        users: [user],
                        teams: [user.teams.first]
    }

    before do
      project
    end

    it "deletes a project" do
      visit edit_project_path(project)
      click_on 'Delete'

      expect(Project.count).to eq(0)
    end
  end

end
