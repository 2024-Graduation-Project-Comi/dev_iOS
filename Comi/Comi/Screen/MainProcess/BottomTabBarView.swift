//
//  BottomTabBarView.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

enum Tab {
    case home
    case history
    case contact
    case profile
}

struct BottomTabBarView: View {
    @Binding var selectedTab: Tab
    var body: some View {
        HStack {
            Spacer()
            Button () {
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
            Button () {
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
            Button () {
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
            Button () {
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
            .frame(maxWidth: .infinity, maxHeight: 56, alignment: .center)
            .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.white)
                .ignoresSafeArea()
        }

    }
}

#Preview {
    BottomTabBarView(selectedTab: .constant(.home))
}
