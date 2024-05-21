//
//  ContectView.swift
//  Comi
//
//  Created by yimkeul on 5/1/24.
//

import SwiftUI
import Kingfisher

struct ContactsView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @State private var selectedModel: RealmModel
        = RealmModel(id: 0, name: "", englishName: "", group: nil, state: .available, image: "")
    @State private var selectedModel2: RealmModel
        = RealmModel(id: 0, name: "", englishName: "", group: nil, state: .available, image: "")
    @State private var gotoModelDetailView: Bool = false
    @Binding var selectedTab: Tabs
    @StateObject var favorites = FavoritesViewModel()

    private var groupedModels: [(String, [RealmModel])] {
        let groupedDictionary = Dictionary(grouping: realmViewModel.modelData.models) { $0.group ?? "" }
        return groupedDictionary.sorted { $0.0 > $1.0 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("연락처")
                    .font(.ptBold22)
            }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            SearchBar()
                .padding(.bottom, 8)
            List {
                favoritesList()
                voiceList()
                emptyListArea()
            }.background(
                NavigationLink(
                    destination: ModelDetailView(gotoRoot: $gotoModelDetailView, model: selectedModel)
                        .navigationBarHidden(true),
                    isActive: $gotoModelDetailView,
                    label: { EmptyView() }))
                .listStyle(.plain)
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }
            .background {
            BackGround()
        }
    }

    @ViewBuilder
    private func favoritesList() -> some View {

        Section(header: sectionText(text: "즐겨찾기")) {
            if !favorites.decodeSave().isEmpty {
                ForEach(favorites.decodeSave().reversed(), id: \.self) { data in
                    let model = RealmModel(id: data.id, name: data.name, englishName: data.englishName, group: data.group ?? nil, state: data.state, image: data.image)

                    ModelCard(selectedModel: $selectedModel, gotoModelDetailView: $gotoModelDetailView, data: model)
                        .padding(.horizontal, 24)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
        }.listRowInsets(EdgeInsets())
    }

    @ViewBuilder
    private func voiceList() -> some View {
        ForEach(groupedModels, id: \.0) { group, modelsInSection in
            Section(header: sectionText(text: group)) {
                ForEach(modelsInSection, id: \.id) { model in
                    ModelCard(selectedModel: $selectedModel, gotoModelDetailView: $gotoModelDetailView, data: model)
                        .padding(.horizontal, 24)
                }
            }
        }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
    }
}

@ViewBuilder
private func emptyListArea() -> some View {
    Color(.clear)
        .frame(height: 32)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
}

@ViewBuilder
private func sectionText(text: String) -> some View {
    Text(text)
        .font(.ptRegular14)
        .foregroundStyle(.black)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
}

#Preview {
    ContactsView(selectedTab: .constant(.contact))
}
