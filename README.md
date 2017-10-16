# Quicksloth Crawler Server
Crawler server for Quicksloth source code recomendation system.

## Prerequisites
Ruby 2.2.6 +

## Setting up the project
After installing ruby, run these commands:

`gem install bundler`

`bundler install`

add your google api key on crawler_controller.rb:

`GoogleCustomSearchApi::GOOGLE_API_KEY = "YOUR API KEY"
   GoogleCustomSearchApi::GOOGLE_SEARCH_CX = "YOUR:CX"`