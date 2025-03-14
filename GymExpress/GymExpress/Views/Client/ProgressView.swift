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
    private let controller = ClientProgressController.shared
    
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
    @State private var selectedObjective: Int = -1
    @State private var selectedObjectiveEdit: Int = -1
    @State var error = ""
    @State private var sheetCreated: Bool = false
    
    @FocusState private var isFocused: Bool /// Signifie que le Textfield pour créer un objectif a le focus
    @FocusState private var isFocusedInitial: Bool /// Signifie que le Textfield pour la valeur initial a le focus
    @FocusState private var isFocusedMax: Bool /// Signifie que le Textfield pour la valeur max a le focus
    @FocusState private var isFocusedNewData: Bool /// Signifie que le Textfield pour la nouvelle valeur a le focus
    
    var body: some View {
        
        HStack {
            Button(action: {}) {
                Text("Ajouter un objectif")
            }
            .buttonStyle(RoundedButtonStyle(
                width: 125,
                height: 40,
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
                            
                            HStack {
                                Button(action: {}) {
                                    Text("Créer")
                                }
                                .buttonStyle(RoundedButtonStyle(
                                    width: 75,
                                    height: 30,
                                    action: {
                                        
                                        isShowingSheet.toggle()
                                        controller.addObjective(newObjective, selectedStartDate, selectedEndDate, initialValue, maxValue)
                                    }
                                ))
                                Button(action: {}) {
                                    Text("Annuler")
                                }
                                .buttonStyle(RoundedButtonStyle(
                                    width: 75,
                                    height: 30,
                                    color: .red.opacity(0.8),
                                    hoveringColor: .red,
                                    action: {
                                        maxValue = ""
                                        initialValue = ""
                                        newObjective = ""
                                        selectedEndDate = Date()
                                        selectedStartDate = Date()
                                        isShowingSheet.toggle()
                                    }
                                ))
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 20)
        
        GroupBox {
            List {
                ForEach(controller.objectives, id: \.self) {index in
                    
                    HStack {
                        Text(index.objective)
                            .font(.system(size: 12, weight: .semibold))
                        if !error.isEmpty {
                            Text("Donnée non enregistrer : \(error)")
                        }
                        Spacer()
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(RoundedButtonStyle(width: 30, height: 30, action: {
                                selectedObjectiveEdit = index.dbId
                                
                            }))
                            .onChange(of: selectedObjectiveEdit) {
                                if selectedObjectiveEdit != -1 {
                                    if !isShowingSheetData {
                                        isShowingSheetData = true
                                    }
                                }
                            }
                            
                            .onChange(of: isShowingSheetData) {
                                if !isShowingSheetData {
                                    selectedObjectiveEdit = -1
                                }
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: Color.red, hoveringColor: Color.red.opacity(0.8), action: {
                                selectedObjective = index.dbId
                            }))
                            .onChange(of: selectedObjective) {
                                if selectedObjective == index.dbId {
                                    isShowingSheetConfirmation = true
                                }
                            }
                            .onChange(of: isShowingSheetConfirmation) {
                                if selectedObjective == index.dbId {
                                    if !isShowingSheetConfirmation {
                                        selectedObjective = -1
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .background(.gray)
                    
                    
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
                    .frame(minHeight: 100)
                    .chartYScale(domain: index.initValue...index.maxValue)
                    .chartXScale(domain: index.startDate...index.endDate)
                    .foregroundStyle(.main)
                    .background(.white)
                    .padding()
                }
            }
            .sheet(isPresented: $isShowingSheetConfirmation) {
                ConfirmationSheet(
                    title: "Suppression",
                    message: "Êtes-vous sûr de vouloir supprimer l'objectif \(controller.objectives.first(where: { $0.dbId == selectedObjective })?.objective ?? "") ?",
                    cancelAction: {
                        isShowingSheetConfirmation = false
                    },
                    confirmAction: {
                        controller.deleteObjective(selectedObjective)
                        isShowingSheetConfirmation = false
                        
                    }
                )
            }
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
                    HStack {
                        Button(action: {}) {
                            Text("Annuler")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 75,
                            height: 30,
                            color: .red.opacity(0.8),
                            hoveringColor: .red,
                            action: {
                                newValue = ""
                                dateValue = Date()
                                isShowingSheetData = false
                            }))
                        
                        Button(action: {}) {
                            Text("Ajouter")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 75,
                            height: 30,
                            action: {
                                isShowingSheetData = false
                                let success = controller.addData(objectiveId: selectedObjectiveEdit, value: Int(newValue) ?? 0, date: dateValue)
                                if !success {
                                    error = "Les données entrer ne sont pas valides"
                                } else {
                                    error = ""
                                }
                                selectedObjectiveEdit = -1
                            }
                        ))
                    }
                    
                }
                .padding(.all, 20)
            }
        }
        .cornerRadius(15)
        .padding()
    }
}

