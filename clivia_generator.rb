require "json"
require "httparty"
require_relative "requester"
require_relative "presenter"

class CliviaGenerator
  include Requester
  include Presenter
  include HTTParty
  base_uri("https://opentdb.com")

  def initialize(scores_file)
    @scores_file = scores_file
    File.write(@scores_file, "[]") unless File.exist?(@scores_file)
    @scores_parsed = parse_scores
    @results = []
    @score = 0
  end

  def start
    action = ""
    until action == "exit"
      puts print_welcome
      action = select_main_menu_action
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" then exit_message
      end
    end
  end

  def random_trivia
    # load the questions from the api
    @results = load_questions
    ask_questions
  end

  def ask_questions
    @results.each do |question|
      answer, array, correct_answer = ask_question(question)
      coder = HTMLEntities.new
      correct_decode = coder.decode(correct_answer)
      if array[answer - 1] == correct_answer
        puts "#{correct_decode} Correct!".colorize(color: :green, mode: :bold)
        @score += 10
      else
        puts "#{coder.decode(array[answer - 1])}... Incorrect!".colorize(:light_red)
        puts "The correct answer was: #{correct_decode}".colorize(:light_green)
      end
    end
    data = will_save?(@score)
    save(data) unless data.nil?
    @score = 0
  end

  def save(data)
    # write to file the scores data
    @scores_parsed << data
    File.write(@scores_file, JSON.pretty_generate(@scores_parsed))
  end

  def parse_scores
    JSON.parse(File.read(@scores_file), symbolize_names: true)
  end

  def load_questions
    response = self.class.get("/api.php?amount=10")
    response_parsed = parse_questions(response)
    response_parsed[:results]
  end

  def parse_questions(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def print_scores
    # print the scores sorted from top to bottom #
    rows = @scores_parsed
    title = "°°Top Scores°°"
    headings = ["Name".colorize(:red), "Score".colorize(:red)]
    rows = rows.sort_by { |row| row[:score] }.reverse
    rows = rows.map { |row| [row[:name].colorize(:magenta), row[:score]] }
    print_score(title.colorize(:light_magenta), headings, rows)
  end
end
