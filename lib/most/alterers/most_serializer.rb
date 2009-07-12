class Object
  def serializable_fields
    @serializable_fields = [] if !@serializable_fields

    return @serializable_fields
  end

  def serializable_fields=(rh_value)
    @serializable_fields = rh_value if rh_value.kind_of?(Array)
  end

  def mark_for_serialization(*args)
    args.compact().each do |elem|
      if elem.class.kind_of?(Symbol)
        serializable_fields << elem
      end
    end
    serializable_fields.uniq!()

    return args
  end

  def unmark_from_serialization(*args)
    args.compact().each do |elem|
      if elem.class.kind_of?(Symbol)
        serializable_fields.delete(elem)
      end
    end
    
    return args
  end

  def partially_serialize(io_stream, format_provider, fields = serializable_fields())
    if io_stream and format_provider
      srl_hash = {}

      fields.each do |field_name|
        srl_hash[field_name] = instance_variable_get("@#{field_name}")
      end

      io_stream.write(format_provider.to_format(srl_hash))
    end

    io_stream.flush()
    io_stream.close()
  end

  def partially_deserialize(io_stream, format_provider)
    if format_provider and io_stream
      desrl_fields =
        format_provider.from_format(io_stream.readlines().join("\n").to_s())

      desrl_fields.each do |field_name, value|
        if field_name and value
          instance_variable_set("@#{field_name}", value)
        end
      end if desrl_fields
    end

    io_stream.close()
  end
end