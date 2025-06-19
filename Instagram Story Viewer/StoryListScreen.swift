import SwiftUI

struct StoryListScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let url = Bundle.main.url(forResource: "users", withExtension: "json")
            let contents = FileManager.default.contents(atPath: url!.relativePath)
            let decoded = try? JSONDecoder().decode(Root.self, from: contents!)
            print(decoded)
        }
    }
}

#Preview {
    StoryListScreen()
}
