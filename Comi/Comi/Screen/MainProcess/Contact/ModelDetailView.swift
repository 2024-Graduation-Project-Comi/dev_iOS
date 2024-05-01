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
    var model: Model
    var body: some View {
        VStack {
            customNavBar()
            Text("\(model.name) - \(model.id) - \(model.state)")
         Spacer()
        }.background(Color.pink)
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
}



#Preview {
    ModelDetailView(model: Model(id: 0, name: "카리나", state: .available))
}
