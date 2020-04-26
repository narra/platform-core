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

describe Narra::Item do
  it 'can be instantiated' do
    expect(FactoryBot.build(:item)).to be_an_instance_of(Narra::Item)
  end

  it 'can be saved successfully' do
    expect(FactoryBot.create(:item)).to be_persisted
  end

  it 'should process item to generate new metadata' do
    # create scenario
    @scenario = FactoryBot.create(:scenario_library, author: @author_user, generators: [{identifier:'testing', options:{}}])
    # create library
    @library = FactoryBot.create(:library, author: @author_user, scenario: @scenario, projects: [])
    # create item prepared
    @item_prepared= FactoryBot.create(:item_prepared, library: @library)
    # generate
    @item_prepared.generate
    # validation
    expect(@item_prepared.meta.count).to match(1)
  end
end