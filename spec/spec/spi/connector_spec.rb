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

require 'rails_helper'

describe Narra::SPI::Connector do
  before(:each) do
    # test url
    @url = 'http://test'
  end

  it 'can be instantiated' do
    expect(Narra::SPI::Connector.new(@url)).to be_an_instance_of(Narra::SPI::Connector)
  end

  it 'should have accessible fields' do
    expect(Narra::SPI::Connector.identifier).to match(:generic)
    expect(Narra::SPI::Connector.title).to match('Generic')
    expect(Narra::SPI::Connector.description).to match('Generic Connector')
  end
end