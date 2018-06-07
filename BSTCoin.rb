# BST用クラス

class BSTCoin

    def initialize(address, amount)
       @fromAddress = ENV["FROM_ADDRESS"]
       @contractAddress = ENV["CONTRACT_ADDRESS"]
       @address = address
       @amount = amount
    end
    
    # 送金用コマンド作成
    def execSendCommand
        # アドレス変換
        hexAddress = `VIPSTARCOIN-cli gethexaddress #{@address}`
        # 送金量変換
        convertedAmount = convertAmount(@amount)
        # コマンド作成
        command = "VIPSTARCOIN-cli sendtocontract #{@contractAddress} a9059cbb000000000000000000000000#{hexAddress}#{convertedAmount} 0 250000 0.0000004 #{@fromAddress}"
        command.gsub!("\n", '')
        # コマンド実行
        ret = `#{command}`
        puts ret
    end
    
    private
    
    def convertAmount(amount)
        amount *= 10**18
        hex = amount.to_i.to_s(16)
        str = "0" * (64 - hex.length) + hex
    end


end