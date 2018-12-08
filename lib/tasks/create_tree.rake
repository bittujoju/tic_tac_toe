namespace :tree do
  desc 'create tree for tic tac toe'
  task :create_tree => :environment do
    start = Node.create!
    positions = (1..9).to_a


    def create_children(parent, positions)
      positions.each do |position|
        node = Node.create!(parent: parent, position: position)
        create_children(node, positions - [position])
      end
    end

    create_children(start, positions)
  end
end