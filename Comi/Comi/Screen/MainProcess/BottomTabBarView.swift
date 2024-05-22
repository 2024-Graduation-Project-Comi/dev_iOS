//
//  BottomTabBarView.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

enum Tabs {
    case home
    case history
    case contact
    case profile
}

struct BottomTabBarView: View {
    @Binding var selectedTab: Tabs
    var body: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .home
            } label: {
                VStack(spacing: 0) {
                    Image(selectedTab == .home ? "Home filled" : "Home filled Disabled")
                    Text("홈")
                        .foregroundStyle(selectedTab == .home ? .blue2 : .disabled)
                        .font(.ptRegular11)
                }
            }
            Spacer()
            Button {
                selectedTab = .history
            } label: {
                VStack(spacing: 0) {
                    Image(selectedTab == .history ? "History" : "History Disabled")
                    Text("최근 기록")
                        .foregroundStyle(selectedTab == .history ? .blue2 : .disabled)
                        .font(.ptRegular11)
                }
            }
            Spacer()
            Button {
                selectedTab = .contact
            } label: {
                VStack(spacing: 0) {
                    Image(selectedTab == .contact ? "Contacts" : "Contacts Disabled")
                    Text("연락처")
                        .foregroundStyle(selectedTab == .contact ? .blue2 : .disabled)
                        .font(.ptRegular11)
                }
            }
            Spacer()
            Button {
                selectedTab = .profile
            } label: {
                VStack(spacing: 0) {
                    Image(selectedTab == .profile ? "Person" : "Person Disabled")
                    Text("프로필")
                        .foregroundStyle(selectedTab == .profile ? .blue2 : .disabled)
                        .font(.ptRegular11)
                }
            }
            Spacer()
        }
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56, alignment: .center)
            .background {
            Rectangle()
                .fill(.cwhite)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 0)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BottomTabBarView(selectedTab: .constant(.home))
}
