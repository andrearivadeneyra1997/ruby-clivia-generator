module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
  end

  def ask_question(question)
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    puts "Question: #{question[:question]}"
  end

  def will_save?
    puts "Well done! Your score is #{@score}"
    puts "Do you want to save your score? (y/n)"
    gets.chomp
  end

  def validate_answer(user_answer, correct_answer)
    if user_answer === correct_answer
      @score += 10
      return "Correct!"
    else
      "Incorrect!\nThe correct answer was: #{correct_answer}"
    end
  end

  def gets_option(options, correct_answer)
    options.each_with_index do | answer, index |
      puts "#{index + 1}. #{answer}"
    end
    user_response = gets.chomp.to_i
    if(user_response <= options.length())
      user_answer = options[user_response - 1]
      puts "#{user_answer}... #{validate_answer(user_answer, correct_answer)}"
    else
      gets_option(options, correct_answer)
    end
  end
end
