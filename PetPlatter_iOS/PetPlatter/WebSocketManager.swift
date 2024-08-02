import Foundation
import Starscream

class WebSocketManager: WebSocketDelegate , ObservableObject{
    
    var socket: WebSocket!
    @Published var isConnected : Bool
    var server = WebSocketServer()
    @Published var warning : Bool
    
    init(){
        isConnected = false
        warning = false
    }
    
    func connect(){
        var request = URLRequest(url: URL(string: "ws://ec2-52-91-178-218.compute-1.amazonaws.com:8765")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
            if string == "Warning" {
                warning = true
            }
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error)
            case .peerClosed:
                break
            }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func disconnect(){
        socket.disconnect()
    }
    
    func send_command(msg1 : String){
        socket.write(string: msg1)
        if msg1 == "Water"{
            warning = false
        }
    }
}
