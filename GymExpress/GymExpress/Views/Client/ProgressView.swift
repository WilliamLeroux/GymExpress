//
//  ProgressView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI
import Charts
import Combine

struct ProgressView: View {
    private var objectives: [Objective] = [Objective(
        objective: "objectif 1", initValue: 0, valueList: [ObjectiveData(value: 1, year: 2025, month: 2, day: 10), ObjectiveData(value: 2, year: 2025, month: 2, day: 12), ObjectiveData(value: 3, year: 2025, month: 2, day: 20)], maxValue: 50, yearStart: 2025, monthStart: 1, dayStart: 1, yearEnd: 2025, monthEnd: 6, dayEnd: 25),
                                           Objective(objective: "objectif 2", initValue: 2, valueList: [ObjectiveData(value: 10, year: 2025, month: 2, day: 10), ObjectiveData(value: 20, year: 2025, month: 2, day: 11)], maxValue: 20, yearStart: 2025, monthStart: 1, dayStart: 1, yearEnd: 2025, monthEnd: 4, dayEnd: 10),
                                           Objective(objective: "objectif 3", initValue: 2, valueList: [ObjectiveData(value: 10, year: 2025, month: 2, day: 20), ObjectiveData(value: 20, year: 2025, month: 3, day: 10), ObjectiveData(value: 30, year: 2025, month: 3, day: 20)], maxValue: 100, yearStart: 2025, monthStart: 1, dayStart: 1, yearEnd: 2026, monthEnd: 1, dayEnd: 1)
    ]
    @State private var isShowingSheet: Bool = false /// Signifie si la sheet pour l'ajout d'un objectif est affiché
    @State private var isShowingSheetData: Bool = false /// Signifie si la sheet pour l'ajout de donnée à un objectif est affiché
    @State private var isShowingSheetConfirmation: Bool = false /// Signifie si la sheet de confirmation pour la suppression est affiché
    @State private var newObjective: String = "" /// Nom pour un nouvel objectif
    @State private var selectedStartDate: Date = Date() /// Date de début pour l'objectif
    @State private var selectedEndDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())! //// Date de fin pour l'objectif
    @State private var initialValue: String = "" /// Valeur initiale du nouvel objectif
    @State private var maxValue: String = "" /// Valeur maximal du nouvel objectif
    @State private var newValue: String = "" /// Nouvelle donnée pour l'objectif sélectionné
    @State private var dateValue: Date = Date() /// Date de la nouvelle donnée
    
    @FocusState private var isFocused: Bool /// Signifie que le Textfield pour créer un objectif a le focus
    @FocusState private var isFocusedInitial: Bool /// Signifie que le Textfield pour la valeur initial a le focus
    @FocusState private var isFocusedMax: Bool /// Signifie que le Textfield pour la valeur max a le focus
    @FocusState private var isFocusedNewData: Bool /// Signifie que le Textfield pour la nouvelle valeur a le focus
    
    var body: some View {
        GroupBox {
            LazyVStack {
                HStack {
                    Button(action: {}) {
                        Text("Ajouter")
                    }
                    .buttonStyle(RoundedButtonStyle(
                        width: 75,
                        height: 30,
                        action: {
                            isShowingSheet.toggle()
                        }
                    ))
                    .sheet(isPresented: $isShowingSheet) {
                        VStack {
                            Text("Ajouter un objectif")
                                .font(.system(size: 18, weight: .semibold))
                                .padding()
                            GroupBox{
                                VStack {
                                    TextFieldStyle(title: "Nom de l'objectif", text: $newObjective, isTyping: $isFocused)
                                    VStack {
                                        DatePicker(
                                            "Date de début",
                                            selection: $selectedStartDate,
                                            in: DateUtils.shared.getDateRange(),
                                            displayedComponents: [.date]
                                        )
                                        .datePickerStyle(.stepperField)
                                        
                                        DatePicker(
                                            "Date de fin",
                                            selection: $selectedEndDate,
                                            in: DateUtils.shared.getDateRange(),
                                            displayedComponents: [.date]
                                        )
                                        .datePickerStyle(.stepperField)
                                        HStack {
                                            TextFieldStyle(title: "Valeur de base", text: $initialValue, isTyping: $isFocusedInitial)
                                            
                                            TextFieldStyle(title: "Objectif", text: $maxValue, isTyping: $isFocusedMax)
                                        }
                                    }
                                    Button(action: {}) {
                                        Text("Créer")
                                    }
                                    .buttonStyle(RoundedButtonStyle(
                                        width: 75,
                                        height: 30,
                                        action: {
                                            isShowingSheet.toggle()
                                        }
                                    ))
                                }
                                .padding()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                ForEach(objectives, id: \.self) {index in
                    HStack {
                        Text(index.objective)
                            .font(.system(size: 12, weight: .semibold))
                        Spacer()
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(RoundedButtonStyle(width: 30, height: 30, action: {
                                isShowingSheetData.toggle()
                            }))
                            .sheet(isPresented: $isShowingSheetData) {
                                VStack {
                                    Text("Ajout de donnée")
                                        .font(.title)
                                    TextFieldStyle(title: "Donnée (ex. 10)", text: $newValue, isTyping: $isFocusedNewData)
                                    DatePicker(
                                        "Date",
                                        selection: $dateValue,
                                        in: DateUtils.shared.getDateRange(),
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(.stepperField)
                                    
                                    Button(action: {}) {
                                        Text("Ajouter")
                                    }
                                    .buttonStyle(RoundedButtonStyle(
                                        width: 75,
                                        height: 30,
                                        action: {
                                            isShowingSheetData.toggle() // Ajouter ajout
                                        }
                                    ))
                                }
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: Color.red, hoveringColor: Color.red.opacity(0.8), action: {
                                isShowingSheetConfirmation.toggle()
                            }))
                            .sheet(isPresented: $isShowingSheetConfirmation) {
                                ConfirmationSheet(
                                    title: "Suppression",
                                    message: "Êtes-vous sûr de vouloir supprimer l'objectif \(index.objective) ?",
                                    cancelAction: {
                                        isShowingSheetConfirmation.toggle()
                                    },
                                    confirmAction: {
                                        isShowingSheetConfirmation.toggle()
                                        // Ajouter la suppression
                                    })
                            }
                        }
                        
                    }
                    
                    
                    Chart(index.valueList) {
                        LineMark(
                            x: .value("Date", $0.date ?? Date()),
                            y: .value("Valeur", $0.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .lineStyle(.init(lineWidth: 2))
                        .symbol {
                            Circle()
                                .fill(.main)
                                .frame(width: 8, height: 8)
                        }
                        
                    }
                    .chartYScale(domain: index.initValue...index.maxValue)
                    .chartXScale(domain: index.startDate...index.endDate)
                    .foregroundStyle(.main)
                    .background(.white)
                    .padding()
                    
                    if index != objectives.last! {
                        Divider()
                    }
                    
                }
            }
        }
        .cornerRadius(15)
        .padding()
    }
}

#Preview {
    RootNavigation()
}
