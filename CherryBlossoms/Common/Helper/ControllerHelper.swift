//
//  ControllerHelper.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     스토리보드로 부터 컨트롤러 가져오는 함수
     - parameters:
     - name: 스토리보드 이름
     - identifier: 식별자
     */
    func getControllerFromStoryboard(withStoryboardName name: String, withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    /**
     스토리보드로 부터 가져온 컨트롤러를 네비게이션에 Push 하는 함수
     - parameters:
     - name: 스토리보드 이름
     - identifier: 식별자
     - beforePush: 푸쉬 이전에 처리 할 수 있는 클로저 함수
     */
    func pushViewControllerByStoryboard(withStoryboardName name: String, withIdentifier identifier: String, beforePush: ((_ controller: UIViewController) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        if let c = beforePush {
            c(controller)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension UIViewController {
    
    /**
     SearchController에 하단 라인 없애기
     - parameters:
     - searchController: SearchController
     */
    func removeBottomLineFormSearchController(_ searchController: UISearchController) {
        let lineView = UIView(frame: CGRect(x: 0, y: searchController.searchBar.frame.height-4, width: self.view.bounds.width, height: 1))
        lineView.backgroundColor = .white
        searchController.searchBar.addSubview(lineView)
    }
    
}

extension UIViewController {
    
    /**
     네비게이션바에 검색바 셋팅 하는 함수
     - parameters:
     - searchController: SearchController
     */
    func applyLargeTitleWithSearchNavigationBar(_ searchController: UISearchController) {
        // Large Title Setup
        self.definesPresentationContext = true
		if #available(iOS 11.0, *) {
			self.navigationItem.searchController = searchController
			self.navigationItem.hidesSearchBarWhenScrolling = false
			self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
																				 NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
		} else {
			// Fallback on earlier versions
		}
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
}

extension UIViewController {
    
    /**
     이미지를 네이게이션바 타이블뷰에 셋팅
     - parameters:
     - image: 이미지
     - returns: 이미지뷰
     */
    func getCustomTitleImageView(withImage image: UIImage?) -> UIImageView? {
        let titleImgView = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        titleImgView.backgroundColor = UIColor.clear
        titleImgView.image = image
        titleImgView.layer.cornerRadius = 8.0
        titleImgView.clipsToBounds = true
        return titleImgView
    }
    
    /**
     네이게이션바 커스텀 버튼 만들어 주는 함수
     - parameters:
     - title: 타이틀명
     - backgroundColor: 배경색상
     - returns: Tuple barItem - UIBarButtonItem, button - UIButton
     */
    func getCustomBarButton(title: String, backgroundColor: UIColor) -> (barItem: UIBarButtonItem, button: UIButton) {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        button.backgroundColor = backgroundColor
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 24.0, bottom: 6.0, right: 24.0)
        button.layer.cornerRadius = 14.0
        return (UIBarButtonItem(customView: button), button)
    }
    
}

