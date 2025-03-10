//
//  WorkoutFrequenceView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI
import Charts

struct WorkoutFrequenceView: View {
    @ObservedObject var controller = WorkoutFrequenceController.shared
    @State private var selectedIndex: Int? = nil /// Index jour sélectionné
    @State private var isShowingSheet: Bool = false /// Signifie que la sheet d'enregistrement de présence est affiché
    @State private var selectedDate: Date = Date()
    
    
    var body: some View {
        GroupBox {
            GroupBox(label:
                        HStack{
                Text("\(controller.currentDate.formatted(.dateTime.locale(Locale(identifier: "fr_CA")).month(.wide).year()))")
                Button(action: {
                    withAnimation(.easeIn){
                        controller.decreaseMonth()
                    }
                }) {
                    Image(systemName: "arrow.backward.circle.fill")
                        .foregroundStyle(.main)
                }
                .onHover { hovering in
                    if (hovering){
                        NSCursor.pointingHand.push()
                    }
                    else {
                        NSCursor.pop()
                    }
                }
                
                Button(action: {
                    withAnimation(.easeIn){
                        controller.increaseMonth()
                    }
                }) {
                    Image(systemName: "arrow.forward.circle.fill")
                        .foregroundStyle(.main)
                }
                .onHover { hovering in
                    if (hovering){
                        NSCursor.pointingHand.push()
                    }
                    else {
                        NSCursor.pop()
                    }
                }
                
                Spacer()
                Button(action: {isShowingSheet.toggle()}) {
                    Text("Ajout")
                }
                .onHover { hovering in
                    if (hovering){
                        NSCursor.pointingHand.push()
                    }
                    else {
                        NSCursor.pop()
                    }
                }
                .sheet(isPresented: $isShowingSheet, content: {
                    VStack {
                        Image(.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                            .cornerRadius(15)
                        
                        Text("Ajouter un entraînement")
                            .font(.title)
                            .padding(25)
                        
                        VStack{
                            HStack {
                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                            }
                        }
                        .frame(width: 400, height: 200)
                        .background(Color.white)
                        .cornerRadius(15)
                        
                        HStack {
                            Button(action: {}) {
                                Text("Retour")
                            }
                            .buttonStyle(RoundedButtonStyle(
                                width: 75,
                                height: 45,
                                color: .red.opacity(0.8),
                                hoveringColor: .red,
                                action: {
                                    isShowingSheet.toggle()
                                }))
                            .padding()
                            
                            Button(action: {}) {
                                Text("Appliquer")
                            }
                            .buttonStyle(RoundedButtonStyle(
                                width: 100,
                                height: 45,
                                color: Color.main,
                                action: {
                                    let components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
                                    let date = Calendar.current.date(from: components)!
                                    controller.addPresence(date: date)
                                    isShowingSheet.toggle()
                                }))
                            .padding()
                        }
                    }
                })
                .padding()
            }) {
                Chart {
                    ForEach(0..<controller.month.count, id: \.self) { day in
                        BarMark(x: .value("Day", controller.month[day].name),
                                y: .value("Count", controller.month[day].count))
                    }
                }
                .chartYScale(domain: 0...controller.highestCount)
            }
            .groupBoxStyle(WorkoutBoxStyle())
            .padding()
            .cornerRadius(15)
        }
        .groupBoxStyle(WorkoutBoxStyle(color: Color.white))
        .background(Color.white)
        .cornerRadius(15)
        .padding()
    }
}
