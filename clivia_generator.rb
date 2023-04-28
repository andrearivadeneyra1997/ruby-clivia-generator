require "httparty"
require "json"
require "terminal-table"
require "colorize"
require_relative "presenter"
require_relative "requester"

class CliviaGenerator
  include Presenter
  include Requester

  def initialize
    @questions = nil
    @score = 0
    @current_question = nil
  end

  def start
    puts print_welcome
    action = ""
    until action == "exit"
      action = login_menu[0]
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" then puts "Thanks for using Clivia Generator"
      end
    end
  end

  def random_trivia
    load_questions
    ask_questions
  end

  def ask_questions
    for question in @questions do
      @current_question = question
      ask_question(question)
      gets_option(question[:answers], question[:correct_answer])
    end
    user_response = will_save?

    if user_response === "y"
      puts "Type the name to assign to the score"
      user_response = gets.chomp
      data = {:score => @score, :name => user_response}
      save(data)
    end
  end

  def parse_scores
    file = File.read('./scores.json')
    JSON.parse(file)
  end

  def save(data)
    data_hash = parse_scores
    data_hash << data
    File.write('./scores.json', JSON.dump(data_hash))
  end

  def load_questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    @questions = parse_questions(response["results"])
  end

  def parse_questions(response1)
    response1.map{ |question| {
      category: question["category"],
      type: question["type"],
      difficulty: question["difficulty"],
      question: question["question"],
      correct_answer: question["correct_answer"],
      answers: question["incorrect_answers"].push(question["correct_answer"]).shuffle
    } }
  end

  def print_scores
    scores = parse_scores.sort_by{|e| -e["score"]}
    puts "+-----------+-------+"
    puts "|    Top Scores     |"
    puts "+-----------+-------+"
    puts "| Name      | Score |"
    puts "+-----------+-------+"

    for score in scores do
      puts "| #{score["name"].ljust(10, ' ')}| #{score["score"].to_s.ljust(6, ' ')}|"
    end

    puts "+-----------+-------+"
  end
end

trivia = CliviaGenerator.new
trivia.start
