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

  def second_player_make_move(node)
    played_path = node.path
    played_positions = played_path.pluck(:position)
    available_positions = (1..9).to_a - played_positions
    first_player_moves = played_positions.select.with_index { |_, i| i.odd? }
    first_player_won = won?(first_player_moves)

    if first_player_won
      train(node)
      return {first_player_won: first_player_won}
    end
    unless node.children.exists?
      available_positions.each do |position|
        Node.create!(parent: node, position: position)
      end
    end

    game_draw = !node.children.exists?
    return {game_draw: game_draw} if game_draw

    favorite_child = node.children.max do |child_1, child_2|
      (child_1.second_player_win - child_1.first_player_win) <=> (child_2.second_player_win - child_2.first_player_win)
    end

    second_player_moves = ((played_positions - first_player_moves) + [favorite_child.position])
    second_player_won = won?(second_player_moves)

    if second_player_won
      train(favorite_child)
      return {second_player_won: second_player_won, next_move: favorite_child}
    end
    {next_move: favorite_child}
  end

  def won?(played_positions)
    WIN_POSITIONS.any? { |positions| positions.all? { |p| played_positions.include?(p)} }
  end

  def train(node)
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