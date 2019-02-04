//
//  ViewHelper.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

struct GlobalViewTag {
    static let BottomLiewViewTag: Int = 93493
    static let DimLiewViewTag: Int = 34832
}

extension UIView {
    
    /**
     뷰 하단 라인 설정 함수
     */
    func setBottomLine() {
        guard let _ = self.viewWithTag(GlobalViewTag.BottomLiewViewTag) else {
            let lineView = UIView()
            lineView.tag = GlobalViewTag.BottomLiewViewTag
            lineView.backgroundColor = UIColor(hexString: "#CDCDD2")
            self.addSubview(lineView)
            
            lineView.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(16.0)
                make.right.equalTo(self).offset(-16.0)
                make.bottom.equalTo(self)
                make.height.equalTo(1.0)
            }
            return
        }
    }
    
    /**
     DimView 설정 및 Hidden 함수
     - parameters:
     - hidden: 숨김여부
     */
    func setDimViewHidden(_ hidden: Bool) {
        var dimView = self.viewWithTag(GlobalViewTag.DimLiewViewTag)
        
        if hidden {
            dimView?.removeFromSuperview()
            dimView = nil
            return
        }
        
        if dimView == nil {
            dimView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height))
            dimView?.tag = GlobalViewTag.DimLiewViewTag
            dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.45)
            dimView?.alpha = 0.0
            self.addSubview(dimView!)
            self.bringSubviewToFront(dimView!)
            UIView.animate(withDuration: 0.25) {
                dimView?.alpha = 0.45
            }
        }
    }
    
}

extension UITableView {
    
    /**
     테이블 뷰 reloadSections 애니메이션 설정 함수
     - parameters:
     - sections: sections
     - animated: 애니메이션 여부
     */
    func reloadSections(_ sections: IndexSet, animated: Bool) {
        if animated {
            self.reloadSections(sections, with: .automatic)
        } else {
            UIView.setAnimationsEnabled(false)
            self.reloadSections(sections, with: .none)
            UIView.setAnimationsEnabled(true)
        }
    }
    
}
