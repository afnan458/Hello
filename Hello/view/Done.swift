//
//  Done.swift
//  Hello
//
//  Created by Afnan hassan on 04/05/1447 AH.
//
import SwiftUI

// MARK: - Color Extension
extension Color {
    // دالة لاستخدام ألوان Hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // الألوان المخصصة
    static let ultraDarkBackground = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let secondaryTextColor = Color(white: 0.6)
    static let lightDivider = Color.gray.opacity(0.2)
    static let customGreen = Color(hex: "#4CD964")
    
    // مستخدم في Reminder.swift كخلفية للبادجات
    static let badgeBackground = Color.white.opacity(0.06)
}

// ------------------------------------------------------------------------

// MARK: - AllDoneView (شاشة الإنجاز)
struct AllDoneView: View {
    var body: some View {
        VStack {
            Spacer()
            // 🌟 الصورة المقصوصة على شكل دائرة 🌟
            Image("Image") // يُفترض أن "Image" هو اسم صورة النبتة في الأصول
                 .resizable()
                 .scaledToFill() // لتغطية الدائرة بالكامل دون فراغات
                 .frame(width: 160, height: 200) // تحديد حجم الدائرة
                 //.clipShape(Circle()) // قص الصورة لتصبح دائرة
                 .padding(.bottom, 19) // تباعد بسيط بين الصورة والنصوص
            Spacer()
            // النص الرئيسي (يظهر تحت الصورة مباشرة)
            Text("All Done! 🎉")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // النص الثانوي (يظهر تحت النص الرئيسي)
            Text("All Reminders Completed")
                .font(.callout)
                .foregroundColor(.secondaryTextColor)
            Spacer(minLength: 200)
        }
    
    }
}

// ------------------------------------------------------------------------

// MARK: - MainContentView (الكود الذي أرسلته)
struct MainContentView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.ultraDarkBackground.ignoresSafeArea()

            VStack(alignment: .leading) {
                // 1. Title Area
                HStack(alignment: .lastTextBaseline) {
                    Text("My Plants")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("🌱")
                        .font(.title)
                }
                .padding(.leading)
                .padding(.top, 60)

                // 2. 🌟 THIN SEPARATOR LINE 🌟
                Divider()
                    .overlay(Color.lightDivider) // Use your defined light color
                    .padding(.vertical, 3) // Space around the line
                    .padding([.leading, .trailing]) // Ensure it spans the width
                    .opacity(0.5) // Make it very light and thin

                // 3. Centered Content (AllDoneView)
                AllDoneView()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            // 4. Floating Add Button
            Button(action: { /* Action */ }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(18)
                    .background(
                        Circle().fill(Color("green00"))
                    )
                    .shadow(radius: 5)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 30)
        }
    }
}

// MARK: - Preview (لإظهار الكود في Xcode)
#Preview {
    MainContentView()
}

// ------------------------------------------------------------------------

#Preview {
    AllDoneView()
        .preferredColorScheme(.dark)
}
