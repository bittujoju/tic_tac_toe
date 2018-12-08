class Game < ActiveRecord::Base


  def make_computer_move(node)
    ancestors = Node.ancestors_of(node)
    used_positions = ancestors.pluck(:position)
    available_positions = ((1..9).to_a - used_positions - [node.position])

    unless node.children.exists?
      available_positions.each do |position|
        Node.create!(parent: node, position: position)
      end
    end

    favorite_child = node.children.max do |child_1, child_2|
      (child_1.second_player_win - child_1.first_player_win) <=> (child_2.second_player_win - child_2.first_player_win)
    end

    favorite_child
  end


end