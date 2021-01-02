//
//  SocketIOManager.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/30/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    var manager: SocketManager?
    var socket: SocketIOClient!
    
    var handlerSocketData: ((Any) -> Void)?
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: URL(string: "https://q.investaz.az")!, config: [.log(false), .compress, .path("/live")])
        
        socket = manager?.defaultSocket
    }
    
    func establishConnection(competetion: @escaping (Bool) -> Void) {
        socket.on(clientEvent: .connect) { (data, ack) in
            competetion(true)
        }
        socket.connect()
    }
    
    func disconnectConnection() {
        socket.disconnect()
    }
    
    enum Events {
        case getOnlineQuotes
        
        var eventName: String {
            switch self {
            case .getOnlineQuotes:
                return "message"
            }
        }
        
        func getOnlineQuotesFunction() {
            SocketIOManager.shared.socket.on(eventName) { (data, ack) in
                SocketIOManager.shared.handlerSocketData?(data)
            }
        }
    }
}
