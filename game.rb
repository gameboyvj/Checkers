class Game

  def initialize(player1, player2)
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:red)
  end


end

class HumanPlayer
  attr_reader :name, :color

  def initialize(name = "Player 1", color)
    @name = name
    @color = color
  end

  def turn

  end
end