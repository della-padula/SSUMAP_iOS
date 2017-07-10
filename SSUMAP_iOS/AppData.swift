//
//  spot_category.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 1..
//  Copyright © 2017년 Personal. All rights reserved.
//

import Foundation
import UIKit

class AppData {
    static var category_array : [String] = ["지원센터", "카페/편의점", "병원/약국/보건실", "매장/편의시설", "교내식당", "문구/기념품", "주차장", "은행/ATM/우체국", "자동심장충격기(AED)"]
    static var category_image_array : [UIImage] = [UIImage(named: "list_info_sign")!, UIImage(named: "list_store")!, UIImage(named: "list_hospital")!, UIImage(named: "list_maejang")!, UIImage(named: "list_restaurant")!, UIImage(named: "list_present")!, UIImage(named: "list_parkinglot")!, UIImage(named: "list_money")!, UIImage(named: "list_aed")!]
    
    static var campusTour : [CampusTourItem] = [
        CampusTourItem.init("숭실대입구역 3번 출구", 37.495879, 126.954215, "내용"),
        CampusTourItem.init("문화관", 37.496297, 126.954451, "내용"),
        CampusTourItem.init("안익태기념관", 37.496034, 126.954901, "내용"),
        CampusTourItem.init("경상관", 37.496325, 126.955244, "내용"),
        CampusTourItem.init("형남공학관", 37.496109, 126.956137, "내용"),
        CampusTourItem.init("베어드홀", 37.496264, 126.956823, "내용"),
        CampusTourItem.init("학생회관", 37.496625, 126.956911, "내용"),
        CampusTourItem.init("진리관", 37.497127, 126.957254, "내용"),
        CampusTourItem.init("벤처중소기업센터", 37.497474, 126.957207, "내용"),
        CampusTourItem.init("교육관", 37.497700, 126.956799, "내용"),
        CampusTourItem.init("백마관", 37.497719, 126.956215, "내용"),
        CampusTourItem.init("한국기독교박물관", 37.495861, 126.957030, "내용"),
        CampusTourItem.init("한경직기념관", 37.495850, 126.957570, "내용"),
        CampusTourItem.init("웨스트민스터홀", 37.496718, 126.958091, "내용"),
        CampusTourItem.init("중앙도서관", 37.496275, 126.958315, "내용"),
        CampusTourItem.init("미래관", 37.495750, 126.958571, "내용"),
        CampusTourItem.init("Residence Hall", 37.495535, 126.960341, "내용"),
        CampusTourItem.init("정보과학관", 37.494669, 126.959691, "내용")]
    
    static var daumApiKey = "b342acae7fe96cfbe3363196e3ade1a3"
}
