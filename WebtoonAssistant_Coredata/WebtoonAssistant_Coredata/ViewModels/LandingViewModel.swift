//
//  LandingViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/12.
//

import Foundation
import UIKit

final class LandingViewModel : ObservableObject {
    func openAppStore(appType: Provider) {
        let appId = appType.rawValue
        let url = "https://apps.apple.com/kr/app/" + appId;
//        let url = "https://m.naver.com"
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
//    URL Scheme을 전달하면 앱 열 수 있음
//    func openApp() {
//        let kakaoTalk = "kakaotalk://"
//        let kakaoTalkURL = NSURL(string: kakaoTalk)
//
//        if (UIApplication.shared.canOpenURL(kakaoTalkURL! as URL)) {
//            UIApplication.shared.open(kakaoTalkURL! as URL)
//        }
//        else {
//            print("No kakaotalk installed.")
//        }
//    }
}

extension LandingViewModel {
    enum Provider : String {
        case Naver = "%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%9B%B9%ED%88%B0-naver-webtoon/id315795555"
        case Kakao = "%EC%B9%B4%EC%B9%B4%EC%98%A4%EC%9B%B9%ED%88%B0-kakao-webtoon/id736602666"
    }
}
