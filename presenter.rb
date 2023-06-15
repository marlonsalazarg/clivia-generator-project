require "terminal-table"
module Presenter
  def print_welcome
    ["###################################",
     "#   Welcome to Clivia Generator   #",
     "###################################"].join("\n")
  end

  def exit_message
    puts "Thanks for use Clivia Generator, see you soon!"
    puts "[Marlon Salazar Goncalves]"
  end

  def print_score(title, headings, rows)
    table = Terminal::Table.new(title:, headings:, rows:)
    puts table
  end
end
