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
        = RealmModel(id: 0, name: "", group: nil, state: .available, image: "")

    @State private var gotoModelDetailView: Bool = false
    @Binding var selectedTab: Tabs
    @StateObject var favorites = FavoritesViewModel()

    private var groupedModels: [(String, [RealmModel])] {
        let groupedDictionary = Dictionary(grouping: realmViewModel.modelData.models) { $0.group ?? "" }
        return groupedDictionary.sorted { $0.0 > $1.0 }
    }

    var body: some View {
        NavigationView {
            GeometryReader { _ in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("연락처")
                            .font(.ptBold22)
                    }
                        .padding(.bottom, 16)
                        .padding(.horizontal, 24)
                    SearchBar()
                        .padding(.bottom, 8)
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
                        destination: ModelDetailView(gotoRoot: $gotoModelDetailView, model: selectedModel)
                            .navigationBarHidden(true),
                        isActive: $gotoModelDetailView,
                        label: { EmptyView() })
                    BackGround()
                }
            }
        }
    }

    @ViewBuilder
    private func modelItems(data: RealmModel) -> some View {
        HStack(spacing: 0) {
            HStack {
                ZStack {
                    KFImage(URL(string: data.image))
                        .fade(duration: 0.25)
                        .startLoadingBeforeViewAppear(true)
                        .resizable()
                        .scaledToFill()
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
            }
                .contentShape(Rectangle())
                .onTapGesture {
                selectedModel = data
                gotoModelDetailView = true
            }
            Button {
                // TODO: 모델별 목소리 데이터로 수정
                print("play sound")
            } label: {
                Image("PlayButton")
                    .resizable()
                    .frame(width: 30, height: 30)
            }.padding(.trailing, 24)
        }.padding(.bottom, 4)
    }

    @ViewBuilder
    private func favoritesList() -> some View {

        Section(header: sectionText(text: "즐겨찾기")) {
            if !favorites.decodeSave().isEmpty {
                ForEach(favorites.decodeSave().reversed(), id: \.self) { data in
                    let model = RealmModel(id: data.id, name: data.name, group: data.group ?? nil, state: data.state, image: data.image)

                    modelItems(data: model)
                        .padding(.leading, 24)
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
