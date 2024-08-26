//
//  MainGameView.swift
//  The Knight and the Dragon
//
//  Created by Sergio Mascarpone on 19.08.24.
//
import SwiftUI

struct MainGameView: View {
    @State private var showSettings = false
    @State private var showInfo = false
    @State private var showDragonGame = false
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Image("backgroundLoaderImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Верхняя панель с кнопками и балансом
                HStack {
                    // Кнопки настроек и информации
                    HStack {
                        Button(action: {
                            showSettings.toggle()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.red)
                                .cornerRadius(5)
                        }
                        
                        Button(action: {
                            showInfo.toggle()
                        }) {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.red)
                                .cornerRadius(5)
                        }
                    }
                    .padding(50)
                    .padding(.horizontal, -44)
                    
                    Spacer()
                    
                    // Баланс монет в верхнем правом углу
                    Text("Coins: \(gameState.coins)")
                        .font(.custom("BigShouldersStencilDisplay-Bold", size: 18))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .cornerRadius(22)
                }
                
                Spacer()
                // Две центральные кнопки по горизонтали
                HStack(spacing: 40) {
                    // Первая кнопка по центру экрана
                    Button(action: {
                        showDragonGame.toggle()
                    }) {
                        VStack {
                            Image("Dragon")
                                .resizable()
                                .frame(width: 66, height: 66)
                            
                            Text("DRAGON MOUTH")
                                .font(.custom("BigShouldersStencilDisplay-Bold", size: 18))
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(5)
                    }
                    
                    // Вторая кнопка
                    Button(action: {
                        // Действие второй кнопки
                    }) {
                        VStack {
                            Image("Knight")
                                .resizable()
                                .frame(width: 66, height: 66)
                            
                            Text("KNIGHT'S SECRET")
                                .font(.custom("BigShouldersStencilDisplay-Bold", size: 18))
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(5)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showInfo) {
            InfoView()
        }
        .sheet(isPresented: $showDragonGame) {
            DragonGameView()
        }
    }
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
            .environmentObject(GameState())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
