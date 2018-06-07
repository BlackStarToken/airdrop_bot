require 'discordrb'
require './discord_user.rb'

bot = Discordrb::Bot.new token: ENV['CLIENT_TOKEN']

bot.message() do |event|
    # コマンド判別
    message = event.message.content
    if event.message.channel.id == ENV["DISCORD_CHANNEL_ID"]
        p Time.now().to_s + " : " + message
        address = event.message.content
        user = event.user
        user = DiscordUser.new(user, address)
        if user.status
            user.execSendCoin
        end
        event.respond user.getMessage
    end
end

bot.run