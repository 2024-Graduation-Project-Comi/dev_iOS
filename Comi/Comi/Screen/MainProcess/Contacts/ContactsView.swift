//
//  ContectView.swift
//  Comi
//
//  Created by yimkeul on 5/1/24.
//

import SwiftUI

struct ContactsView: View {
    @Binding var selectedTab: Tab

    @StateObject var favorites = FavoritesViewModel()
    @State private var selectedModel: sModels
        = sModels(id: 0, name: "", group: nil, state: .available, image: "")

    @State private var gotoModelDetailView: Bool = false
    @EnvironmentObject var modelViewModel: ModelViewModel

    private var groupedModels: [(String, [sModels])] {
        let groupedDictionary = Dictionary(grouping: modelViewModel.models) { $0.group ?? "" }
        return groupedDictionary.sorted { $0.0 > $1.0 }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("연락처")
                            .font(.ptBold22)
                        Spacer()
                        Image("Search")
                    }
                        .padding(.horizontal, 24)

                    List {
                        favoritesList()
                        voiceList()
                        emptyListArea()

                    }
                        .listStyle(.plain)
                    BottomTabBarView(selectedTab: $selectedTab)
                }
                    .background {
                    NavigationLink(
                        destination: ModelDetailView(model: selectedModel, gotoRoot: $gotoModelDetailView)
                            .navigationBarHidden(true),
                        isActive: $gotoModelDetailView,
                        label: { EmptyView() })
                    BackGround()
                }
            }
        }
    }

    @ViewBuilder
    private func favoritesList() -> some View {

        Section(header: sectionText(text: "즐겨찾기")) {
            if !favorites.decodeSave().isEmpty {
                ForEach(favorites.decodeSave().reversed(), id: \.self) { data in
                    let model = sModels(id: data.id, name: data.name, group: data.group ?? nil, state: data.state, image: "")

                    modelItems(data: model)
                        .padding(.leading, 24)
                        .onTapGesture {
                        selectedModel = model
                        gotoModelDetailView = true
                    }
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
                    modelItems(data: model)
                        .padding(.leading, 24)
                        .onTapGesture {
                        selectedModel = model
                        gotoModelDetailView = true
                    }
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

@ViewBuilder
private func modelItems(data: sModels) -> some View {
    HStack {
        ZStack {
            Image("ma")
                .resizable()
                .scaledToFit()
                .frame(width: 62, height: 62)
                .clipShape(Circle())
            if data.state == .locked {
                Image("Lock")
                    .offset(x: 20, y: 20)
            } else {
                Circle()
                    .fill(data.state == .available ? .availableCircle : .unavailableCircle)
                    .frame(width: 16, height: 16)
                    .offset(x: 20, y: 20)
                    .overlay {
                    Circle()
                        .stroke(Color.cwhite, lineWidth: 1)
                        .offset(x: 20, y: 20)
                }
            }
        }
        Text(data.name)
            .font(.ptSemiBold18)
            .foregroundStyle(.black)
        Spacer()
    }.padding(.bottom, 4)
        .contentShape(Rectangle())
}

#Preview {
    ContactsView(selectedTab: .constant(.contact))
}
