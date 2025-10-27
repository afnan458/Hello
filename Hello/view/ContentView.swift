import SwiftUI

// تعريف لون الزر والأيقونات المخصص
extension Color {
    static let mintAccent = Color(red: 0.35, green: 0.8, blue: 0.65)
    static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let sectionBackground = Color(red: 0.15, green: 0.15, blue: 0.15)
}

// ==========================================================
// 1. شاشة الشيت (Set Reminder View)
// ==========================================================

struct PlantJourneyViewV2: View {
    
    @Environment(\.dismiss) var dismiss
    
    // حالات للمدخلات مع خيارات
    @State private var plantName: String = "Pothos"
    @State private var roomSelection: String = "Bedroom C"
    @State private var lightSelection: String = "Full sun ☉"
    @State private var wateringDaysSelection: String = "Every day"
    @State private var waterAmountSelection: String = "20-50 ml"
    
    let rooms = ["Bedroom C", "Living Room", "Kitchen", "Office"]
    let lightOptions = ["Full sun ☉", "Partial shade 🌥️", "Low light 🌑"]
    let wateringOptions = ["Every day", "Every 2 days", "Twice a week", "Once a week"]
    let waterAmounts = ["10-20 ml", "20-50 ml", "50-100 ml", "أكثر من 100 ml"]

    var body: some View {
        NavigationView {
            List {
                
                // القسم الأول: اسم النبتة لوحده
                VStack(alignment: .leading) {
                    Text("Plant Name")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $plantName)
                        .foregroundColor(.white)
                        .font(.body)
                        .autocorrectionDisabled(true)
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.sectionBackground)
                .listRowSeparator(.hidden)
                .cornerRadius(10)
                .padding(.bottom, 10)

                // القسم الثاني: الغرفة والضوء معاً
                VStack(spacing: 0) {
                    DetailPickerRow(icon: "paperplane", title: "Room", selection: $roomSelection, options: rooms)
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)

                    Divider().background(Color.gray.opacity(0.3)).padding(.leading, 35)

                    DetailPickerRow(icon: "sun.max", title: "Light", selection: $lightSelection, options: lightOptions)
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.sectionBackground)
                .cornerRadius(10)
                .padding(.bottom, 10)

                // القسم الثالث: الري والكمية معاً
                VStack(spacing: 0) {
                    DetailPickerRow(icon: "drop.fill", title: "Watering Days", selection: $wateringDaysSelection, options: wateringOptions)
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)

                    Divider().background(Color.gray.opacity(0.3)).padding(.leading, 35)

                    DetailPickerRow(icon: "drop", title: "Water", selection: $waterAmountSelection, options: waterAmounts)
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.sectionBackground)
                .cornerRadius(10)
                
            }
            .listStyle(.insetGrouped)
            .background(Color.black.ignoresSafeArea())
            .scrollContentBackground(.hidden)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.gray)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "checkmark.circle.fill").font(.title2).foregroundColor(.mintAccent)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// هيكل مُساعد لصف القائمة المنسدلة (Picker Row)
struct DetailPickerRow: View {
    let icon: String
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray).frame(width: 20)
            Text(title).foregroundColor(.white)
            Spacer()
            Picker("Selection", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.menu)
            .accentColor(.gray)
            .overlay(
                 Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray.opacity(0.5)).padding(.leading, 6),
                 alignment: .trailing
            )
            .labelsHidden()
        }
    }
}

#Preview {
    PlantJourneyViewV2()
}
