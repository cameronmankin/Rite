require 'squib'
require 'open-uri'
require 'game_icons'

# Open the google sheet
google_sheet_id = "1bTajO_mbHerEMDwGkJEBR-lDXm1hIUlSEe9IwY4hSDo"
sheet_gid = "485063015"
buffer = URI.open("https://docs.google.com/spreadsheets/d/#{google_sheet_id}/export?format=csv&gid=#{sheet_gid}").read
data = Squib.csv data: buffer

# Use 'map' operation to convert array of icon names to array of svgs
illustrations = data['Icon'].map { |iconName| GameIcons.get(iconName).file }

# Lay out the cards themselves
Squib::Deck.new cards: data['Name'].size, layout: 'layouts/basiclayout.yml' do
  background color: 'white'
  rect layout: 'cut' # cut line as defined by TheGameCrafter
  rect layout: 'safe' # safe zone as defined by TheGameCrafter
  text str: data['Name'], layout: 'title'
  text str: data['Cost'], layout: 'upper_right'
  text str: data['Type'], layout: 'type'
  text str: data['Subtype'], layout: 'subtype'
  text str: data['Text'], layout: 'description'
  text str: data['Power'], layout: 'lower_left'
  text str: data['Insight'], layout: 'lower_center'
  text str: data['Toughness'], layout: 'lower_right'
  text str: Time.now, layout: 'credits'
  svg layout: 'art', file: illustrations # Spreadsheet-defined icons
  save_sheet columns: 4, rows: 4, margin: 0, gap: 0
end