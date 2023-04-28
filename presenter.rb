module Presenter
  def print_welcome
    [ 
      "###################################",
      "#   Welcome to Clivia Generator   #",
      "###################################"
    ].join("\n")
  end

  def get_with_options(options, required: true, default: nil)
    action = ""
    until options.include?(action)
      puts options.join(" | ") # "login | create_user | exit"
      print "> "
      action, id = gets.chomp.split
      break if action.nil? && !required

      puts "Invalid option" unless options.include?(action)
    end
    action.empty? && default ? [default] : [action, id]
  end

  def login_menu
    get_with_options(["random", "scores", "exit"])
  end

  def print_score(score)
    # print the score message
  end

end
