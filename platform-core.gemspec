#
# Copyright (C) 2020 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "narra/core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "narra-core"
  spec.version     = Narra::Core::VERSION
  spec.authors     = ["Michal Mocnak", "Eric Rosenzveig", "Krystof Pesek", "Petr Pulc"]
  spec.email       = ["info@narra.eu"]
  spec.homepage    = "https://www.narra.eu"
  spec.summary     = "NARRA Platform Core functionality"
  spec.description = "NARRA Platform Core functionality which covers all the NARRA data model, logic and SPI."
  spec.license     = "GPL-3.0"
  spec.metadata    = { "narra" => "module" }

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", "~> 5.2.4.2"
  spec.add_dependency "mongoid"
  spec.add_dependency "aasm"
  spec.add_dependency "sidekiq"
  spec.add_dependency "sidekiq-scheduler"
  spec.add_dependency "redis-namespace"
  spec.add_dependency "activesupport"
  spec.add_dependency "fog-aws"
  spec.add_dependency "mime-types"
  spec.add_dependency "wisper"
  spec.add_dependency "sinatra"
  spec.add_dependency "streamio-ffmpeg"
  spec.add_dependency "logger-better"
  spec.add_dependency "timecode"
  spec.add_dependency "carrierwave-mongoid"
  spec.add_dependency "carrierwave-video"
  spec.add_dependency "mini_magick"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "mongoid-tree"
  spec.add_development_dependency "mongoid-rspec"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "database_cleaner"
end
