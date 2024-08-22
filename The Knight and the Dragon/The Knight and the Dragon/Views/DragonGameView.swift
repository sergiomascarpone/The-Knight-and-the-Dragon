//
//  DragonGameView.swift
//  The Knight and the Dragon
//
//  Created by Sergio Mascarpone on 20.08.24.
//
import SwiftUI

// Структура для хранения координат ячеек
struct Cell: Hashable {
    let row: Int
    let column: Int
}

struct DragonGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameState: GameState
    
    @State private var currentStep: Int = 1
    @State private var selectedBet: Int? = nil
    @State private var minefield: [[Bool]] = []
    @State private var gameOver: Bool = false
    @State private var win: Bool = false
    @State private var currentMultiplier: Double = 1.0
    @State private var totalBet: Int = 0
    @State private var openedCells: Set<Cell> = Set()
    private var numberOfMines: Int = 6 // Количество мин на поле
    
    var body: some View {
        ZStack {
            Image("dragonGame")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Верхняя панель с кнопкой "Назад" и балансом монет
                HStack {
                    // Кнопка "Назад" в левом верхнем углу
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "multiply.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(5)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Баланс монет в правом верхнем углу
                    VStack {
                        Text("Coins: \(gameState.coins)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .cornerRadius(22)
                        if currentStep >= 3 {
                            Text("BANK: \(totalBet)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.red)
                                .cornerRadius(22)
                        }
                    }
                }
                
                Spacer()
                
                if gameOver {
                    // Сообщение "YOU LOSE!" или "YOU WIN!" и кнопка "GO TO MENU"
                    VStack {
                        Text(win ? "YOU WIN!" : "YOU LOSE!")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        
                        if win {
                            Text("Win: \(totalBet)")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Button(action: {
                            // Добавляем выигрыш на баланс и возвращаемся в меню
                            if win {
                                gameState.addCoins(totalBet)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("GO TO MENU")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 40)
                                .background(Color.red)
                                .cornerRadius(5)
                        }
                        .padding(.bottom, 30)
                    }
                } else if currentStep == 1 {
                    // Первый текст
                    Text("WELCOME TO DRAGON MOUTH")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.4))
                        .padding()
                    
                } else if currentStep == 2 {
                    // Выбор ставки
                    VStack {
                        HStack(spacing: 20) {
                            ForEach(0..<4) { index in
                                Button(action: {
                                    selectedBet = 350 + index * 50
                                    totalBet = selectedBet!
                                    withAnimation {
                                        currentStep = 3
                                        generateMinefield() // Генерация минного поля
                                    }
                                }) {
                                    VStack {
                                        Text("\(350 + index * 50)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(5)
                                }
                            }
                        }
                        .padding()
                    }
                    
                } else if currentStep == 3 {
                    // Показ 16 ячеек с множителями
                    VStack {
                        // Создание множителей и ячеек
                        VStack {
                            ForEach(0..<4) { index in
                                HStack {
                                    Text("X \(1.0 - Double(index) * 0.25, specifier: "%.2f")")
                                        .bold()
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.leading, 20)
                                    
                                    ForEach(0..<4) { cellIndex in
                                        Button(action: {
                                            handleCellSelection(row: index, column: cellIndex)
                                        }) {
                                            ZStack {
                                                if openedCells.contains(Cell(row: index, column: cellIndex)) {
                                                    // Показываем изображение мины или пустой ячейки
                                                    Image(minefield[index][cellIndex] ? "Sword" : "Chest")
                                                        .resizable()
                                                        .frame(width: 40, height: 40)
                                                        .cornerRadius(5)
                                                } else {
                                                    // Показываем закрытую ячейку
                                                    Image("lockGame")
                                                        .resizable()
                                                        .frame(width: 40, height: 40)
                                                        .cornerRadius(5)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.4))
                    }
                }
                
                Spacer()
                
                // Кнопка "CONTINUE" внизу по центру
                if !gameOver && currentStep != 3 {
                    Button(action: {
                        if currentStep == 1 {
                            withAnimation {
                                currentStep = 2
                            }
                        } else if currentStep == 2 {
                            withAnimation {
                                currentStep = 2
                            }
                            generateMinefield() // Генерация минного поля
                        }
                    }) {
                        Text("CONTINUE")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 40)
                            .background(Color.red)
                            .cornerRadius(5)
                    }
                    .padding(.bottom, 30)
                }
            }
            .padding(.top, 40)
        }
    }
    
    private func generateMinefield() {
        // Генерация случайного минного поля
        let rows = 4
        let columns = 4
        var field = Array(repeating: Array(repeating: false, count: columns), count: rows)
        
        var placedMines = 0
        while placedMines < numberOfMines {
            let randomRow = Int.random(in: 0..<rows)
            let randomColumn = Int.random(in: 0..<columns)
            
            if !field[randomRow][randomColumn] {
                field[randomRow][randomColumn] = true
                placedMines += 1
            }
        }
        
        minefield = field
    }
    
    private func handleCellSelection(row: Int, column: Int) {
        if minefield[row][column] {
            // Попадание на мину
            gameOver = true
            win = false
            totalBet = 0
        } else {
            openedCells.insert(Cell(row: row, column: column))
            
            // Проверяем, открыты ли все ячейки
            let totalCells = minefield.count * minefield[0].count
            let numberOfCellsOpened = openedCells.count
            if numberOfCellsOpened == totalCells - numberOfMines {
                // Если открыто больше ячеек, чем мин
                gameOver = true
                win = true
                totalBet = Int(Double(selectedBet ?? 0) * currentMultiplier)
            } else {
                // Обновление ставки в зависимости от текущего множителя
                currentMultiplier = 1.0 - Double(row) * 0.25
                totalBet = Int(Double(selectedBet ?? 0) * currentMultiplier)
            }
        }
    }
}

struct DragonGameView_Previews: PreviewProvider {
    static var previews: some View {
        DragonGameView()
            .environmentObject(GameState()) // Добавляем объект состояния для предпросмотра
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
