namespace :game do
  desc 'play hundred times and learn'


  task :play_100_times => :environment do
    root = Node.find(1)
    game = Game.new
    (0..500).each do |i|
      game.make_move(root, true, true)
    end
  end
end