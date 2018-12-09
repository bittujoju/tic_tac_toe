namespace :game do
  desc 'play hundred times and learn'


  task :play_100_times => :environment do
    root = Node.find(1)
    # will get stuck at a draw game with existing logic
    game = Game.new
    (0..100000).each do |i|
      game.make_move(root, true, true)
    end
  end
end