File.open("/dev/zero", "r") do |in_|
  File.open("/dev/null", "w") do |out|
    for i in 0..256000
      out.syswrite(in_.sysread(4096))
    end
  end
end

