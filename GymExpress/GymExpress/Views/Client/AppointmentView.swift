//
//  AppointmentView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct AppointmentView: View {
    @State private var appointmentList: [String] = ["1", "2", "3", "4", "5"]
    @State private var descList: [String] = ["allo", "allo", "allo", "allo", "allo"]
    @State private var deleteAlert: Bool = false
    @State private var selectedIndex: Int = -1
    
    var body: some View {
        GroupBox {
            List {
                ForEach(0..<appointmentList.count, id: \.self) { appointment in
                    GroupBox(label: Text(appointmentList[appointment])) {
                        HStack {
                            Text(descList[appointment])
                            Spacer()
                            
                            HStack(spacing: 0){
                                Button(action: {}) {
                                    Image(systemName: "pencil")
                                }
                                .buttonStyle(RoundedButtonStyle(width: 30, height: 30))
                                
                                Button(action: {}) {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: Color.red, hoveringColor: Color.red.opacity(0.8), action: {
                                    selectedIndex = appointment
                                }))
                                
                            }
                        }
                        
                    }
                    .groupBoxStyle(WorkoutBoxStyle())
                }
            }
            .onChange(of: selectedIndex) {
                if selectedIndex != -1 {
                    deleteAlert = true
                }
            }
            .sheet(isPresented: $deleteAlert) { // Sheet confirmation pour annuler un rendez-vous
                VStack {
                    Text("Annulation")
                        .font(.title)
                    
                    Text("Voulez-vous vraiment annuler \(appointmentList[selectedIndex]) ?")
                    HStack {
                        Button(action: {}){
                            Text("Annuler")
                        }
                        .buttonStyle(RoundedButtonStyle(width: 75, height: 50, color: Color.main, hoveringColor: Color.green, action: {
                            selectedIndex = -1
                            deleteAlert = false
                        }))
                        
                        Button(action: {}){
                            Text("Confirmer")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 57,
                            height: 50,
                            color: Color.red,
                            hoveringColor: Color.red.opacity(0.8),
                            action: {
                                selectedIndex = -1
                                deleteAlert = false
                                // Ajouter la suppression
                            })
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    RootNavigation()
}
