class GamesController < ApplicationController

  def index

  end

  def move
    new_move = params["new_move"].to_i
    played_positions = params["played_positions"]
    if played_positions == "[]"
      played_positions = []
    else
      played_positions = played_positions.split(',').map(&:to_i)
    end

    @played_positions = played_positions.to_a.push(new_move)
    node = Node.node_from_positions(played_positions)
    result = Game.new.make_move(node)

    if result[:previous_player_won]
      @previous_player_won = result[:previous_player_won]
    elsif result[:game_draw]
      @game_draw = result[:game_draw]
    elsif result[:next_player_won]
      @next_player_won = result[:next_player_won]
      @next_position = result[:next_move].position
      @played_positions = @played_positions.to_a.push(@next_position)
    else
      @next_position = result[:next_move].position
      @played_positions = @played_positions.to_a.push(@next_position)
    end
  end
end
