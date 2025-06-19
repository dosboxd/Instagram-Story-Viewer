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
                .overlay {
                    Circle()
                        .stroke(lineWidth: 7)
                        .foregroundStyle(viewModel.seen ? Color.gray : Color.blue)
                }
            Text(viewModel.name)
        }
    }
}
