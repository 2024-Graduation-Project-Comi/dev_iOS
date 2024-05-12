//
//  ModelDetailView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct ModelDetailView: View {
    @StateObject var favorites = FavoritesViewModel()
    @Environment(\.dismiss) var dismiss

    @State private var showTitle: Bool = false
    @State private var isSelected: Bool = false //주제 선택을 했는지 확인
    @State private var selected: TopicData?
    @State private var gotoCallingView: Bool = false

    var model: sModels
    @Binding var gotoRoot: Bool

    var body: some View {
        GeometryReader { geo in
            Image("kari2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                showTitle = false
                isSelected = false
                selected = nil
            }
            customNavBar()
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    ModelModal(data: model, maxHeight: geo.size.height, state: $showTitle, isSelected: $isSelected, selected: $selected)
                    bottomBtn()
                }
            }
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
            if showTitle == false {
                Button {
                    showTitle.toggle()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 342, height: 62)
                            .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .blue2, location: 0.00),
                                    Gradient.Stop(color: .blue1, location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0, y: 1),
                                endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                            .cornerRadius(100)
                        Text(showTitle ? "전화하기" : "대화 주제 선택하기")
                            .font(.ptSemiBold18)
                            .foregroundStyle(.cwhite)

                    }
                        .offset(y: -15)
                }
            } else {
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
                                    Gradient.Stop(color: isSelected ? .blue1 : Color.disabled, location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0, y: 1),
                                endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                            .cornerRadius(100)
                        Text(showTitle ? "전화하기" : "대화 주제 선택하기")
                            .font(.ptSemiBold18)
                            .foregroundStyle(.cwhite)

                    }
                        .offset(y: -15)
                }
                    .background(
                    NavigationLink(
                        destination:
                            CallingView(modelData: model, topicData: $selected, gotoRoot: $gotoRoot)
                            .navigationBarHidden(true),
                        isActive: $gotoCallingView,
                        label: { EmptyView() }
                    )
                )
            }

        }
            .frame(maxWidth: .infinity, minHeight: 116, maxHeight: 116, alignment: .center)
            .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.cwhite)
                .ignoresSafeArea()
        }
    }
}





#Preview {
    ModelDetailView(model: sModels(id: 0, name: "카리나", state: .available, image: ""), gotoRoot: .constant(true))
}
