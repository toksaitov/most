module Most
  module MemoryOut
    class Error < Interrupt; end
    class ExitException < Exception; end

    THIS_FILE = /\A#{Regexp.quote(__FILE__)}:/o
    CALLER_OFFSET = ((c = caller[0]) && THIS_FILE =~ c) ? 1 : 0

    def generic_memory_out(bytes, pid = nil, precision = 0.1, klass = nil, checking_proc = method(:memory), &block)
      return yield if bytes.nil? and block_given?

      current_thread = nil
      checker_thread = nil

      exception = klass || Class.new(ExitException)

      begin
        current_thread = Thread.current
        checker_thread = Thread.start do
          loop do
            memory_report = checking_proc.call(pid)

            GLOBALS[:memory] ||= []
            GLOBALS[:memory] << memory_report

            if memory_report > bytes
              current_thread.raise(exception)
            end

            sleep(precision)
          end
        end

        yield bytes if block_given?

      rescue exception => e
        rej = /\A#{Regexp.quote(__FILE__)}:#{__LINE__-4}\z/o
        (bt = e.backtrace).reject! {|m| rej =~ m}
        level = -caller(CALLER_OFFSET).size

        while THIS_FILE =~ bt[level]
          bt.delete_at(level)
          level += 1
        end

        raise unless klass.nil?

        raise(Error, e.message, e.backtrace)
      ensure
        checker_thread.kill() if not checker_thread.nil? and checker_thread.alive?
      end
    end

    def memory_out(bytes, pid = nil, precision = 0.1, klass = nil, &block)
      generic_memory_out(bytes, pid, precision, klass, method(:memory), &block)
    end

    def virtual_memory_out(bytes, pid = nil, precision = 0.1, klass = nil, &block)
      generic_memory_out(bytes, pid, precision, klass, method(:virtual_memory), &block)
    end

    def total_memory_out(bytes, pid = nil, precision = 0.1, klass = nil, &block)
      generic_memory_out(bytes, pid, precision, klass, method(:total_memory), &block)
    end

    def memory(pid = Process.pid)
      result = 0

      pid ||= GLOBALS[:pid]
      result = SERVICES[:process_table].memory(pid) unless pid.nil?

      result
    end

    def virtual_memory(pid = Process.pid)
      result = 0

      pid ||= GLOBALS[:pid]
      result = SERVICES[:process_table].virtual_memory(pid) unless pid.nil?

      result
    end

    def total_memory(pid = Process.pid)
      memory(pid) + virtual_memory(pid)
    end

    module_function :generic_memory_out

    module_function :memory_out, :virtual_memory_out, :total_memory_out
    module_function :memory, :virtual_memory, :total_memory
  end
end