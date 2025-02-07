//
//  AddEventSheetView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AddEventSheetView: View {
    
    @Binding var isPresented: Bool /// État de présentation de la vue
    @State private var startTime = Date() /// Heure de début de l'événement
    @State private var endTime = Date() /// Heure de fin de l'événement
    @State private var isRecurring = false /// Indique si l'événement est récurrent
    @State private var recurrenceType = "Toutes les semaines" /// Type de récurrence de l'événement
    
    let recurrenceOptions = ["Tous les jours", "Toutes les semaines", "Tous les mois"] /// Options de récurrence disponibles
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack{
                        Section(header: Text("Heure de l'événement").frame(maxWidth: .infinity, alignment: .center)) {
                            DatePicker("Début", selection: $startTime, displayedComponents: .hourAndMinute)
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .padding(.top, 2)
                            DatePicker("Fin", selection: $endTime, displayedComponents: .hourAndMinute)
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .padding(.top, 2)
                        }
                        .font(.title)
                        
                        Section(header: Text("").frame(maxWidth: .infinity, alignment: .center)) {
                            Toggle("Récurrent", isOn: $isRecurring)
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                            if isRecurring {
                                Picker("", selection: $recurrenceType) {
                                    ForEach(recurrenceOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: .infinity)
                                .font(.headline)
                            }
                        }
                        .padding(.top, 2)
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)

                HStack {
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Text("Annuler")
                            .font(.headline)
                    }
                    .buttonStyle(RoundedButtonStyle(width: 100, height: 40, action: {
                        isPresented = false
                    }))

                    Spacer()

                    Button(action: {
                        // Logique d'ajout de l'événement
                        isPresented = false
                    }) {
                        Text("Ajouter")
                            .font(.headline)
                    }
                    .buttonStyle(RoundedButtonStyle(width: 100, height: 40, action: {
                        isPresented = false
                    }))
                    
                    Spacer()

                }
                .frame(alignment: .center)
                .padding()
                .background(Color.clear)
            }
            .navigationTitle("Nouvel événement")
            .presentationDetents([.medium, .large])
            .padding(.all, 20)
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, minHeight: 350)
    }
}

struct AddEventSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventSheetView(isPresented: Binding.constant(true))
    }
}
