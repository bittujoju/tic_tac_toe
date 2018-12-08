class Node < ActiveRecord::Base
  has_ancestry

  def self.node_from_positions(played_positions)
    parent = Node.find(1)
    played_positions.each do |position|
      node = parent.children.find_by_position(position)
      (node = Node.create!(parent: parent, position: position)) unless node.present?
      parent = node
    end
    parent
  end
end