module Open4
  def popen4(*cmd)
    pw, pr, pe = IO::pipe, IO::pipe, IO::pipe

    pid = spawn(*cmd, STDIN => pw[0], STDOUT => pr[1], STDERR => pe[1])
    wait_thr = Process.detach(pid)

    pw[0].close; pr[1].close; pe[1].close

    pi = [pw[1], pr[0], pe[0], pid, wait_thr]
    pw[1].sync = true

    if defined? yield
      begin
        return yield(*pi)
      ensure
        [pw[1], pr[0], pe[0]].each{ |p| p.close unless p.closed? }
        wait_thr.join
      end
    end

    pi
  end

  module_function :popen4
end