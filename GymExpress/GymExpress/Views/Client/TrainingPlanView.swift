//
//  TrainingPlanView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    let onTap: () -> Void
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let userAgent = webView.customUserAgent
        let tapGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        
        webView.enclosingScrollView?.hasVerticalScroller = false
        webView.enclosingScrollView?.hasHorizontalScroller = false
        
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        webView.customUserAgent = userAgent
        
        webView.load(URLRequest(url: url))
        
        webView.addGestureRecognizer(tapGesture)
        
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
            return Coordinator(onTap: onTap)
        }

        class Coordinator: NSObject {
            let onTap: () -> Void
            
            init(onTap: @escaping () -> Void) {
                self.onTap = onTap
            }
            
            @objc func handleTap(_ gesture: NSGestureRecognizer) {
                onTap()
            }
        }
}

struct TrainingPlanView: View {
    @State private var workoutList: [String] = ["1", "2", "3"] // Changer pour la vraie liste
    @State private var exerciceList: [String] = ["4", "5", "6"] // Changer pour la vraie liste
    @State private var isShowingSheet: Bool = false /// Signifie que la sheet d'un entraînement est affiché
    @State private var selectedWorkout: String? /// Entraînement sélectionné
    
    var body: some View {
        GroupBox() {
            List {
                ForEach(workoutList, id: \.self) { workout in
                    GroupBox(label: Text(workout)) {
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(exerciceList, id: \.self) { exercice in
                                    WebView(url: URL(string: "https://cdn-exercisedb.vercel.app/api/v1/images/guT8YnS.gif")!) {
                                        selectedWorkout = exercice
                                    }
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .cornerRadius(15)
                                        .onChange(of: selectedWorkout) {
                                            if selectedWorkout != "" {
                                                isShowingSheet.toggle()
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .groupBoxStyle(WorkoutBoxStyle())
                }
            }
            .cornerRadius(15)
            .padding()
        }
        .sheet(isPresented: $isShowingSheet) {
            VStack {
                Text(selectedWorkout ?? "Aucun exercice sélectionné")
                    .font(.title)
                    .padding(50)
                WebView(url: URL(string: "https://cdn-exercisedb.vercel.app/api/v1/images/guT8YnS.gif")!) {}
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                VStack{
                    Grid {
                        GridRow {
                            Text("Séries:")
                            Text("Répétitions:")
                        }
                        
                        GridRow{
                            Text("Charge:")
                            Text("Repo:")
                        }
                        
                        GridRow{
                            Text("Description:")
                            Text("Notes:")
                        }
                    }
                }
                .frame(width: 300, height: 200)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(15)
                
                Button(action: {}) {
                    Text("Retour")
                }
                .buttonStyle(RoundedButtonStyle(
                    width: 75,
                    height: 50,
                    color: Color.main,
                    action: {
                        selectedWorkout = ""
                        isShowingSheet.toggle()
                    }))
                .padding()
            }
            .frame(width: 500, height: 500)
        }
    }
}
