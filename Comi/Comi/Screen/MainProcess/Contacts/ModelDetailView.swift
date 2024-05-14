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
                    ModelModal(showTopics: $showTopics, isSelected: $isSelected, selected: $selected, model: model, maxHeight: geo.size.height)
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
        HStack {
            Button {
                dismiss()
            } label: {
                Image("Close")
                    .foregroundStyle(.cwhite)
            }

            Spacer()

            Button {
                if favorites.decodeSave().contains(model) {
                    favorites.popIDSave(idx: model.id)
                } else {
                    favorites.encodeSave(value: model)
                }
            } label: {
                Image(favorites.decodeSave().contains(model) ? "Heart" : "Heart Disalbed")
            }
        }.padding(.horizontal, 24)
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
            .frame(maxWidth: .infinity, minHeight: 116, maxHeight: 116, alignment: .center)
            .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.cwhite)
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
                    .frame(width: 342, height: 62)
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
                Text(showTopics ? "전화하기" : "대화 주제 선택하기")
                    .font(.ptSemiBold18)
                    .foregroundStyle(.cwhite)

            }
                .offset(y: -15)
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
                    .frame(width: 342, height: 62)
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
                Text(showTopics ? "전화하기" : "대화 주제 선택하기")
                    .font(.ptSemiBold18)
                    .foregroundStyle(.cwhite)

            }
                .offset(y: -15)
        }
            .disabled(isSelected ? false : true)
            .background(
            NavigationLink(
                destination: CallingView(gotoRoot: $gotoRoot, topicTitle: selected?.title ?? "", model: self.model)
                    .navigationBarHidden(true),
                isActive: $gotoCallingView,
                label: { EmptyView() }
            )
        )
    }
}

#Preview {
    ModelDetailView(gotoRoot: .constant(true), model: RealmModel(id: 0, name: "카리나", state: .available, image: ""))
}
