# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ActiveSupport::Inflector.inflections do |inflect|
  # cache singularity
  inflect.irregular('cache', 'cache')
  inflect.irregular('meta', 'meta')
  inflect.irregular('input', 'input')
  inflect.irregular('output', 'output')
end
