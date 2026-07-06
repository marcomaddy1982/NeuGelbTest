import SwiftUI

struct FormFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

extension View {
    func formFieldStyle() -> some View {
        modifier(FormFieldStyle())
    }
}
