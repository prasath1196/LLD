def main
  fileinput = ARGV[0]
  file = File.open(fileinput)
  session = CommandSession.new
  file.readlines.each do |line|
    # Add your code here to process input commands
  end
end

main