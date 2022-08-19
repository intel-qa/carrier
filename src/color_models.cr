module Image::Carrier
  macro define_color_model(name, components)
    struct {{name}}
      {% parameters = [] of Crystal::Macros::StringLiteral %}
      {% for component in components %}
        {%
          if component == :a
            type_decision = " = UInt16::MAX"
          else
            type_decision = " : UInt16"
          end
        %}
        {% parameters << component.id.stringify + type_decision %}
        
        getter {{component.id}} : UInt16
      {% end %}

      def self.null
        {{name}}.new
      end

      def initialize
        {% for component in components %}
          @{{component.id}} = 0_u16
        {% end %}
      end

      def initialize({{parameters.join(", ").id}})
        {% for component in components %}
          @{{component.id}} = {{component.id}}
        {% end %}
      end
    end
  end

  define_color_model RGB, components: {:r, :g, :b}
  define_color_model RGBA, components: {:r, :g, :b, :a}
  define_color_model G, components: {:g}
  define_color_model GA, components: {:g, :a}
end
