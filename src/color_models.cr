include Crystal

module Image::Carrier
  macro define_color_model(name, components, alpha = false, abbreviate = true)
    struct {{name}}
      {%
        parameters = [] of Macros::StringLiteral
        max_arguments = [] of Macros::StringLiteral
        component_abbreviations = {} of Macros::StringLiteral => Macros::StringLiteral
      %}
      {% for component in components %}
        {% parameters << "@" + component + " : UInt16" %}
        {% max_arguments << "UInt16::MAX" %}
        {% component_abbreviations[component[0..0]] = component %}

        getter {{component.id}} : UInt16
      {% end %}

      {% if alpha %}
        {% parameters << "@alpha = UInt16::MAX" %}

        getter alpha : UInt16
      {% end %}
      # def self.null
      #   {{name}}.new
      # end

      NULL = {{name}}.new

      # def self.min
      #   {{name}}.new
      # end

      MIN = {{name}}.new

      # def self.max
      #   {{name}}.new({{max_arguments}})
      # end

      MAX = {{name}}.new({{max_arguments}})

      def initialize
        {% for component in components %}
          @{{component.id}} = 0_u16
        {% end %}

        {% if alpha %}
          @alpha = UInt16::MAX
        {% end %}
      end

      def initialize({{parameters.join(", ").id}})
      end

      {% for abbreviation, component in component_abbreviations %}
        def {{abbreviation.id}}
          @{{component.id}}
        end
      {% end %}

      {% if alpha %}
        def a
          @alpha
        end
      {% end %}
    end
  end

  define_color_model RGB, components: {"red", "green", "blue"}
  define_color_model RGBA, components: {"red", "green", "blue"}, alpha: true
  define_color_model G, components: {"gray"}
  define_color_model GA, components: {"gray"}, alpha: true
end
