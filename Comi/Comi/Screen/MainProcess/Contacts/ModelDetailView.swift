//
//  ModelDetailView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI
import Kingfisher

struct ModelDetailView: View {

    @Environment(\.dismiss) var dismiss
    @State private var showTopics: Bool = false
    @State private var isSelected: Bool = false
    @State private var selected: Topics?
    @State private var gotoCallingView: Bool = false
    @Binding var gotoRoot: Bool
    @StateObject var favorites = FavoritesViewModel()
    @StateObject var topics = TopicsDB()
    var model: RealmModel

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            KFImage(URL(string: model.image))
                .fade(duration: 0.25)
                .startLoadingBeforeViewAppear(true)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .ignoresSafeArea()
                .onTapGesture {
                showTopics = false
                isSelected = false
                selected = nil
            }
            customNavBar()
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    ModelModal(showTopics: $showTopics, isSelected: $isSelected, selected: $selected, model: model, maxSize: geo.size)
                        .environmentObject(topics)
                    bottomBtn()
                }
            }
        }
            .onAppear {
            topics.getData()
        }

    }
    @ViewBuilder
    private func customNavBar() -> some View {
        HStack(alignment: .center) {
            Button {
                dismiss()
            } label: {
                Image("Close")
                    .foregroundColor(.cwhite)
            }.frame(width: 32, height: 32)

            Spacer()
            Text("\(model.name)")
                .font(.ptSemiBold22)
                .foregroundColor(.cwhite)
            Spacer()

            Button {
                if favorites.decodeSave().contains(model) {
                    favorites.popIDSave(idx: model.id)
                } else {
                    favorites.encodeSave(value: model)
                }
            } label: {
                Image(favorites.decodeSave().contains(model) ? "Heart" : "Heart Disalbed")
            }.frame(width: 32, height: 32)
        }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
            .background(
            Color.black.opacity(0.05)
        )
    }

    @ViewBuilder
    private func bottomBtn() -> some View {
        ZStack {
            if showTopics == false {
                showTopicButton()
            } else {
                goCallViewButton()
            }
        }
            .frame(maxWidth: .infinity, minHeight: 82, maxHeight: 82, alignment: .center)
            .background {
            Rectangle()
                .fill(.cwhite)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func showTopicButton() -> some View {
        Button {
            showTopics.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: 62)
                    .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .blue2, location: 0.00),
                            Gradient.Stop(color: .blue1, location: 1.00)
                        ],
                        startPoint: UnitPoint(x: 0, y: 1),
                        endPoint: UnitPoint(x: 1, y: 0)
                    )
                )
                    .cornerRadius(100)
                    .padding(.horizontal, 24)
                Text(showTopics ? "전화하기" : "대화 주제 선택하기")
                    .font(.ptSemiBold18)
                    .foregroundStyle(.cwhite)

            }
        }
    }

    @ViewBuilder
    private func goCallViewButton() -> some View {
        Button {
            gotoCallingView = true
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: 62)
                    .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: isSelected ? .blue2 : .constantsSemi, location: 0.00),
                            Gradient.Stop(color: isSelected ? .blue1 : Color.disabled, location: 1.00)
                        ],
                        startPoint: UnitPoint(x: 0, y: 1),
                        endPoint: UnitPoint(x: 1, y: 0)
                    )
                )
                    .cornerRadius(100)
                    .padding(.horizontal, 24)
                Text(showTopics ? "전화하기" : "대화 주제 선택하기")
                    .font(.ptSemiBold18)
                    .foregroundStyle(.cwhite)

            }
        }
            .disabled(isSelected ? false : true)
            .background(
            NavigationLink(
                destination: CallingView(gotoRoot: $gotoRoot, topicTitle: selected?.title ?? "", model: self.model, callId: nil)
                    .navigationBarHidden(true),
                isActive: $gotoCallingView,
                label: { EmptyView() }
            )
        )
    }
}

#Preview {
    ModelDetailView(gotoRoot: .constant(true), model: RealmModel(id: 0, name: "카리나", englishName: "karina", state: .available, image: ""))
}
