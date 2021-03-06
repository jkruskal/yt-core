require 'spec_helper'

describe 'Yt::Playlist#items', :server do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: $existing_playlist_id} }

    it 'returns the list of *public* items of the playlist' do
      expect(playlist.items).to all( be_a Yt::PlaylistItem )
    end

    it 'does not make any HTTP requests unless iterated', requests: 0 do
      playlist.items
    end

    it 'makes as many HTTP requests as the number of items divided by 50', requests: 2 do
      playlist.items.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same', requests: 2 do
      playlist.items.map &:id
      playlist.items.map &:id
    end

    it 'makes a new HTTP request if the request has changed', requests: 4 do
      playlist.items.map &:id
      playlist.items.select(:id, :snippet).map &:title
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      expect{playlist.items}.to change{ObjectSpace.each_object(Yt::Relation).count}
      expect{playlist.items}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::Playlist object, no matter the requests' do
      expect{playlist.items.map &:id}.to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{playlist.items.map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{playlist.items.select(:status).map &:privacy_status}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{playlist.items.limit(4).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls', requests: 2 do
      items = playlist.items.select :snippet, :status
      expect(items.map &:title).to be
      expect(items.map &:privacy_status).to be
    end

    it 'accepts .limit to only fetch some items', requests: 1 do
      expect(playlist.items.select(:snippet).limit(2).count).to be 2
      expect(playlist.items.select(:snippet).limit(2).count).to be 2
    end
  end
end
