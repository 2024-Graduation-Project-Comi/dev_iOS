//
//  ContectView.swift
//  Comi
//
//  Created by yimkeul on 5/1/24.
//

import SwiftUI

struct ContectView: View {

    private var groupedModels: [(String, [Model])] {
        let groupedDictionary = Dictionary(grouping: Models) { $0.group ?? "" }
        return groupedDictionary.sorted { $0.0 > $1.0 }
    }

    @StateObject var favorites = FavoritesViewModel()
    @State private var isActive: Bool = false
    @State private var selectedModel: Model = Model(id: 0, name: "", group: nil, state: .unavailable)

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let _ = geo.size
                VStack(alignment: .leading) {
                    HStack {
                        Text("연락처")
                            .font(.ptBold22)
                        Spacer()
                        Image("Search")
                    }
                        .padding(.bottom, 24)
                        .padding(.horizontal, 24)
                    List {
                        VStack(alignment: .leading) {
                            Text("즐겨찾기")
                                .font(.ptRegular14)
                                .foregroundStyle(.black)
                                .padding(.bottom, 8)

                            if !favorites.decodeSave().isEmpty {
                                ForEach(favorites.decodeSave().reversed(), id: \.self) { data in
                                    let model = data.group != nil ? Model(id: data.id, name: data.name, group: data.group, state: data.state) : Model(id: data.id, name: data.name, group: nil, state: data.state)
                                    modelItems(data: model)
                                        .onTapGesture {
                                        selectedModel = model
                                        isActive = true
                                    }
                                }
                            } else {
                                Text("원하는 모델을 저장하세요")
                                    .font(.ptRegular11)
                            }
                        }
                            .padding(.leading, 24)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)

                        ForEach(groupedModels, id: \.0) { group, modelsInSection in
                            Section(header: sectionText(text: group)) {
                                ForEach(modelsInSection, id: \.id) { model in
//                                    NavigationLink {
//                                        ModelDetailView(model: model)
//                                            .navigationBarHidden(true)
//                                    } label: {
//                                        modelItems(data: model)
//                                            .padding(.leading, 24)
//                                    }
//                                    modelItems(data: model)
//                                        .padding(.leading, 24)
//                                        .background(
//                                        NavigationLink("", destination: {
//                                            ModelDetailView(model: model)
////                                                .navigationBarHidden(true)
//                                        }).opacity(0)
//                                    )
                                    modelItems(data: model)
                                        .padding(.leading, 24)
                                        .onTapGesture {
                                        selectedModel = model
                                        isActive = true
                                    }
                                }
                            }
                        }
                            .padding(.bottom, 8)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)

                    }
                        .listStyle(.plain)
                        .background(Color.clear.edgesIgnoringSafeArea(.all))

                }
                    .background {
                    BackGround()
                    NavigationLink(destination: ModelDetailView(model: selectedModel)
                        .navigationBarHidden(true), isActive: $isActive, label: { EmptyView() })
                }
                    .padding(.bottom, 56)
            }

        }

    }
}


@ViewBuilder
private func sectionText(text: String) -> some View {
    Text(text)
        .font(.ptRegular14)
        .foregroundStyle(.black)
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
}

@ViewBuilder
private func modelItems(data: Model) -> some View {
    HStack {
        ZStack {
            Image("마젠타")
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
                        .stroke(Color.white, lineWidth: 1)
                        .offset(x: 20, y: 20)
                }
            }
        }
        Text(data.name)
            .font(.ptSemiBold18)
            .foregroundStyle(.black)
    }
        .padding(.bottom, 8)
}

#Preview {
    ContectView()
}
