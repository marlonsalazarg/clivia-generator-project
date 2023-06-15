require_relative "clivia_generator"

# capture command line arguments (ARGV)#
default_file = ARGV.shift
default_file = "scores.json" if default_file.nil?

trivia = CliviaGenerator.new(default_file)
trivia.start
