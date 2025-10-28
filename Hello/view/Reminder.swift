//
//  Reminder.swift
//  Hello
//
//  Created by Afnan hassan on 01/05/1447 AH.
//

import SwiftUI

// MARK: - 1. Model (النموذج)
struct Plant: Identifiable, Equatable {
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

struct EditablePlantsView: View {
    @State private var plants: [Plant] = mockPlants

    var body: some View {
        NavigationView {
            List {
                ForEach($plants) { $plant in
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("Plant name", text: $plant.name)
                                .textFieldStyle(.roundedBorder)
                            // عرض حقل موجود بدلاً من species
                            Text(plant.room)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .onDelete { indexSet in
                    plants.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Plants")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addPlant) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    // إضافة عنصر افتراضي سريع
    private func addPlant() {
        let newPlant = Plant(
            name: "",
            room: "Bedroom",
            lightRequirement: "Full sun",
            waterAmount: "20-50 ml",
            needsWatering: true
        )
        plants.append(newPlant)
    }
}


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
                        Text(plant.name.isEmpty ? "Unnamed Plant" : plant.name)
                            .font(.title2)
                            .fontWeight(.regular)
                            .foregroundColor(isWatered ? .secondaryTextColor : .white)
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

// MARK: - Header Section extracted
private struct PlantsHeaderView: View {
    let plantsWateredCount: Int
    let plantsNeedingWaterCount: Int
    let completionRatio: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Plants 🌱")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)

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

            GeometryReader { geometry in
                let width: CGFloat = geometry.size.width * CGFloat(completionRatio)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondaryTextColor.opacity(0.3))
                        .frame(height: 3)

                    Capsule()
                        .fill(Color("green00"))
                        .frame(width: width, height: 3)
                        .animation(.easeInOut(duration: 0.5), value: width)
                }
            }
            .frame(height: 3)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - 3. MyPlants View (الصفحة الرئيسية)
struct MyPlants: View {
    @State private var plants: [Plant] = mockPlants
    @State private var showingReminderSheet = false
    @State private var selectedPlant: Plant?
    
    // NEW: عرض صفحة الإنجاز عند اكتمال الري
    @State private var showAllDone = false
    
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
        let ratio: Double
        if totalPlantsCount > 0 {
            ratio = Double(plantsWateredCount) / Double(totalPlantsCount)
        } else {
            ratio = 0.0
        }
        // Clamp explicitly to [0, 1] without nested min/max chains
        if ratio < 0.0 { return 0.0 }
        if ratio > 1.0 { return 1.0 }
        return ratio
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.ultraDarkBackground.ignoresSafeArea()
            plantsList
            addButton
        }
        // عند الإغلاق: إذا الاسم غير فاضي نضيف، غير كذا ما نضيف
        .sheet(isPresented: $showingReminderSheet, onDismiss: handleSheetDismiss) {
            sheetR(plant: $selectedPlant)
        }
        // NEW: راقب اكتمال الري واعرض صفحة الإنجاز
        .onChange(of: plantsNeedingWaterCount) { _, newValue in
            showAllDone = (newValue == 0 && !plants.isEmpty)
        }
        .fullScreenCover(isPresented: $showAllDone) {
            AllDoneView()
                .preferredColorScheme(.dark)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Extracted subviews to reduce type-checking complexity
    private var plantsList: some View {
        List {
            PlantsHeaderView(
                plantsWateredCount: plantsWateredCount,
                plantsNeedingWaterCount: plantsNeedingWaterCount,
                completionRatio: completionRatio
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

            ForEach($plants) { $plant in
                PlantListItemView(plant: $plant)
                    .onTapGesture {
                        selectedPlant = plant
                        showingReminderSheet = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            removePlant(id: plant.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .onDelete(perform: deleteOffsets)
        }
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
    }
    
    private var addButton: some View {
        Button(action: {
            selectedPlant = Plant(
                name: "",
                room: "Bedroom",
                lightRequirement: "Full sun",
                waterAmount: "20-50 ml",
                needsWatering: true
            )
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
    
    private func handleSheetDismiss() {
        guard let edited = selectedPlant else { return }
        let trimmed = edited.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            // الاسم فاضي: لا نضيف شيء
            selectedPlant = nil
            return
        }
        if let idx = plants.firstIndex(where: { $0.id == edited.id }) {
            plants[idx] = edited
        } else {
            plants.append(edited)
        }
        selectedPlant = nil
    }
    
    // حذف عبر السحب (onDelete)
    private func deleteOffsets(_ offsets: IndexSet) {
        plants.remove(atOffsets: offsets)
    }
    // حذف عبر زر Swipe Action
    private func removePlant(id: UUID) {
        if let idx = plants.firstIndex(where: { $0.id == id }) {
            plants.remove(at: idx)
        }
    }
}

#Preview {
    MyPlants()
        .preferredColorScheme(.dark)
}

