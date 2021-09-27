//
//  LandingView.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/12.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var viewModel = LandingViewModel()
    
    var title : some View {
        Text("Webtoon Assistant")
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundColor(.white)
            .shadow(radius: 10)
    }
    var bookmarkLink : some View {
        NavigationLink(destination : ContentView()) {
            Text("북마크 모아보기")
                .fontWeight(.semibold)
                .frame(width : 250, height: 50)
                .foregroundColor(.black)
                .background(Color.yellow)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
    var appendixButton : some View {
        HStack(spacing : 20) {
            Button {
                viewModel.openAppStore(appType: .Naver)
            } label : {
                VStack {
                    Image("naverW")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    Text("네이버 웹툰")
                }
            }
            
            Button {
                viewModel.openAppStore(appType: .Kakao)
            } label : {
                VStack {
                    Image("kakaoW")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    Text("카카오 웹툰")
                }
            }
                
            VStack(spacing : 4) {
                NavigationLink(destination : SettingsView()) {
                    Image(systemName: "gearshape.2.fill")
                        .font(.system(size : 30))
                        .frame(width: 70, height: 70)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                Text("설정")
            }
        }.padding(.bottom, 40)
        .foregroundColor(.white)
        .font(.system(size : 12))
        .shadow(radius: 15)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 100)
                title
                Spacer()
                bookmarkLink.padding(.bottom, 50)
                appendixButton
            } // VStack
            .frame(maxWidth : .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .overlay(Color.black.opacity(0.7))
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
            )
        } // NavigationView
    }
}
