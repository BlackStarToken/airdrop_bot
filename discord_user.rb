require 'sqlite3'
require './BSTCoin.rb'

class DiscordUser
    
    def initialize(user, address, amount = 100000)
        @db = SQLite3::Database.new 'discord_bot.db'
        @id = user.id
        @disc = user.discriminator
        @name = user.name
        @address = address
        if check_user_count >= 1000
            @amount = 50000
        else
            @amount = amount
        end
        @message = ""
    end
    
    # ユーザ情報に問題が無いか確認
    def status
        
        mension = "<@!#{@id}>"
        prefix = mension + "さん\n"
        
        if !isWallet
            @message = prefix + "ウォレットのアドレスが異常です"
            false
        elsif !isNotDupicateUser
            @message = prefix + "既に送信しているユーザです"
            false
        else
            true
        end
    end
    
    def execSendCoin
        if !sendCoin
            @message = "コインの送金に失敗しました"
            false
        else
            mension = "<@!#{@id}>"
            prefix = mension + "さん\n"
            @message = prefix + "#{mension}さんに#{@amount}BSTを送金しました"
            if check_user_count == 1000
                @message += "\nおめでとう！エアドロップ1000人目の受け取り人だよ！"
            end
            save
            true
        end
    end
    
    # 送信メッセージ取得
    def getMessage
        @message
    end
    
    private
    
    # 送金処理
    def sendCoin
        # 送金処理
        bst = BSTCoin.new(@address, @amount)
        bst.execSendCommand
        true
    end
    
    # ウォレットアドレス判断
    def isWallet
        if @address[0] == 'V' && @address.length == 34
            true
        else
            false
        end
    end
    
    # ユーザID、アドレスの重複確認
    def isNotDupicateUser
        row = @db.execute("select count(*) from users where user_id = '#{@id}' OR address = '#{@address}'")
        count = row[0][0]
        if  count == 0
            true
        else
            false
        end
    end
    
    # 情報をDBに保存(送金処理が正常に行えた場合のみ)
    def save
        if !status
            return false
        end
        begin
            @db.execute('insert into users (user_id, address, name) values(?, ?, ?)', @id, @address, @name)
        rescue SQLite3::SQLException => e
            puts e.message
            puts "DB書き込みエラー"
            false
        end
        true
    end
    
    # 配布済みユーザ数を数える
    def check_user_count
        begin
            row = @db.execute('select count(*) from users')
            count = row[0][0]
        rescue SQLite3::SQLException => e
            puts e.message
            puts "DB読み出しエラー"
            false
        end
        return count.to_i
    end 
    
end