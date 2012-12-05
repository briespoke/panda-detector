# Panda Detector

## Description

This program reads tweets by @chairmantruck and uses this information to conditionally activate a switch on the Raspberry Pi's GPIO interface. If @chairmantruck has tweeted "UN Plaza" in the last 19 hours (since @chairmantruck sometimes tweets the night before), GPIO 4 will turn on.

## Usage

Be sure to set GPIO #4 to "out" as follows:

`gpio -g mode 4 out`

Be sure to install the gems:

`bundle install`

Then, invoke chairman.rb as follows:

`bundle exec ruby chairman.rb`

Panda Detector will loop infinitely with 60-second delays, turning GPIO 4 on or off depending on the presence of pandas.