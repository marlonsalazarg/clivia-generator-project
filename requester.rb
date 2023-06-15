require "htmlentities"
require "colorize"
module Requester
  def select_main_menu_action
    gets_option(["random", "scores", "exit"])
  end

  def ask_question(question)
    # show category and difficulty from question #
    coder = HTMLEntities.new
    question_decode = coder.decode(question[:question])
    array_questions = question[:incorrect_answers]
    array_questions << question[:correct_answer]
    array_questions.shuffle!
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}".colorize(:light_blue)
    puts "Question: #{question_decode}".colorize(color: :blue, mode: :bold)
    array_questions.each_with_index do |option, index|
      option_decode = coder.decode(option)
      puts "#{index + 1}. #{option_decode}".colorize(:light_yellow)
    end
    answer = validate_answer?(array_questions)
    [answer, array_questions, question[:correct_answer]]
  end

  def will_save?(score)
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
    puts "Well done! Your score is #{score}"
    puts "-" * 50
    puts "Do you want to save your score? (y/n)"
    print "> "
    action = gets.chomp.downcase
    while action != "y" && action != "n"
      puts "Invalid option"
      print "> "
      action = gets.chomp.downcase
    end
    return unless action == "y"

    puts "Type the name to assign to the score"
    print "> "
    name = gets.chomp
    name = "Anonymous" if name.empty?
    { name:, score: }
  end

  def gets_option(options)
    action = ""
    until options.include?(action)
      puts options.join(" | ").colorize(color: :blue, mode: :bold)
      print "> "
      action = gets.chomp
      puts "Invalid option" unless options.include?(action)
    end
    action
  end

  def validate_answer?(array)
    print "> "
    answer = gets.chomp.to_i
    while answer.negative? || answer > array.length || answer.zero?
      puts "Invalid answer. Please provide a valid answer between 1 and #{array.length}"
      print "> "
      answer = gets.chomp.to_i
    end
    answer
  end
end
