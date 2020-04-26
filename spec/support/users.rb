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

RSpec.configure do |config|
  config.before(:each) do
    # create users
    # testing hashes
    admin_hash = {uid: 'admin@narra.eu', provider: 'test', username: 'admin', name: 'Admin', email: 'admin@narra.eu', image: nil}
    author_hash = {uid: 'author@narra.eu', provider: 'test', username: 'author', name: 'Author', email: 'author@narra.eu', image: nil}
    contributor_hash = { uid: 'contributor@narra.eu', provider: 'test', username: 'contributor', name: 'Contributor', email: 'contributor@narra.eu', image: nil }
    unroled_hash = {uid: 'unroled@narra.eu', provider: 'test', username: 'unroled', name: 'Unroled', email: 'unroled@narra.eu', image: nil}
    # create user and its identity
    Narra::Identity.create_from_hash(admin_hash)
    Narra::Identity.create_from_hash(author_hash)
    Narra::Identity.create_from_hash(contributor_hash)
    Narra::Identity.create_from_hash(unroled_hash)
    # get admin token and user
    @admin_user = Narra::User.find_by(name: 'Admin')
    # get author token and user
    @author_user = Narra::User.find_by(name: 'Author')
    # get contributor token and user
    @contributor_user = Narra::User.find_by(name: 'Contributor')
    # get guest token and user
    @unroled_user = Narra::User.find_by(name: 'Unroled')
    @unroled_user.roles = []
    @unroled_user.save
  end
end