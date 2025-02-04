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
    private let objectives: [Objective] = [Objective(
        objective: "objectif 1", initValue: 0, valueList: [ObjectiveData(value: 1, year: 2025, month: 2, day: 10), ObjectiveData(value: 2, year: 2025, month: 2, day: 12), ObjectiveData(value: 3, year: 2025, month: 2, day: 20)], maxValue: 50, yearStart: 2025, monthStart: 1, dayStart: 1, yearEnd: 2025, monthEnd: 6, dayEnd: 25),
                                           Objective(objective: "objectif 2", initValue: 2, valueList: [ObjectiveData(value: 10, year: 2025, month: 2, day: 10), ObjectiveData(value: 20, year: 2025, month: 2, day: 11)], maxValue: 20, yearStart: 2025, monthStart: 1, dayStart: 1, yearEnd: 2025, monthEnd: 4, dayEnd: 10),
                                           Objective(objective: "objectif 3", initValue: 2, valueList: [ObjectiveData(value: 10, year: 2025, month: 2, day: 20), ObjectiveData(value: 20, year: 2025, month: 3, day: 10), ObjectiveData(value: 30, year: 2025, month: 3, day: 20)], maxValue: 100, yearStart: 2025, monthStart: 1, dayStart: 1, yearEnd: 2026, monthEnd: 1, dayEnd: 1)
    ]
    @State private var isShowingSheet: Bool = false
    @State private var newObjective: String = ""
    @State private var selectedStartDate: Date = Date()
    @State private var selectedEndDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    @FocusState private var isFocused: Bool
    
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
                            GroupBox{
                                VStack {
                                    TextFieldStyle(title: "Objectif", text: $newObjective, isTyping: $isFocused)
                                    HStack {
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
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                ForEach(objectives, id: \.self) {index in
                    Text(index.objective)
                        .font(.system(size: 12, weight: .semibold))
                    Chart(index.valueList) {
                        LineMark(
                            x: .value("Date", $0.date),
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
struct Objective: Identifiable, Equatable, Hashable {
    let objective: String
    let initValue: Int
    let valueList: [ObjectiveData]
    let maxValue: Int
    let startDate: Date
    let endDate: Date

    init(objective: String, initValue: Int, valueList: [ObjectiveData], maxValue: Int, yearStart: Int, monthStart: Int, dayStart: Int, yearEnd: Int, monthEnd: Int, dayEnd: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.startDate = calendar.date(from: DateComponents(year: yearStart, month: monthStart, day: dayStart))!
        self.endDate = calendar.date(from: DateComponents(year: yearEnd, month: monthEnd, day: dayEnd))!
        self.objective = objective
        self.initValue = initValue
        self.valueList = valueList
        self.maxValue = maxValue
    }
    
    var id: String { return objective }
}

struct ObjectiveData: Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    var value: Int
    var date: Date
    
    init(value: Int, year: Int, month: Int, day: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        self.value = value
    }
}

#Preview {
    RootNavigation()
}
