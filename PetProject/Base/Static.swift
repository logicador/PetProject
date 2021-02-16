//
//  Static.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


public let PROJECT_URL = "http://121.138.167.244:3004"
public let ADMIN_URL = "http://54.180.183.34:3000"
public let IMAGE_URL = PROJECT_URL + "/images"
public let API_URL = PROJECT_URL + "/api"
public let PROJECT_APP_KEY = "abcdefghijklmnopqrstuvwxyz"
public let KAKAO_NATIVE_APP_KEY = "cef47db07a553aad0315ae044de2efb5"
public let HTTP_TIMEOUT: TimeInterval = 10

public let SPACE_XXXXXXL: CGFloat = 120
public let SPACE_XXXXXL: CGFloat = 90
public let SPACE_XXXXL: CGFloat = 70
public let SPACE_XXXL: CGFloat = 50
public let SPACE_XXL: CGFloat = 40
public let SPACE_XL: CGFloat = 30
public let SPACE_L: CGFloat = 25
public let SPACE: CGFloat = 20
public let SPACE_S: CGFloat = 15
public let SPACE_XS: CGFloat = 10
public let SPACE_XXS: CGFloat = 5
public let SPACE_XXXS: CGFloat = 4
public let SPACE_XXXXS: CGFloat = 3
public let SPACE_XXXXXS: CGFloat = 2
public let SPACE_XXXXXXS: CGFloat = 1

public let CONTENTS_RATIO_XXXL: CGFloat = 0.98
public let CONTENTS_RATIO_XXL: CGFloat = 0.96
public let CONTENTS_RATIO_XL: CGFloat = 0.94
public let CONTENTS_RATIO_L: CGFloat = 0.92
public let CONTENTS_RATIO: CGFloat = 0.9
public let CONTENTS_RATIO_S: CGFloat = 0.88
public let CONTENTS_RATIO_XS: CGFloat = 0.86
public let CONTENTS_RATIO_XXS: CGFloat = 0.84
public let CONTENTS_RATIO_XXXS: CGFloat = 0.8
public let CONTENTS_RATIO_XXXXS: CGFloat = 0.76
public let CONTENTS_RATIO_XXXXXS: CGFloat = 0.72
public let CONTENTS_RATIO_XXXXXXS: CGFloat = 0.66
public let CONTENTS_RATIO_XXXXXXXS: CGFloat = 0.6
public let CONTENTS_RATIO_XXXXXXXXS: CGFloat = 0.54

public let COMPRESS_IMAGE_QUALITY: CGFloat = 0.2

public let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

public let CONFIRM_BUTTON_HEIGHT: CGFloat = 65

public let LINE_WIDTH: CGFloat = 0.5

public let KOR_CHAR_LIST: [Character] = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ", "ㄳ", "ㄵ", "ㄶ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ"]

let BODYPARTS: [BodyPart] = [
    BodyPart(id: 1, name: "심장 및 혈액 질환"),
    BodyPart(id: 2, name: "호흡기 질환"),
    BodyPart(id: 3, name: "소화기 질환"),
    BodyPart(id: 4, name: "비뇨기 질환"),
    BodyPart(id: 5, name: "생식기 질환"),
    BodyPart(id: 6, name: "뇌/신경 질환"),
    BodyPart(id: 7, name: "내분비 질환"),
    BodyPart(id: 8, name: "근골격계 질환"),
    BodyPart(id: 9, name: "피부질환"),
    BodyPart(id: 10, name: "감염성 질환"),
    BodyPart(id: 11, name: "눈의 질병"),
    BodyPart(id: 12, name: "귀의 질병"),
    BodyPart(id: 13, name: "이빨/구강 질환"),
    BodyPart(id: 0, name: "기타")
]
