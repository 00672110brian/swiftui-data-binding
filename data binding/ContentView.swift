//
//  ContentView.swift
//  data binding
//
//  Created by User02 on 2020/4/30.
//  Copyright © 2020 sun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var choose = false
   @State private var scale: CGFloat = 1
   @State private var brightnessAmount: Double = 0
   @State private var theDay = Date()
   @State private var selectedName = "女人"
    @State private var ageAmount = 8
    @State private var person = ""
     @State private var showAlert = false
    @State private var showSecondPage = false
    @State private var name = ""
    var roles = ["東方女人", "東方男人","西方女人","西方男人"]
    let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .medium
       return dateFormatter
    }()
    //
   var body: some View {
    VStack{
      VStack {
         Image("beyourself")
                .resizable()
                .scaleEffect(self.scale)
                .brightness(self.brightnessAmount)
            .clipped()
        Button("看看自己的樣子"){
            self.showSecondPage = true
            self.person = "\(self.ageAmount)歲的"+self.selectedName
            
        }.sheet(isPresented: self.$showSecondPage) {
            secondView(person:self.$person)
        }
            }
        Stepper(value: $ageAmount, in: 8...68, step:30) {
            Text("\(ageAmount)歲")
        }
        VStack{
            Form{
            LightView(brightnessAmount: self.$brightnessAmount)
                TextField("你的名字", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(10)
                    .background(Color(red: 110/255, green: 100/255, blue: 244/255))
            DatePicker("日期", selection:$theDay, displayedComponents: .date)
                .frame(width: 300, height: 50)
            .clipped()
        Toggle("選擇你想扮演的人", isOn: $choose)
        if choose {
            VStack(alignment: .leading) {
        Picker(selection: $selectedName, label: Text("選擇角色")) {
           ForEach(roles, id: \.self) { (role) in
              Text(role)
           }
        }.frame(width: 300, height: 50)
          .clipped()
        .pickerStyle(WheelPickerStyle())
                
                Button("確定"){
                     self.showAlert = true
                } .font(.system(size: 20))
                    .offset(x:150,y:30)
                .alert(isPresented: $showAlert) { () -> Alert in
                let result: String
                    result = self.name+"在"+dateFormatter.string(from: theDay)+" 想成為"+"\(ageAmount)歲的"+self.selectedName
                    return Alert(title: Text(result))
                }
            }.padding(20)
            }
            }
      }
    }
   }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct secondView:View {
    @Binding var person:String
    @State private var moveDistance: CGFloat = 0
    @State private var opacity: Double = 1
    var body: some View {
        ZStack{
            Image("background")
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            HStack{
            Button("滿意"){
                self.moveDistance += 10
            }.offset(x:-100,y:180)
                .font(.system(size:20))
                Button("不滿意"){
                    self.opacity -= 0.95
                }.offset(x:100,y:180)
                    .font(.system(size:20))
            }
            Image("\(person)")
            .resizable()
            .frame(width: 300, height: 300)
                .opacity(opacity)
                .offset(x:0,y: moveDistance)
                .animation(.spring(dampingFraction: 0.1))
        }
    }
}

struct LightView: View {
    @Binding var brightnessAmount: Double
    var body: some View {
        HStack{
            Text("亮度")
            Slider(value: $brightnessAmount, in: 0...0.45, minimumValueLabel: Image(systemName: "sun.max.fill").imageScale(.small), maximumValueLabel: Image(systemName: "sun.max.fill").imageScale(.large)){
                Text("")
            }
        }.padding()
    }
}


