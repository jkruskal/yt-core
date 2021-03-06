require 'spec_helper'

describe 'Yt::PlaylistItem#select', :server do
  subject(:subject) { Yt::PlaylistItem.new attrs }

  context 'given an existing item ID' do
    let(:attrs) { {id: $existing_item_id} }

    specify 'lets multiple data parts be fetched with one HTTP call', requests: 1 do
      item = subject.select :snippet, :status

      expect(item.id).to be
      expect(item.title).to be
      expect(item.privacy_status).to be
    end
  end
end
