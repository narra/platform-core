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

describe Narra::SPI::Synthesizer do
  before(:each) do
    # create scenarios
    @scenario_project = FactoryBot.create(:scenario_project, author: @author_user)
    @scenario_library = FactoryBot.create(:scenario_library, author: @author_user)
    # create project
    @project = FactoryBot.create(:project, author: @author_user, scenario: @scenario_project)
    # create library
    @library = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, projects: [@project])
    # create items
    @item0 = FactoryBot.create(:item, library: @library)
    @item1 = FactoryBot.create(:item, library: @library)
    # create event
    @event = FactoryBot.create(:event, project: @project)
  end

  it 'can be instantiated' do
    expect(Narra::SPI::Synthesizer.new(@project, @event)).to be_an_instance_of(Narra::SPI::Synthesizer)
  end

  it 'should have accessible fields' do
    expect(Narra::SPI::Synthesizer.identifier).to match(:generic)
    expect(Narra::SPI::Synthesizer.title).to match('Generic')
    expect(Narra::SPI::Synthesizer.description).to match('Generic Synthesizer')
  end

  it 'can add junction to the project' do
    # add meta
    Narra::SPI::Synthesizer.new(@project, @event).add_junction([@item0, @item1], weight: 1.0, synthesizer: :generic, source: 'test', direction: {none: true})
    # validation
    expect(@project.junctions.count).to match(1)
  end

  it 'can be used to create a new module' do
    expect(Narra::Core.synthesizers).to include(Narra::Synthesizers::Testing)
  end
end