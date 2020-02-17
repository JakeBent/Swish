//
//  UIViewController.swift
//  Swish
//
//  Created by Jacob Benton on 2/13/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit
import UICircularProgressRing

extension UIViewController {
    var loadingViewTag: Int { return 666 }
    var progressBarTag: Int { return 667 }
    var progressBar: UICircularProgressRing {
        let progressBar = UICircularProgressRing()
        progressBar.tag = progressBarTag
        progressBar.style = .bordered(width: 3, color: .main)
        progressBar.innerRingColor = .main
        progressBar.maxValue = 100
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }
    var loadingView: UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.tag = loadingViewTag
        view.translatesAutoresizingMaskIntoConstraints = false
        let bar = progressBar
        view.addSubview(bar)
        bar.pinCenterX(to: view.centerXAnchor)
        bar.pinCenterY(to: view.centerYAnchor)
        bar.pinHeight(toConstant: 100)
        bar.pinWidth(to: bar.heightAnchor)
        return view
    }
    
    func setProgress(_ progress: Double) {
        DispatchQueue.main.async { [weak self] in
            if let sself = self,
                let bar = sself.view.viewWithTag(sself.progressBarTag) as? UICircularProgressRing {
                bar.startProgress(to: CGFloat(progress * 100), duration: 0.2)
            }
        }
    }
    
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let sself = self {
                if loading {
                    let newLoadingView = sself.loadingView
                    sself.view.insertSubview(newLoadingView, at: 999)
                    newLoadingView.pinToEdges(of: sself.view)
                } else {
                    Thread.sleep(forTimeInterval: 0.5)
                    
                    let oldLoadingView = sself.view.viewWithTag(sself.loadingViewTag)
                    UIView.animate(withDuration: 0.3, animations: {
                        oldLoadingView?.alpha = 0
                    }) { _ in
                        oldLoadingView?.removeFromSuperview()
                    }
                }
            }
        }
    }
}
