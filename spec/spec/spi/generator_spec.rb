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

describe Narra::SPI::Generator do
  before(:each) do
    # create item
    @item = FactoryBot.create(:item)
    # create event
    @event = FactoryBot.create(:event, item: @item)
  end

  it 'can be instantiated' do
    expect(Narra::SPI::Generator.new(@item, @event)).to be_an_instance_of(Narra::SPI::Generator)
  end

  it 'should have accessible fields' do
    expect(Narra::SPI::Generator.identifier).to match(:generic)
    expect(Narra::SPI::Generator.title).to match('Generic')
    expect(Narra::SPI::Generator.description).to match('Generic Generator')
  end

  it 'can add metadata to the item' do
    # add meta
    Narra::SPI::Generator.new(@item, @event).add_meta(name: 'test', value: 'test')
    # validation
    expect(@item.meta.count).to match(1)
  end

  it 'can be used to create a new module' do
    expect(Narra::Core.generators).to include(Narra::Generators::Testing)
  end
end