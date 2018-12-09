class GamesController < ApplicationController

  def index

  end

  def move
    new_move = params["new_move"].to_i
    played_positions = params["played_positions"]
    if played_positions == "0"
      @played_positions = []
    else
      @played_positions = played_positions.split(',').map(&:to_i)
    end

    @played_positions.push(new_move) unless new_move == 0
    node = Node.node_from_positions(@played_positions)
    result = Game.new.make_move(node)
    @first_player = result[:first_player]
    if result[:previous_player_won]
      @previous_player_won = result[:previous_player_won]
    elsif result[:game_draw]
      @game_draw = result[:game_draw]
    elsif result[:game_will_draw]
      @game_will_draw = result[:game_will_draw]
      @next_position = result[:next_move].position
    elsif result[:next_player_won]
      @next_player_won = result[:next_player_won]
      @played_positions = @played_positions.to_a.push(@next_position)
    else
      @next_position = result[:next_move].position
      @played_positions = @played_positions.to_a.push(@next_position)
    end
  end
end
