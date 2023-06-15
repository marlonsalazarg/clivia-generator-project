require "colorize"
require "terminal-table"
module Presenter
  def print_welcome
    ["###################################",
     "#   Welcome to Clivia Generator   #",
     "###################################"].join("\n").colorize(:light_blue)
  end

  def exit_message
    puts "Thanks for use Clivia Generator, see you soon!".colorize(:light_blue)
    puts "[Marlon Salazar Goncalves]".colorize(:light_blue)
  end

  def print_score(title, headings, rows)
    table = Terminal::Table.new(title:, headings:, rows:)
    puts table
  end
end
