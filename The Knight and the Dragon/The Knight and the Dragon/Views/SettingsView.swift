//
//  SettingsView.swift
//  The Knight and the Dragon
//
//  Created by Sergio Mascarpone on 20.08.24.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Image("backgroundLoaderImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Верхняя панель с кнопкой назад и балансом
                HStack {
                    // Кнопка назад
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
                    
                    // Баланс монет
                    Text("Coins: \(gameState.coins)")
                        .font(.custom("BigShouldersStencilDisplay-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .cornerRadius(22)
                }
                
                Spacer()
                
                // Заголовок "Настройки"
                Text("SETTINGS")
                    .font(.custom("BigShouldersStencilDisplay-Bold", size: 40))
                    .foregroundColor(.white)
                    .padding(2)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(5)
                
                Spacer()
                
                // Опции "Sounds", "Music", "Vibration"
                VStack(spacing: 20) {
                    Text("SOUNDS")
                        .font(.custom("BigShouldersStencilDisplay-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(height: 30)
                        .background(Color.red)
                        .cornerRadius(5)
                    
                    Text("MUSIC")
                        .font(.custom("BigShouldersStencilDisplay-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(35)
                        .frame(height: 30)
                        .background(Color.red)
                        .cornerRadius(5)
                    
                    Text("VIBRATION")
                        .font(.custom("BigShouldersStencilDisplay-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding()
                        .frame(height: 30)
                        .background(Color.red)
                        .cornerRadius(5)
                }
                .frame(maxWidth: 180)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GameState())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
