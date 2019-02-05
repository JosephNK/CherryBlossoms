//
//  RegularExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

extension String {
    
    /**
     한글만 체크하는 함수
     - parameters:
     - text: 문자
     - returns: 한글인지 아닌지 체크
     */
    static func checkRegularOnlyKorean(_ text: String) -> Bool {
        // Check Only Korean Regular
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣]"
        do {
            let regex = try NSRegularExpression(pattern:pattern, options:[])
            let list = regex.matches(in: text, options: [], range: NSRange.init(location: 0, length:text.count))
            if list.count <= 0 {
                return false
            }
        } catch {
            return false
        }
        
        return true
    }
    
}
