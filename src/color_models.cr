include Crystal

module IntelQA::Carrier
  macro define_color_model(name, components, alpha = false, abbreviate = true, scale_size = 16)
    struct {{name}}
      {%
        parameters = [] of Macros::StringLiteral
        max_arguments = [] of Macros::StringLiteral
        component_abbreviations = {} of Macros::StringLiteral => Macros::StringLiteral
      %}
      {% for component in components %}
        {% parameters << "@" + component + " : UInt" + scale_size.stringify %}
        {% max_arguments << "UInt" + scale_size.stringify + "::MAX" %}

        {% if abbreviate %}
          {% component_abbreviations[component[0..0]] = component %}
        {% end %}

        getter {{component.id}} : UInt{{scale_size}}
      {% end %}

      {% if abbreviate && (component_abbreviations.size != components.size || component_abbreviations.keys.includes?("a")) %}
        {% abbreviate = false %}
      {% end %}

      {% if alpha %}
        {% parameters << "@alpha = UInt" + scale_size.stringify + "::MAX" %}

        getter alpha : UInt{{scale_size}}
      {% end %}

      NULL = {{name}}.new
      MIN = {{name}}.new
      MAX = {{name}}.new({{max_arguments}})

      RESOLUTION = {{scale_size}}
      MAX_INTENSITY = {{2^scale_size - 1}}

      def initialize
        {% for component in components %}
          @{{component.id}} = 0_u16
        {% end %}

        {% if alpha %}
          @alpha = UInt{{scale_size}}::MAX
        {% end %}
      end

      def initialize({{parameters.join(", ").id}})
      end

      {% if abbreviate %}
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
      {% end %}
    end
  end

  define_color_model RGB, components: {"red", "green", "blue"}
  define_color_model RGBA, components: {"red", "green", "blue"}, alpha: true
  define_color_model G, components: {"gray"}
  define_color_model GA, components: {"gray"}, alpha: true
end
