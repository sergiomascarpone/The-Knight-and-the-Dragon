//
//  GameState.swift
//  The Knight and the Dragon
//
//  Created by Sergio Mascarpone on 20.08.24.
//

import SwiftUI
import Combine

class GameState: ObservableObject {
    @Published var coins: Int = 1000 // Изначальное количество монет
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
}
