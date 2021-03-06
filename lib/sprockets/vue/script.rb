require 'active_support/concern'
require "action_view"
module Sprockets::Vue
  class Script
    class << self
      include ActionView::Helpers::JavaScriptHelper

      SCRIPT_REGEX = Utils.node_regex('script')
      TEMPLATE_REGEX = Utils.node_regex('template')
      SCRIPT_COMPILES = {
        'coffee' => ->(s, input){
          CoffeeScript.compile(s, sourceMap: true, sourceFiles: [input[:source_path]], no_wrap: true)
        },
        'es6' => ->(s, input){
          Babel::Transpiler.transform(data, {}) #TODO
        }
      }
      def call(input)
        data = input[:data]
        name = input[:name]
        input[:cache].fetch([cache_key, input[:source_path], data]) do
          script = SCRIPT_REGEX.match(data)
          template = TEMPLATE_REGEX.match(data)
          output = []
          map = nil
          if script
            result = SCRIPT_COMPILES[script[:lang]].call(script[:content], input)
            map = result['sourceMap']

            output << "'object' != typeof VCompents && (VCompents = {});
              #{result['js']}; VCompents['#{name}'] = vm;"
          end

          if template
            output << "VCompents['#{name.sub(/\.tpl$/, "")}'].template = '#{j template[:content]}';"
          end

          { data: "#{warp(output.join)}", map: map }
        end
      end

      def warp(s)
        "(function(){#{s}}).call(this);"
      end

      def cache_key
        [
          self.name,
          VERSION,
        ].freeze
      end
    end
  end
end
