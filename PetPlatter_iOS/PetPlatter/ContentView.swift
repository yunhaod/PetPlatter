import SwiftUI
import Starscream

struct ContentView: View {
    @ObservedObject var Manager = WebSocketManager()
    
    var isConnected: Bool {
        Manager.isConnected
    }
    
    var warning: Bool {
        Manager.warning
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if isConnected {
                    HStack {
                        Button(action: {
                            Manager.send_command(msg1: "Feed")
                        }) {
                            Text("Feed")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .buttonStyle(CustomButtonStyle(backgroundColor: Color.pastelOrange, fontSize: 24))
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height / 6)
                        .padding()
                        
                        Button(action: {
                            Manager.send_command(msg1: "Water")
                        }) {
                            Text("Water")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .buttonStyle(CustomButtonStyle(backgroundColor: Color.pastelBlue, fontSize: 24))
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height / 6)
                        .padding()
                    }
                    
                    Button(action: {
                        Manager.send_command(msg1: "Snacks")
                    }) {
                        Text("Snacks")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(CustomButtonStyle(backgroundColor: Color.pastelPurple, fontSize: 24))
                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height / 6)
                    .padding()
                    
                    if warning {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.pastelPink)
                                .frame(width: geometry.size.width * 0.35, height: geometry.size.height / 6)
                            Text("Low Water Warning ☹")
                                .font(.system(size: 24))
                                .padding()
                                .foregroundColor(.white)
                        }
                        .padding()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.pastelPink)
                                .frame(width: geometry.size.width * 0.35, height: geometry.size.height / 6)
                            Text("No Warnings ☺")
                                .font(.system(size: 24))
                                .padding()
                                .foregroundColor(.white)
            
                        }
                        .padding()
                    }
                    
                    Button(action: {
                        Manager.disconnect()
                    }) {
                        Text("Disconnect")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(CustomButtonStyle(backgroundColor: Color.pastelRed, fontSize: 24))
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height / 6)
                    .padding()
                    .padding(.bottom, 30)
                    
                } else {
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            Manager.connect()
                        }) {
                            Text("Connect")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .buttonStyle(CustomButtonStyle(backgroundColor: Color.pastelGreen, fontSize: 24))
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height / 4)
                        
                        Spacer()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .padding()
        }
    }
}

extension Color {
    static let pastelBlue = Color(red: 186 / 255, green: 225 / 255, blue: 255 / 255)
    static let pastelGreen = Color(red: 186 / 255, green: 225 / 255, blue: 201 / 255)
    static let pastelPurple = Color(red: 201 / 255, green: 201 / 255, blue: 255 / 255)
    static let pastelOrange = Color(red: 255 / 255, green: 223 / 255, blue: 186 / 255)
    static let pastelPink = Color(red: 255 / 255, green: 174 / 255, blue: 247 / 255)
    static let pastelRed = Color(red: 255 / 255, green: 139 / 255, blue: 139 / 255)
}

struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var fontSize: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(color: .gray, radius: configuration.isPressed ? 2 : 5, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .font(.system(size: fontSize))
    }
}
