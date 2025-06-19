import SwiftUI

struct StoryListScreen: View {

    @State private var isPresented = false
    @State private var selection: UserViewModel?
    @ObservedObject private var model = StoryListScreenModel()

    var body: some View {
        VStack {
            Text("Instagram")
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(model.userViewModels.indices, id: \.self) { index in
                        Button {
                            self.selection = model.userViewModels[index]
                            model.userViewModels[index].seen = true
                            UserDefaults.standard.set(
                                true, forKey: "SEEN: \(model.userViewModels[index].id)")
                            isPresented = true
                        } label: {
                            StoryCell(viewModel: model.userViewModels[index])
                                .onAppear {
                                    if model.userViewModels.indices.last == index {
                                        model.page += 1
                                        model.load()
                                    }
                                }
                                .sheet(item: $selection) { selection in
                                    let localIndex = model.userViewModels.firstIndex(where: {
                                        $0.id == selection.id
                                    })!
                                    StoryViewScreen(
                                        viewModels: model.userViewModels, index: localIndex,
                                        onLike: { isLiked, likedIndex in
                                            model.userViewModels[likedIndex].liked = isLiked
                                            UserDefaults.standard.set(
                                                isLiked,
                                                forKey:
                                                    "LIKED: \(model.userViewModels[likedIndex].id)")
                                        },
                                        onSeen: { seenIndex in
                                            model.userViewModels[seenIndex].seen = true
                                            UserDefaults.standard.set(
                                                true,
                                                forKey: "SEEN: \(model.userViewModels[index].id)")
                                        })
                                }
                        }
                    }
                }
            }
            .scrollClipDisabled()
            .frame(height: 128)
            .padding(.bottom, 16)
            Button("Reset view state for all") {
                for i in model.userViewModels.indices {
                    UserDefaults.standard.set(false, forKey: "SEEN: \(model.userViewModels[i].id)")
                    model.userViewModels[i].seen = false
                }
            }
            Button("Reset like state for all") {
                for i in model.userViewModels.indices {
                    UserDefaults.standard.set(false, forKey: "LIKED: \(model.userViewModels[i].id)")
                    model.userViewModels[i].liked = false
                }
            }
            Spacer()
        }
        .padding()
        .task {
            model.load()
        }
    }
}
