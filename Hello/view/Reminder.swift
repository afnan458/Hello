//
//  Reminder.swift
//  Hello
//
//  Created by Afnan hassan on 01/05/1447 AH.
//

import SwiftUI

// MARK: - 1. Model (النموذج)
struct Plant: Identifiable {
    let id = UUID()
    var name: String
    var room: String // تم تغييرها من location إلى room
    var lightRequirement: String
    var waterAmount: String
    var needsWatering: Bool // تمثل ما إذا كانت بحاجة للري (false تعني تم الري)
}

// بيانات وهمية للنباتات
let mockPlants: [Plant] = [
    Plant(name: "Monstera", room: "Kitchen", lightRequirement: "Full sun", waterAmount: "20-50 ml", needsWatering: true),
    Plant(name: "Pothos", room: "Bedroom", lightRequirement: "Full sun", waterAmount: "20-50 ml", needsWatering: false),
    Plant(name: "Orchid", room: "Living Room", lightRequirement: "Full sun", waterAmount: "20-50 ml", needsWatering: false),
    Plant(name: "Spider", room: "Kitchen", lightRequirement: "Full sun", waterAmount: "20-50 ml", needsWatering: true)
]

// MARK: - 2. Plant List Item View (الكود المُعدَّل)
struct PlantListItemView: View {
    @Binding var plant: Plant
    // isWatered هي معكوس needsWatering لسهولة القراءة
    var isWatered: Bool { !plant.needsWatering }

    var body: some View {
        VStack(spacing: 0) { // لدمج الصف مع الخط الفاصل
            HStack(alignment: .top) {
                // Checkbox/Status Icon
                Button {
                    withAnimation {
                        plant.needsWatering.toggle() // تبديل حالة الحاجة للري
                    }
                } label: {
                    Image(systemName: isWatered ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isWatered ? Color("green00") : .secondaryTextColor)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 8)

                VStack(alignment: .leading, spacing: 4) {
                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane.fill").font(.caption)
                        Text("in \(plant.room)").font(.caption)
                    }
                    .foregroundColor(.secondaryTextColor)
                    .padding(.bottom, 4) // مسافة تحت الموقع

                    // Plant Name
                    HStack{
                        Text(plant.name)
                            .font(.title2)
                            .fontWeight(.regular)
                            .foregroundColor(isWatered ? .secondaryTextColor : .white)
                        
                        TextField("", text: $plant.name, prompt: Text("Pothes").foregroundStyle(.white.opacity(0.35)))
                    }
                    
                    // Details Row (Full sun & Water amount Badges)
                    HStack(spacing: 10) {
                        // 1. Full Sun Badge
                        HStack(spacing: 4) {
                            Image(systemName: "sun.max.fill")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#CCC785"))
                            Text(plant.lightRequirement)
                                .font(.caption)
                                .foregroundColor(Color(hex: "#CCC785"))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.badgeBackground)
                        .cornerRadius(6)
                        
                        // 2. Water Amount Badge
                        HStack(spacing: 4) {
                            Image(systemName: "drop.fill")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#CAF3FB"))
                            Text(plant.waterAmount)
                                .font(.caption)
                                .foregroundColor(Color(hex: "#CAF3FB"))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.badgeBackground)
                        .cornerRadius(6)
                    }
                    .opacity(isWatered ? 0.4 : 1.0)
                    .padding(.top, 2)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
            // الخط الفاصل الخفيف (Divider)
            Divider()
                .background(Color.lightDivider)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets()) // لإزالة التباعد الداخلي الافتراضي للقائمة
    }
}

// MARK: - 3. MyPlants View (الصفحة الرئيسية)
struct MyPlants: View {
    @State private var plants: [Plant] = mockPlants
    @State private var showingReminderSheet = false
    @State private var selectedPlant: Plant?
    
    // Logic: عدد النباتات التي تم ريّها (needsWatering = false)
    var plantsWateredCount: Int {
        plants.filter { !($0.needsWatering) }.count
    }
    
    // Logic: عدد النباتات التي تحتاج إلى ري (needsWatering = true)
    var plantsNeedingWaterCount: Int {
        plants.filter { $0.needsWatering }.count
    }

    var totalPlantsCount: Int { plants.count }
    
    var completionRatio: Double {
        totalPlantsCount > 0 ? Double(plantsWateredCount) / Double(totalPlantsCount) : 0
    }
    
    var body: some View {
        // تم تبديل NavigationView بـ ZStack لتحكم أفضل في التصميم الداكن
        ZStack(alignment: .bottomTrailing) {
            Color.ultraDarkBackground.edgesIgnoringSafeArea(.all)

            List {
                // Header Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("My Plants 🌱")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // الرسالة العلوية الديناميكية
                    Group {
                        if plantsNeedingWaterCount > 0 {
                            HStack {
                                Spacer()
                                Text("\(plantsWateredCount) of your plants are waiting for a sip 💧")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        } else {
                            HStack {
                                Spacer()
                                Text("\(plantsWateredCount) of your plants feel loved today ✨")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding(.bottom, 5)

                    // شريط الإنجاز (Progress Bar)
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.secondaryTextColor.opacity(0.3))
                                .frame(height: 3)

                            Capsule()
                                .fill(Color("green00"))
                                .frame(width: geometry.size.width * CGFloat(completionRatio), height: 3)
                                .animation(.easeInOut(duration: 0.5), value: completionRatio)
                        }
                    }
                    .frame(height: 3)
                    .padding(.vertical, 10)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                // List Items
                ForEach($plants) { $plant in
                    PlantListItemView(plant: $plant)
                        .onTapGesture {
                            selectedPlant = plant
                            showingReminderSheet = true
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            
            // زر الإضافة
            Button(action: {
                selectedPlant = nil
                showingReminderSheet = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color("green00"))
                    .background(Color.ultraDarkBackground)
                    .clipShape(Circle())
            }
            .padding(.bottom, 20)
            .padding(.trailing, 20)
        }
        // استخدم sheet مع isPresented لتمرير Binding<Plant?> إلى sheetR
        .sheet(isPresented: $showingReminderSheet) {
            sheetR(plant: $selectedPlant)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MyPlants()
        .preferredColorScheme(.dark)
}
