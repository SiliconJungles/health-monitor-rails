require 'spec_helper'

describe 'Doctor Strange' do
  context 'when check is ok' do
    it 'renders html' do
      visit '/check'
      expect(page).to have_css('td', text: 'Database')
      expect(page).to have_css('td', class: 'text-success', text: 'OK')
    end
  end

  context 'when check failed' do
    before do
      Providers.stub_database_failure
    end
    it 'renders html' do
      visit '/check'
      expect(page).to have_css('td', text: 'Database')
      expect(page).to have_css('td', class: 'text-danger', text: 'ERROR')
      expect(page).to have_css('td', class: 'text-danger', text: 'Your database is not connected')
    end
  end
end
