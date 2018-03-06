require 'json'

module JSON
  class << self
    @@loop = 0

    def sorted_generate(obj)
      case obj
        when NilClass, :undef, Integer, Float, TrueClass, FalseClass, String
          return simple_generate(obj)
        when Array
          arrayRet = []
          obj.each do |a|
            arrayRet.push(sorted_generate(a))
          end
          return "[" << arrayRet.join(',') << "]";
        when Hash
          ret = []
          obj.keys.sort.each do |k|
            ret.push(k.to_json << ":" << sorted_generate(obj[k]))
          end
          return "{" << ret.join(",") << "}";
        else
          raise Exception.new("Unable to handle object of type #{obj.class.name} with value #{obj.inspect}")
      end
    end

    def sorted_pretty_generate(obj, indent_len=4)

      # Indent length
      indent = " " * indent_len

      case obj
        when NilClass, :undef, Integer, Float, TrueClass, FalseClass, String
          return simple_generate(obj)
        when Array
          arrayRet = []

          @@loop += 1
          obj.each do |a|
            arrayRet.push(sorted_pretty_generate(a, indent_len))
          end
          @@loop -= 1

          return "[\n#{indent * (@@loop + 1)}" << arrayRet.join(",\n#{indent * (@@loop + 1)}") << "\n#{indent * @@loop}]";

        when Hash
          ret = []

          # This loop works in a similar way to the above
          @@loop += 1
          obj.keys.sort.each do |k|
            ret.push("#{indent * @@loop}" << k.to_json << ": " << sorted_pretty_generate(obj[k], indent_len))
          end
          @@loop -= 1

          return "{\n" << ret.join(",\n") << "\n#{indent * @@loop}}";
        else
          raise Exception.new("Unable to handle object of type #{obj.class.name} with value #{obj.inspect}")
      end

    end # end def
    private
    # simplify jsonification of standard types
    def simple_generate(obj)
      case obj
        when NilClass, :undef
          'null'
        when Integer, Float, TrueClass, FalseClass
          "#{obj}"
        when String
          obj.to_json
        else
          # Should be a string
          # keep string integers unquoted
          (obj =~ /\A[-]?(0|[1-9]\d*)\z/) ? obj : obj.to_json
      end
    end

  end # end class

end # end module


module Puppet::Parser::Functions
  newfunction(:kubeadm_sorted_json, :type => :rvalue, :doc => <<-EOS
This function takes unsorted hash and outputs JSON object making sure the keys are sorted.
Optionally you can pass 2 additional parameters, pretty generate and indent length.
@param unsorted_hash a hash object to sort and convert to JSON
@param pretty boolean: whether to generate human readable JSON
@param indent_len the indentation for the pretty JSON
@return [String] Returns a string object with JSON
@example kubeadm_sorted_json($hash, true, 2)
    EOS
  ) do |args|

    unsorted_hash = args[0]      || {}
    pretty        = args[1]      || false
    indent_len    = args[2].to_i || 4

    if pretty
      return JSON.sorted_pretty_generate(unsorted_hash, indent_len) << "\n"
    else
      return JSON.sorted_generate(unsorted_hash)
    end
  end
end
