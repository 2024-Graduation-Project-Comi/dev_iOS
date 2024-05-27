//
//  FeedbackView.swift
//  Comi
//
//  Created by yimkeul on 5/5/24.
//

import SwiftUI
import Kingfisher

struct FeedbackView: View {

    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @Environment(\.dismiss) var dismiss
    // TODO: 변수명 고쳐야함.
    @State var sampleData: [CallConvResult] = []
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = true
    @State private var gotoModelDetailView: Bool = false
    @State private var gotoCallingView: Bool = false
    @State private var selectedModel: RealmModel = .init()
    @StateObject private var callAPIViewModel = CallAPIViewModel()
    @StateObject private var staticAPIViewModel = StaticViewModel()
    @Binding var gotoRoot: Bool
    var targetCallID: String
    var model: RealmModel
    var topicData: String

    private enum Types: String {
        case ai = "model"
        case user = "user"
    }

    var body: some View {
        if isLoading {
            loadingView()
                .onAppear {
                selectedModel = model
                callAPIViewModel.fetchConv(callId: targetCallID, completion: { result in
                    if result {
                        sampleData = callAPIViewModel.convItems
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            isLoading = false
                        })
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            print("데이터 저장 실패")
                            showAlert = true
                            dismiss()
                        })
                    }
                })

                staticAPIViewModel.fetchChartData(callID: Int(targetCallID) ?? 2) { result in
                    if result {
                        print("차트 정보 저장 성공")
                    } else {
                        print("차트 정보 저장 실패")
                    }
                }

            }
                .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text("분석 에러"), dismissButton: .destructive(Text("닫기"), action: { dismiss() }))
            }
        } else {
            VStack {
                customNavBar()
                GeometryReader { geo in
                    let size = geo.size
                    ScrollView(showsIndicators: false) {
                        ForEach(callAPIViewModel.totalTalk, id: \.self) { data in
                            speechBubble(content: data.conv, content2: data.fix, type: Types(rawValue: data.role) ?? .ai)
                        }
                        Spacer()
                            .frame(height: 116)
                    }
                        .frame(maxWidth: .infinity, maxHeight: size.height)
                        .offset(y: 116)
                    feedBackInterface()
                }
                bottomBtn()
            }
                .fullScreenCover(isPresented: $isOnboarding) {
                FeedbackManualTabView(isOnboarding: $isOnboarding)
            }
                .background(BackGround())
        }
    }

    @ViewBuilder
    private func loadingView() -> some View {
        GeometryReader { geo in
            let size = geo.size
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .foregroundStyle(.red2)
                        .frame(width: 480, height: 480)
                        .offset(x: (-480 / 2))
                    Circle()
                        .foregroundStyle(.blue0)
                        .frame(width: 480, height: 480)
                        .offset(x: (480 / 2) - 100)
                }.blur(radius: 20)
                Spacer()
            }
                .background(.cwhite)
            VStack(alignment: .center) {
                Text("Comi")
                    .font(.ptSemiBold32)
                Text("LOADING")
                    .font(.ptRegular14)
            }.frame(width: size.width, height: size.height)
        }
    }

    @ViewBuilder
    private func customNavBar() -> some View {
        HStack {
            Button {
                gotoRoot = false
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.disabled)
                    .font(.system(size: 24, weight: .semibold))
            }
            HStack(spacing: 4) {
                Text(model.name)
                    .font(.ptSemiBold18)
                    .foregroundStyle(.black)
                Text(topicData)
                    .font(.ptRegular14)
                    .foregroundStyle(.constantsSemi)
            }
            Spacer()
        }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func feedBackInterface() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
            VStack {
                Text(sampleData.first?.ended.toKoreanDateFormat() ?? "nil-nil-nil")
                    .font(.ptRegular14)
                    .foregroundStyle(.cwhite)
                NavigationLink {
                    FeedbackContentView(ended: sampleData.first?.ended.toKoreanDateFormat() ?? "nil-nil-nil", totalScores: staticAPIViewModel.chartResult)
                        .navigationBarBackButtonHidden()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 326, height: 56)
                            .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.15, green: 0.83, blue: 0.67), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.46, green: 0.59, blue: 1), location: 1.00)
                                ],
                                startPoint: UnitPoint(x: 0, y: 1),
                                endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                            .cornerRadius(100)
                        Text("분석 내용 보기")
                            .font(.ptSemiBold16)
                            .foregroundStyle(.cwhite)
                    }.padding(.horizontal, 8)
                }

            }
        }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func speechBubble(content: String, content2: String?, type: Types) -> some View {
        HStack(alignment: .top, spacing: 0) {
            if type == .user {
                Spacer()
            }
            if type == .ai {
                KFImage(URL(string: model.image))
                    .fade(duration: 0.25)
                    .startLoadingBeforeViewAppear(true)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
                    .padding(.trailing, 8)
            }

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.cwhite)
                    .padding(1)
                    .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.unavailableCircle, lineWidth: 1)
                }
                VStack(alignment: .leading) {
                    Text(content)
                    if let sub = content2 {
                        Divider()
                        Text(sub)
                            .font(.ptSemiBold14)
                            .foregroundStyle(.blue2)
                    }
                }
                    .font(.ptRegular14)
                    .foregroundStyle(.black)
                    .padding(16)
            }
                .frame(maxWidth: 232)
            if type == .ai {
                Spacer()
            }
        }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
    }

    @ViewBuilder
    private func bottomBtn() -> some View {
        ZStack {
            HStack {
                Button {
                    gotoModelDetailView = true
                } label: {
                    newConversationBtn()
                }
                Spacer()
                Button {
                    gotoCallingView = true
                } label: {
                    callBtn()
                }
            }.padding(.horizontal, 24)
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
    private func newConversationBtn() -> some View {
        ZStack {
            Rectangle()
                .fill(.cwhite)
                .padding(1)
                .overlay {
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .stroke(Color.blue2, lineWidth: 1)
            }
            Text("새로운 대화")
                .font(.ptSemiBold18)
                .foregroundStyle(.constantsSemi)
        }
            .frame(maxWidth: 163, maxHeight: 50)
            .background(
            NavigationLink(
                destination: ModelDetailView(gotoRoot: $gotoRoot, model: selectedModel)
                    .navigationBarHidden(true),
                isActive: $gotoModelDetailView,
                label: { EmptyView() })
        )
    }

    @ViewBuilder
    private func callBtn() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
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

            VStack {
                Text("전화하기")
                    .font(.ptSemiBold18)
                    .foregroundStyle(.cwhite)
            }
        }
            .frame(maxWidth: 163, maxHeight: 50)
            .background(
            NavigationLink(
                destination: CallingView(gotoRoot: $gotoRoot, topicTitle: topicData, model: selectedModel, callId: Int(targetCallID))
                    .navigationBarBackButtonHidden(),
                isActive: $gotoCallingView,
                label: { EmptyView() }
            )
        )
    }
}
