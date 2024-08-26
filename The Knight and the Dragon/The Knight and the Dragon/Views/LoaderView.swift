//
//  ContentView.swift
//  The Knight and the Dragon
//
//  Created by Sergio Mascarpone on 19.08.24.
//

import SwiftUI

struct LoaderView: View {
    @State private var progress: Double = 0.0
    @State private var isLoadingComplete: Bool = false
    @State private var showStory: Bool = false
    @State private var showMainGameView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Задний фон с изображением на весь экран
                Image("backgroundLoaderImage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    if isLoadingComplete {
                        if showStory {
                            VStack {
                                Spacer()
                                
                                // Текст с историей по центру экрана
                                Text("WELCOME TO THE WORLD OF MEDIEVAL ENTERTAINMENT")
                                    .font(.custom("BigShouldersStencilDisplay-Bold", size: 40))
                                    .multilineTextAlignment(.center)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.4))
                                    .padding()
                                    .transition(.opacity) // Плавное появление текста
                                
                                Spacer()
                                
                                // Кнопка "Continue" после отображения истории
                                Button(action: {
                                    // Плавный переход на главный экран игры
                                    withAnimation {
                                        showMainGameView = true
                                    }
                                }) {
                                    Text("CONTINUE")
                                        .font(.custom("BigShouldersStencilDisplay-Bold", size: 26))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(height: 30)
                                        .background(Color.red)
                                        .cornerRadius(5)
                                }
                                .padding(.horizontal, 30)
                                .padding(.bottom, 30)
                            }
                            .transition(.opacity) // Плавное появление текста и кнопки
                        } else {
                            // Кнопка "Start" после завершения загрузки
                            Button(action: {
                                // Показать текст истории и изменить кнопку на "Continue"
                                withAnimation {
                                    showStory = true
                                }
                            }) {
                                Text("START")
                                    .font(.custom("BigShouldersStencilDisplay-Bold", size: 26))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(height: 30)
                                    .background(Color.red)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                        }
                    } else {
                        ZStack {
                            // Задний план для прогресс-бара
                            Rectangle()
                                .fill(Color.black.opacity(0.7))
                                .frame(height: 30)
                                .cornerRadius(5)
                            
                            // Линия загрузки
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: geometry.size.width * CGFloat(progress / 100), height: 30)
                                    .cornerRadius(5)
                            }
                            .frame(height: 30)
                            
                            // Текст с процентами в середине прогресс-бара
                            Text("\(Int(progress))%")
                                .font(.custom("BigShouldersStencilDisplay-Bold", size: 22))
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 30)
                    }
                }
            }
            .onAppear {
                startLoading()
            }
            .fullScreenCover(isPresented: $showMainGameView) {
                MainGameView()
                    // Плавный переход с затуханием 
                    .transition(.opacity)
            }
        }
    }
    
    // Функция для имитации загрузки
    private func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if self.progress < 100 {
                self.progress += 1
            } else {
                timer.invalidate()
                // После завершения загрузки отображаем кнопку "Start"
                withAnimation {
                    self.isLoadingComplete = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
            .environmentObject(GameState()) 
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
