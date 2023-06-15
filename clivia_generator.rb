require "json"
require "httparty"
require_relative "presenter"

class CliviaGenerator
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
      action = gets.chomp.downcase
      case action
      when "random" then puts "Random Trivia"
      when "scores" then puts "Scores"
      when "exit" then puts "Goodbye!"
      end
    end
  end

  def random_trivia
    # load the questions from the api
  end

  def ask_questions
    # ask the questions
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
end
