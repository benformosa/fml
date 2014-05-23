module FmlHelpers
  def login(login, password)
    visit new_user_session_path
    if has_link? 'Log out'
      click_link 'Log out'
    end
    visit new_user_session_path
    expect(page).to have_content 'Sign in'
    fill_in 'Login', :with => login
    fill_in 'Password', :with => password
    click_button 'Sign in'
    expect(page).to have_content 'Signed in'
  end

  def create_car(name, make, model, rego, state, odo)
    login('fm.manager', 'fm.manager')
    visit cars_path
    click_link 'new car'
    expect(page).to have_content 'Add new car'
    fill_in 'Name', :with => name
    fill_in 'Make', :with => make
    fill_in 'Model', :with => model
    fill_in 'Rego', :with => rego
    fill_in 'State', :with => state
    fill_in 'Odometer', :with => odo
    click_button 'Create Car'
    visit cars_path
    expect(page).to have_content name
    click_link 'Log out'
  end
end
