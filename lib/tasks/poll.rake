task poll: :environment do
  MainFeed.all.each do |feed|
    begin
      feed.poll!
    rescue => e
      puts "Error polling. MainFeed ID: #{feed.id}; error: #{e.message}"
    end
  end
end
