//
//  sheetR.swift
//  Hello
//
//  Created by Afnan hassan on 02/05/1447 AH.
import SwiftUI

// Extension للتعامل مع Binding اختياري في حقل TextField
extension Binding where Value == String? {
    func nonOptionalBinding(defaultValue: String) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

// MARK: - Helper Row View (تم الاحتفاظ به)
struct RowView: View {
    let imageName: String
    let label: String
    @Binding var value: String?
    var trailingText: String? = nil
    var isEditable: Bool = false
    
    init(imageName: String, label: String, value: Binding<String?> = .constant(nil), trailingText: String? = nil, isEditable: Bool = false) {
        self.imageName = imageName
        self.label = label
        self._value = value
        self.trailingText = trailingText
        self.isEditable = isEditable
    }
    
    var body: some View {
        HStack {
            Image(systemName: imageName).foregroundColor(.secondaryTextColor)
            Text(label).foregroundColor(.white)
            Spacer()
            
            if isEditable {
                TextField("Pothos", text: $value.nonOptionalBinding(defaultValue: ""))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .environment(\.layoutDirection, .leftToRight)
            } else {
                Text(trailingText ?? "")
                    .foregroundColor(.secondaryTextColor)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondaryTextColor)
            }
        }
    }
}


// MARK: - 4. Set Reminder View (sheetR - هيكل الشيت)
struct sheetR: View {
    @Environment(\.dismiss) var dismiss
    @Binding var plant: Plant?

    let rooms = ["Bedroom", "Kitchen", "Living Room", "Bathroom"]
    let lights = ["Full sun", "Partial sun", "Low light"]
    let wateringOptions = ["Every day", "Every 3 days", "Once a week"]
    let waterAmounts = ["20-50 ml", "50-100 ml", "100+ ml"]
    
    @State private var plantName: String
    @State private var room: String
    @State private var light: String
    @State private var wateringDays: String
    @State private var waterAmount: String

    init(plant: Binding<Plant?>) {
        _plant = plant
        let initialPlant = plant.wrappedValue
        _plantName = State(initialValue: initialPlant?.name ?? "Pothos")
        _room = State(initialValue: initialPlant?.room ?? "Bedroom")
        _light = State(initialValue: initialPlant?.lightRequirement ?? "Full sun")
        _wateringDays = State(initialValue: "Every day")
        _waterAmount = State(initialValue: initialPlant?.waterAmount ?? "20-50 ml")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.ultraDarkBackground.edgesIgnoringSafeArea(.all)

                VStack {
                    List {
                        // Section 1: Plant Name
                        Section {
                            HStack {
                                Text("Plant Name").foregroundColor(.white)
                                Spacer()
                                TextField("", text: $plantName)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.white)
                                    .environment(\.layoutDirection, .rightToLeft)
                            }
                        }
                        //.listRowBackground(Color.sectionBackground)
                      //  .listRowSeparator(.hidden, for: .all)

                        // Section 2: Room & Light
                        Section {
                            Picker(selection: $room, label: HStack {
                                Image(systemName: "paperplane").foregroundColor(.secondaryTextColor)
                                Text("Room").foregroundColor(.white)
                            }) {
                                ForEach(rooms, id: \.self) { value in
                                    Text(value).tag(value)
                                }
                            }
                            
                            Picker(selection: $light, label: HStack {
                                Image(systemName: "sun.max").foregroundColor(.secondaryTextColor)
                                Text("Light").foregroundColor(.white)
                            }) {
                                ForEach(lights, id: \.self) { value in
                                    Text(value).tag(value)
                                }
                            }
                        }
                        .listRowBackground(Color.sectionBackground)
                        
                        // Section 3: Watering
                        Section {
                            Picker(selection: $wateringDays, label: HStack {
                                Image(systemName: "drop").foregroundColor(.secondaryTextColor)
                                Text("Watering Days").foregroundColor(.white)
                            }) {
                                ForEach(wateringOptions, id: \.self) { value in
                                    Text(value).tag(value)
                                }
                            }
                            
                            Picker(selection: $waterAmount, label: HStack {
                                Image(systemName: "drop").foregroundColor(.secondaryTextColor)
                                Text("Water").foregroundColor(.white)
                            }) {
                                ForEach(waterAmounts, id: \.self) { value in
                                    Text(value).tag(value)
                                }
                            }
                        }
                        .listRowBackground(Color.sectionBackground)

                        // Delete Reminder Button Section
                        if plant != nil {
                            Section {
                                Button(action: {
                                    dismiss()
                                }) {
                                    Text("Delete Reminder")
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.red)
                                }
                            }
                            .listRowBackground(Color.sectionBackground)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.white)
                    .environment(\.defaultMinListRowHeight, 55)
                    .listStyle(.insetGrouped)

                    Spacer()
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color("green00"))
                            .font(.title)
                    }
                }
            }
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview Fix
#Preview {
    // Provide a Binding<Plant?> for preview
    StatefulPreviewWrapper<Plant?>(nil) { binding in
        sheetR(plant: binding)
    }
}

// Helper for previews to create a Binding
struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ value: Value, content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}
