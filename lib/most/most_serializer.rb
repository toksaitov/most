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
      if (elem.class == Symbol)
        serializable_fields() << elem
      end
    end
    serializable_fields().uniq!()

    return args
  end

  def unmark_from_serialization(*args)
    args.compact().each do |elem|
      if (elem.class == Symbol)
        serializable_fields().delete(elem)
      end
    end
    
    return args
  end

  def partially_serialize(io_stream, most_format_provider)
    if io_stream and most_format_provider
      srl_hash = {}
      serializable_fields().each do |sym|
        srl_hash[sym] = instance_variable_get("@#{sym}")
      end

      io_stream.write(most_format_provider.to_format(srl_hash))
    end

    io_stream.flush()
    io_stream.close()
  end

  def partially_deserialize(io_stream, most_format_provider)
    if most_format_provider and io_stream
      deserialized_fields = most_format_provider.revert(io_stream.readlines().join("\n").to_s())

      if deserialized_fields
        deserialized_fields.each do |sym_key, field|
          if sym_key and field
            instance_variable_set("@#{sym_key}", field)
          end
        end
      end
    end

    io_stream.close()
  end
end