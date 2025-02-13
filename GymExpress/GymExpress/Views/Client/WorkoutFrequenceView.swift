//
//  WorkoutFrequenceView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI
import Charts

struct WorkoutFrequenceView: View {
    @State private var selectedIndex: Int? = nil /// Index jour sélectionné
    @State private var isShowingSheet: Bool = false /// Signifie que la sheet d'enregistrement de présence est affiché
    @State private var weekList : [String] = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"] // Changer pour le model
    let data = [Week(day: "Lundi", count: 3),
                Week(day: "Mardi", count: 1),
                Week(day: "Mercredi", count: 0),
                Week(day: "Jeudi", count: 3),
                Week(day: "Vendredi", count: 3),
                Week(day: "Samedi", count: 2),
                Week(day: "Dimanche", count: 0)]
    
    var body: some View {
        GroupBox {
            GroupBox(label:
                        HStack{
                Text("Mois")
                Button(action: {}) {
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
                
                Button(action: {}) {
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
                                ForEach(0..<weekList.count, id: \.self) { day in
                                    Button(action: {selectedIndex = day}) {
                                        Text(weekList[day])
                                            .frame(width: 75, height: 50)
                                    }
                                    .onHover { hovering in
                                        if (hovering){
                                            NSCursor.pointingHand.push()
                                        }
                                        else {
                                            NSCursor.pop()
                                        }
                                    }
                                    .border(selectedIndex == day ? Color.green : Color.gray, width: selectedIndex == day ? 2 : 1)
                                    
                                }
                            }
                        }
                        .frame(width: 800, height: 200)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(15)
                        
                        HStack {
                            Button(action: {}) {
                                Text("Retour")
                            }
                            .buttonStyle(RoundedButtonStyle(
                                width: 75,
                                height: 45,
                                color: Color.main,
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
                                    isShowingSheet.toggle()
                                }))
                            .padding()
                        }
                    }
                })
                .padding()
            }) {
                Chart {
                    ForEach(data) {dataPoint in
                        BarMark(x: .value("Day", dataPoint.day),
                                y: .value("Count", dataPoint.count))
                    }
                }
                .chartYScale(domain: 0...4)
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
