require 'rubygems'
require 'bundler'
require 'dotenv'

Bundler.require
Dotenv.load

require './app'
run SwarmizeApi
