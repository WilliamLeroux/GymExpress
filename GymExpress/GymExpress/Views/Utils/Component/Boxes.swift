//
//  Boxes.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

extension View {
    
    /// Crée une petite boite
    /// - Parameters:
    ///   - title: Titre de la boite, vide par défaut
    ///   - view: Contenu de la boite
    ///   - action: Action lors d'un clique, vide par défaut
    /// - Returns: GroupBox
    func smallBox(title: String = " ", borderColor: Color = .clear, view: some View, action: @escaping Action = {}) -> some View {
        return GroupBox(label: Text(title)) {
            view
                .frame(width: 200, height: 200)
        }
        .groupBoxStyle(ClearSmallBoxStyle())
        .modifier(HoverState())
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerSize: .init(width: 15, height: 15)).stroke(borderColor, lineWidth: 5))
        .onTapGesture {
            action()
        }
    }
    
    /// Crée une boite de taille médium
    /// - Parameters:
    ///   - title: Titre de la boite, vide par défaut
    ///   - view: Contenu de la boite
    ///   - action: Action lors d'un clique, vide par défaut
    /// - Returns: GroupBox
    func mediumBox(title: String = " ", view: some View, action: @escaping Action = {}) -> some View {
        return GroupBox(label: Text(title)) {
            view
                .frame(width: 416, height: 416)
        }
        .groupBoxStyle(ClearMediumBoxStyle())
        .modifier(HoverState())
        .cornerRadius(15)
        .onTapGesture {
            action()
        }
        
    }
    
    /// Crée une boite longue
    /// - Parameters:
    ///   - title: Titre de la boite, vide par défaut
    ///   - view: Contenu de la boite
    ///   - action: Action lors d'un clique, vide par défaut
    /// - Returns: GroupBox
    func longBox(title: String = " ", view: some View, action: @escaping Action = {}) -> some View {
        return GroupBox(label: Text(title)) {
            view
                .frame(width: 835, height: 200)
        }
        .groupBoxStyle(ClearLongBoxStyle())
        .modifier(HoverState())
        .cornerRadius(15)
        .onTapGesture {
            action()
        }
    }
}

/// Style des petites boites
struct ClearSmallBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            VStack{
                configuration.content // Contenu
            }
            .cornerRadius(10)
            
            configuration.label // Titre
                .font(.system(size: 12, weight: .bold))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.leading, 5)
                .frame(width: 200, alignment: .leading) // Même taille que la boite
                .frame(height: 200, alignment: .top) // Même taille que la boite
        }
    }
}

/// Style des boites medium
struct ClearMediumBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            VStack{
                configuration.content // Contenu
            }
            .cornerRadius(10)
            
            configuration.label // Titre
                .font(.system(size: 12, weight: .bold))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.leading, 5)
                .frame(width: 416, alignment: .leading) // Même taille que la boite
                .frame(height: 416, alignment: .top) // Même taille que la boite
        }
    }
}

/// Style des boites longues
struct ClearLongBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            VStack{
                configuration.content // Contenu
            }
            .cornerRadius(10)
            
            configuration.label // Titre
                .font(.system(size: 12, weight: .bold))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.leading, 5)
                .frame(width: 835, alignment: .leading) // Même taille que la boite
                .frame(height: 200, alignment: .top) // Même taille que la boite
        }
    }
}

/// Gérer l'effet de survol d'une view lorsqu'on passe au dessus avev la souris
struct HoverState: ViewModifier {
    @State private var isHovered = false
    
    func body(content: Content) -> some View {
        content
            .background(isHovered ? Color.main : Color.white)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }
    }
}

