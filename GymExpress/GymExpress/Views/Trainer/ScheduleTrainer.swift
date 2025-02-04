//
//  ScheduleTrainer.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.

import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    var startDate: Date
    var endDate: Date
    var title: String
}

struct ScheduleTrainer: View {
    
    @State private var startOfWeek: Date = Date()
        
    let events: [Event] = [
        Event(startDate: dateFrom(3, 2, 2025, 9, 0), endDate: dateFrom(3, 2, 2025, 11, 0), title: "Entraînement"),
        Event(startDate: dateFrom(5, 2, 2025, 14, 0), endDate: dateFrom(5, 2, 2025, 15, 0), title: "Réunion")
    ]
    
    let hourHeight = 50.0
    let weekDays = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
    let monthNames = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
    
    var body: some View {
        
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(RoundedButtonStyle(width: 50, height: 50, color: Color.main, hoveringColor: Color.green, padding: 2, action: {
                changeWeek(by: -1)
            }))
            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<7) { index in
                        let day = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek)!
                        VStack(alignment: .center) {
                            VStack {
                                VStack {
                                    Text(day.formatted(
                                        .dateTime
                                            .year()
                                    ))
                                    
                                    Text(day.formatted(
                                        .dateTime
                                            .day(.twoDigits)
                                            .month(.wide)
                                            .locale(.init(identifier: "fr-CA"))
                                    ))
                                    .bold()
                                }
                                .font(.title)
                                
                                Text(weekDays[calendarWeekday(from: day) - 1])
                                
                            }
                            .frame(minWidth: 110, minHeight: 110)
                            .foregroundStyle(Calendar.current.isDate(day, inSameDayAs: Date()) ? .red : .black)
                            .background(Calendar.current.isDate(day, inSameDayAs: Date()) ? .red.opacity(0.1) : .clear)
                            .cornerRadius(16)
                            ZStack(alignment: .topLeading) {
                                VStack(alignment: .center, spacing: 0) {
                                    ForEach(6..<23) { hour in
                                        HStack {
                                            Text("\(hour)")
                                                .font(.caption)
                                                .frame(width: 20, alignment: .trailing)
                                            Color.gray
                                                .frame(height: 1)
                                                .padding(.trailing, 10)
                                        }
                                        .frame(height: hourHeight)
                                    }
                                }
                                
                                ForEach(events.filter { isEventOnDay($0, day) }) { event in
                                    eventCell(event)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                        
                        if index != 6 {
                            Divider()
                        }
                    }
                }
            }
            .padding(.vertical, 16)
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(RoundedButtonStyle(width: 50, height: 50, color: Color.main, hoveringColor: Color.green, padding: 2, action: {
                changeWeek(by: 1)
            }))
        }
        .onAppear {
            addKeyboardListener()
        }
        .onDisappear {
            removeKeyboardListener()
        }
    }
    
    func changeWeek(by value: Int) {
            startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: startOfWeek) ?? startOfWeek
        }
    
    func calendarDate(for index: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: index, to: startOfWeek) ?? Date()
    }
    
    func isEventOnDay(_ event: Event, _ day: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(event.startDate, inSameDayAs: day)
    }
    
    func eventCell(_ event: Event) -> some View {
        
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let height = duration / 60 / 60 * hourHeight
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: event.startDate)
        let minute = calendar.component(.minute, from: event.startDate)
        let offset = Double(hour - 7) * (hourHeight)
        
        return VStack(alignment: .leading) {
            Text("\(hour):\(minute < 10 ? "0\(minute)" : "\(minute)")")
            Text(event.title).bold()
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .frame(height: height, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.main).opacity(0.5)
        )
        .padding(.trailing, 40)
        .offset(x: 30, y: offset + 24)
        .onTapGesture {
            print("CLICK")
        }
    }

    func calendarWeekday(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: date)
    }
    
    func addKeyboardListener() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            switch event.keyCode {
            case 123: // Flèche gauche
                changeWeek(by: -1)
            case 124: // Flèche droite
                changeWeek(by: 1)
            default:
                break
            }
            return event
        }
    }
    
    func removeKeyboardListener() {
        NSEvent.removeMonitor(self)
    }
}

func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}
