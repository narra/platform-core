# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Generators

      # Return all active generators
      def Core.generators
        # Get all descendants of the Generic generator
        @generators ||= Narra::SPI::Generator.descendants.sort { |x, y| x.priority.to_i <=> y.priority.to_i }
      end

      # Return specified generator
      def Core.generator(identifier)
        generators.select { |generator| generator.identifier.equal?(identifier.to_sym) }.first
      end

      # Generate process invoker
      def Core.generate(item, selected_generators = nil, options = {})
        # check generators for nil and assign only possible generators
        selected_generators ||= item.library.generators.map { |g| g[:identifier].to_s }
        # select them
        selected_generators.select! { |g|
          item.library.scenario.generators.map { |h| h[:identifier].to_s }.include?(g.to_s) &&
              Generators.generators_identifiers.include?(g.to_sym)
        }
        # collect
        selected_generators.collect! { |g| item.library.scenario.generators.detect { |h| h[:identifier].to_s == g.to_s} }
        # process item
        selected_generators.each do |generator|
          # get generator class
          check = generators.detect { |g| g.identifier == generator[:identifier].to_sym }
          # process if it is valid for this item
          process(type: :generator, item: item._id.to_s, identifier: generator[:identifier], options: generator[:options].merge(options)) if check.valid?(item)
        end
      end

      private

      # Return all active generators
      def self.generators_identifiers
        # Get array of generators identifiers
        @generators_identifiers ||= Core.generators.collect { |generator| generator.identifier }
      end

    end
  end
end
