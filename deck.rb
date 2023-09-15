require 'squib'
require 'open-uri'
require 'game_icons'

# Open the google sheet
google_sheet_id = "1bTajO_mbHerEMDwGkJEBR-lDXm1hIUlSEe9IwY4hSDo"
sheet_gid = "0"
buffer = URI.open("https://docs.google.com/spreadsheets/d/#{google_sheet_id}/export?format=csv&gid=#{sheet_gid}").read
data = Squib.csv data: buffer

# Squib merges an array of layouts in sequential order.
# For now we're grafting onto economy, but eventually we should make our own.
layouts = ['economy.yml', 'layout.yml']

# Lay out the cards themselves
Squib::Deck.new cards: data['Name'].size, layout: layouts do
  background color: 'white'
  rect layout: 'cut' # cut line as defined by TheGameCrafter
  rect layout: 'safe' # safe zone as defined by TheGameCrafter
  text str: data['Name'], layout: 'title'
  text str: data['Text'], layout: 'description'
  text str: Time.now, layout: 'credits'
  svg layout: data['Type'] # from layout.yml
  save_sheet columns: 4, rows: 4, margin: 0, gap: 0
end
