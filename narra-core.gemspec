# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require_relative "lib/narra/core/version"

Gem::Specification.new do |spec|
  spec.name        = "narra-core"
  spec.version     = Narra::Core::VERSION
  spec.authors       = ["Michal Mocnak", "Eric Rosenzveig"]
  spec.email         = ["michal@narra.eu", "eric@narra.eu"]

  spec.summary     = "Summary of Narra::Core."
  spec.description = "Description of Narra::Core."
  spec.homepage    = "https://github.com/narra"
  spec.license     = "gpl-3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/narra/platform-core"
  spec.metadata["narra"] = "module"

  spec.files = Dir["{app,config,db,lib}/**/*", "COPYING", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.3"
  spec.add_dependency "mongoid", "~> 7.2.1"
  spec.add_dependency "grape", "~> 1.5.3"
  spec.add_dependency "wisper", "~> 2.0.0"
  spec.add_dependency "aasm"
  spec.add_dependency "sidekiq"
  spec.add_dependency "redis-namespace"
  spec.add_dependency "fog-aws"
  spec.add_dependency "mime-types"
  spec.add_dependency "streamio-ffmpeg"
  spec.add_dependency "logger-better"
  spec.add_dependency "carrierwave-mongoid"
  spec.add_dependency "carrierwave-video"
  spec.add_dependency "mini_magick"
  spec.add_dependency "nokogiri"
  spec.add_dependency "deep_cloneable"
end
