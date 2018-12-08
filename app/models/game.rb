class Game < ActiveRecord::Base


  WIN_POSITIONS = [[1,2,3],
                   [4,5,6],
                   [7,8,9],
                   [1,4,7],
                   [2,5,8],
                   [3,6,9],
                   [1,5,9],
                   [3,5,7]
  ]

  def make_move(node, first_player=false, learning_mode=false, self_play=false)
    played_path = node.path
    played_positions = played_path.pluck(:position)
    available_positions = (1..9).to_a - played_positions
    previous_player_moves = played_positions.select.with_index { |_, i| i.odd? }
    previous_player_won = won?(previous_player_moves)

    if previous_player_won
      learn(node)
      return {previous_player_won: previous_player_won}
    end
    unless node.children.exists?
      available_positions.each do |position|
        Node.create!(parent: node, position: position)
      end
    end

    game_draw = !node.children.exists?
    return {game_draw: game_draw} if game_draw

    if learning_mode
      favorite_child = node.children.min do |child_1, child_2|
        (child_1.second_player_win + child_1.first_player_win) <=> (child_2.second_player_win + child_2.first_player_win)
      end
    else
      if first_player
        favorite_child = node.children.min do |child_1, child_2|
          (child_1.second_player_win - child_1.first_player_win) <=> (child_2.second_player_win - child_2.first_player_win)
        end
      else
        favorite_child = node.children.max do |child_1, child_2|
          (child_1.second_player_win - child_1.first_player_win) <=> (child_2.second_player_win - child_2.first_player_win)
        end
      end
    end

    next_player_moves = ((played_positions - previous_player_moves) + [favorite_child.position])
    next_player_won = won?(next_player_moves)

    if next_player_won
      learn(favorite_child)
      return {next_player_won: next_player_won, next_move: favorite_child}
    end

    if self_play
      p favorite_child.path.pluck(:position)
      make_move(favorite_child, !first_player, learning_mode, self_play)
    else
      {next_move: favorite_child}
    end
  end

  def won?(played_positions)
    WIN_POSITIONS.any? { |positions| positions.all? { |p| played_positions.include?(p)} }
  end

  def learn(node)
    ancestors = node.path
    if ancestors.count.even?
      #first player win
      ancestors.each do |ancestor|
        ancestor.first_player_win += 1
        ancestor.save
      end
    else
      #second player win
      ancestors.each do |ancestor|
        ancestor.second_player_win += 1
        ancestor.save
      end
    end
  end

end