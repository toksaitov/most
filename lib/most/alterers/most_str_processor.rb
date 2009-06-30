class Module
  alias old_public public
  alias old_private private
  alias old_protected protected
                               
  @__module_access_level = 'public'

  def str_attr(symbol, writable = false)
    if symbol.kind_of?(Symbol)
      module_eval("def #{symbol}() " +
                    "if @#{symbol}.kind_of?(String) then " +
                      "if @replacer then " +
                        "return @replacer.process(@#{symbol}) " +
                      "elsif @env and @env.replacer then " +
                        "return @env.replacer.process(@#{symbol}) " +
                      "else return @#{symbol} end; " +
                    "else return @#{symbol} end; end")

      module_eval("def #{symbol}=(val) @#{symbol} = val; end") if writable

      module_eval("#{@__module_access_level} :#{symbol}")
      module_eval("#{@__module_access_level} :#{symbol}=")
    end
  end

  def str_attr_reader(symbol, *smth)
    str_attr(symbol)
    smth.each do |another_symbol|
      str_attr(another_symbol)
    end
  end

  def str_attr_writer(symbol, *smth)
    symbols = smth << symbol

    symbols.each do |another_symbol|
      if another_symbol.kind_of?(Symbol)
        module_eval("def #{another_symbol}=(val) @#{another_symbol} = val; end")
        module_eval("#{@__module_access_level} :#{another_symbol}=")
      end
    end
  end

  def str_attr_accessor(symbol, *smth)
    str_attr(symbol, true)
    smth.each do |another_symbol|
      str_attr(another_symbol, true)
    end
  end

  def public(symbol = nil)
    if symbol.kind_of?(Symbol)
      @__module_access_level = 'public'; old_public()
    else
      old_public(symbol) if symbol
    end
  end

  def private(symbol = nil)
    if symbol.kind_of?(Symbol)
      @__module_access_level = 'private'; old_private()
    else
      old_private(symbol) if symbol
    end
  end

  def protected(symbol = nil)
    if symbol.kind_of?(Symbol)
      @__module_access_level = 'protected'; old_private()
    else
      old_private(symbol) if symbol
    end
  end
end