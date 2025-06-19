import SwiftUI

struct StoryCell: View {

    @Binding var viewModel: UserViewModel

    var body: some View {
        VStack {
            Image(uiImage: viewModel.picture)
                .resizable()
                .scaledToFit()
                .background(Color.green)
                .clipShape(.capsule)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 7)
                        .foregroundStyle(viewModel.seen ? Color.gray : Color.blue)
                }
            Text(viewModel.name)
        }
        .onTapGesture {
            viewModel.seen = true
            UserDefaults.standard.set(true, forKey: "\(viewModel.id)")
        }
    }
}

#Preview {
    StoryCell(viewModel: .constant(UserViewModel(id: 0, name: "Sample", picture: UIImage()))).frame(height: 100)
}
