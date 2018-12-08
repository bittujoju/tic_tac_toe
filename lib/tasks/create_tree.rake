namespace :game do
  desc 'play hundred times and learn'


  task :play_100_times => :environment do
    root = Node.create!
    game = Game.new
    (0..50000).each do |i|
      game.make_move(root, true, true, true)
    end
  end
end