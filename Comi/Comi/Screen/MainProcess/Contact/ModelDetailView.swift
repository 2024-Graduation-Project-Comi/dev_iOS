//
//  ModelDetailView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct ModelDetailView: View {
    @StateObject var favorites = FavoritesViewModel()
    @Environment(\.presentationMode) var presentationMode

    @State private var showTitle: Bool = true
    @State private var isSelected: Bool = false //주제 선택을 했는지 확인

    var model: Model

    var body: some View {
        GeometryReader { geo in
            Image("kari2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                showTitle = false
            }
            customNavBar()
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    ModelModalView(data: model, maxHeight: geo.size.height, state: $showTitle, isSelected: $isSelected)
                    bottomBtn()
                }
            }
        }

    }
    @ViewBuilder
    private func customNavBar() -> some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("Close")
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
                            .foregroundStyle(.white)

                    }
                        .offset(y: -15)
                }
            } else {
                NavigationLink {
                    // TODO: 구현해야함
                    testView()
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
                            .foregroundStyle(.white)

                    }
                        .offset(y: -15)
                }
                .disabled(isSelected ? false : true)
                

            }

        }
            .frame(maxWidth: .infinity, minHeight: 116, maxHeight: 116, alignment: .center)
            .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.white)
                .ignoresSafeArea()
        }
    }
}





#Preview {
    ModelDetailView(model: Model(id: 0, name: "카리나", state: .available))
}
