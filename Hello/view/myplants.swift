//
//  myplants.swift
//  Hello
//
//  Created by Afnan hassan on 01/05/1447 AH.
//

import SwiftUI
struct myplants: View {
    @State private var showingReminderSheet = false
    
    var body: some View {
        
        Color.black.ignoresSafeArea(.all) // الخلفية السوداء الفاحمة
        
        .overlay(
            ZStack {
                // تأثير الزجاج الرخو (Lcoid Glass) - يبقى هنا إذا كنت تريده
                Rectangle().fill(.ultraThinMaterial).edgesIgnoringSafeArea(.all)

                VStack {
                    
                    // العنوان والخط
                    VStack(spacing: 10) {
                        HStack {
                            Text("My Plants 🌱").font(.title).fontWeight(.bold).foregroundColor(.white)
                            Spacer()
                        }
                        Rectangle().frame(height: 1).foregroundColor(.white.opacity(0.5)).padding(.top, 5)
                    }
                    .padding(.horizontal).padding(.top, 60)
                    
                    Spacer()
                    
                    // مكان وضع صورتك
                    Image("plant1") // <--- استبدل "MyPlantImage" باسم ملف صورتك
                        .resizable().scaledToFit().frame(width: 180, height: 180)
                    
                    Text("Start your plant journey!").font(.title).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
                    Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                        .font(.body).multilineTextAlignment(.center).foregroundColor(.secondary).padding(.horizontal, 30).padding(.top, 5)

                    Spacer()
                    Spacer()

                    // الزر
                    Button(action: {
                        showingReminderSheet = true
                    }) {
                        Text("Set Plant Reminder").font(.headline).fontWeight(.semibold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30).fill(Color.mint).shadow(color: .mint.opacity(0.5), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.horizontal, 30).padding(.bottom, 60)
                }
            }
        )
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showingReminderSheet) {
            MyPlants()
        }
    }
}

#Preview {
    myplants()
}
