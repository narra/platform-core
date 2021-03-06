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

describe Narra::Project do
  before(:each) do
    # create scenarios
    @scenario_project = FactoryBot.create(:scenario_project, author: @author_user)
    # create project
    @project = FactoryBot.create(:project, author: @author_user, scenario: @scenario_project)
  end

  it "can be instantiated" do
    expect(FactoryBot.build(:project)).to be_an_instance_of(Narra::Project)
  end

  it "can be saved successfully" do
    expect(@project).to be_persisted
  end

  it "has public tag set to false" do
    # check for meta public tag
    expect(@project.get_meta(name: 'public').value).to match('false')
  end
end