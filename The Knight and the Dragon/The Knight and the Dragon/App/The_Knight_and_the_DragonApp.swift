//
//  The_Knight_and_the_DragonApp.swift
//  The Knight and the Dragon
//
//  Created by Sergio Mascarpone on 19.08.24.
//
import SwiftUI

@main
struct TheKnightAndDragonApp: App {
    @StateObject private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            LoaderView()
                .environmentObject(gameState)
        }
    }
}
