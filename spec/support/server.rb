RSpec.configure do |config|
  config.before :all, server: true do
    Yt.configuration.api_key = ENV['YT_SERVER_API_KEY']
    Yt.configuration.client_id = ''
    Yt.configuration.client_secret = ''
  end

  $existing_channel_id   = 'UCwCnUcLcb9-eSrHa_RQGkQQ'
  $another_channel_id    = 'UCxO1tY8h1AhOz0T4ENwmpow'
  $unknown_channel_id    = 'UC-not-a-valid-id-_RQGkQ'
  $terminated_channel_id = 'UCKe_0fJtkT1dYnznt_HaTrA'

  $existing_video_id     = 'gknzFj_0vvY'
  $unknown_video_id      = 'invalid-id-'

  $existing_playlist_id  = 'PL-LeTutc9GRKD3yBDhnRF_yE8UTaQI5Jf'
  $unknown_playlist_id   = 'invalid-id-'

  $existing_item_id      = 'UEwtTGVUdXRjOUdSS0QzeUJEaG5SRl95RThVVGFRSTVKZi4yODlGNEE0NkRGMEEzMEQy'
  $unknown_item_id       = 'invalid-id-'
end