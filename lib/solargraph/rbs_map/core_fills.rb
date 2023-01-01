module Solargraph
  class RbsMap
    module CoreFills
      Override = Pin::Reference::Override

      KEYWORDS = [
        '__ENCODING__', '__LINE__', '__FILE__', 'BEGIN', 'END', 'alias', 'and',
        'begin', 'break', 'case', 'class', 'def', 'defined?', 'do', 'else',
        'elsif', 'end', 'ensure', 'false', 'for', 'if', 'in', 'module', 'next',
        'nil', 'not', 'or', 'redo', 'rescue', 'retry', 'return', 'self', 'super',
        'then', 'true', 'undef', 'unless', 'until', 'when', 'while', 'yield'
      ].map { |k| Pin::Keyword.new(k) }

      YIELDPARAMS = [
        Override.from_comment('Object#tap', %(
@return [self]
@yieldparam [self]
        )),
        Override.from_comment('String#each_line', %(
@yieldparam [String]
        )),
      ]

      methods_with_yieldparam_subtypes = %w[
        Array#each Array#map Array#map! Array#any? Array#all? Array#index
        Array#keep_if Array#delete_if
        Enumerable#each_entry Enumerable#map Enumerable#any? Enumerable#all?
        Enumerable#select Enumerable#reject
        Set#each
      ]

      YIELDPARAM_SINGLE_PARAMETERS = methods_with_yieldparam_subtypes.map do |path|
        Override.from_comment(path, %(
@yieldparam_single_parameter
          ))
      end

      RETURN_VALUE_PARAMETERS = [
        Override.from_comment('Hash#[]', %(
@return_value_parameter
        ))
      ]

      # HACK: Add Errno exception classes
      errno = Solargraph::Pin::Namespace.new(name: 'Errno')
      errnos = []
      Errno.constants.each do |const|
        errnos.push Solargraph::Pin::Namespace.new(type: :class, name: const.to_s, closure: errno)
        errnos.push Solargraph::Pin::Reference::Superclass.new(closure: errnos.last, name: 'SystemCallError')
      end
      ERRNOS = errnos

      ALL = KEYWORDS + YIELDPARAMS + YIELDPARAM_SINGLE_PARAMETERS + RETURN_VALUE_PARAMETERS + ERRNOS
    end
  end
end
