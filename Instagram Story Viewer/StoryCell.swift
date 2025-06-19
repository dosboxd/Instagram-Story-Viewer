import SwiftUI

struct StoryCell: View {

    var viewModel: UserViewModel

    var body: some View {
        VStack {
            Image(uiImage: viewModel.picture)
                .resizable()
                .scaledToFit()
                .background(Color.green)
                .clipShape(.capsule)
            Text(viewModel.name)
        }
    }
}

#Preview {
    StoryCell(viewModel: UserViewModel(id: 0, name: "Sample", picture: UIImage()))
}
