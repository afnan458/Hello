import SwiftUI

// MARK: - Color Extension (single source kept here)
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

    // مستخدم في sheetR كخلفية لأقسام القائمة
    static let sectionBackground = Color.white.opacity(0.06)
}

// ------------------------------------------------------------------------

// MARK: - AllDoneView (شاشة الإنجاز)
struct AllDoneView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Image")
                 .resizable()
                 .scaledToFill()
                 .frame(width: 160, height: 200)
                 .padding(.bottom, 19)
            Spacer()
            Text("All Done! 🎉")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("All Reminders Completed")
                .font(.callout)
                .foregroundColor(.secondaryTextColor)
            Spacer(minLength: 200)
        }
    }
}

// ------------------------------------------------------------------------

// MARK: - MainContentView
struct MainContentView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.ultraDarkBackground.ignoresSafeArea()

            VStack(alignment: .leading) {
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

                Divider()
                    .overlay(Color.lightDivider)
                    .padding(.vertical, 3)
                    .padding([.leading, .trailing])
                    .opacity(0.5)

                AllDoneView()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

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

// MARK: - Preview


#Preview {
    MainContentView()
}

#Preview {
    AllDoneView()
        .preferredColorScheme(.dark)
}

