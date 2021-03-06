import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        Home()
    }
}
struct Home: View {
    @State var start: Bool = false
    @State var to: CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {

        ZStack {
            Color.black
                .opacity(0.06)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .trim(from: 0, to: self.to)
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.init(degrees: -90))
                    VStack {
                        Text("\(count)")
                            .font(.system(size: 65))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Of 15")
                            .font(.title)
                            .padding(.top)
                    }
                }
                HStack(spacing: 20) {
                    Button(action: {
                        if self.count == 15 {
                            self.count = 0
                            withAnimation(.default) {
                                self.to = 0
                            }
                        }
                        self.start.toggle()
                    }, label: {
                        HStack(spacing: 15) {
                            Image(systemName: self.start ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            Text(self.start ? "Pause" : "Play")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    })
                    Button(action: {
                        self.count = 0
                        withAnimation(.default) {
                            self.to = 0
                        }
                    }, label: {
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)
                            Text("Restart")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(Color.red, lineWidth: 2)
                        )
                        .shadow(radius: 6)
                    })

                    
                }
                .padding(.top, 55)
            }
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options:              [.badge,.sound,.alert]) { (_,_) in
            }
        })
        .onReceive(self.time, perform: { _ in
            if self.start {
                
                if self.count != 15 {
                    self.count += 1
                    print("working")
                    withAnimation(.default) {
                        self.to = CGFloat(self.count) / 15
                    }

                }
                else {
//                    withAnimation(.default) {
//                        self.to = 0
//                    }
                    self.start.toggle()
                    self.Notify()
                    
                }
            }
    
        })
    }
    func Notify() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Time is completed!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
