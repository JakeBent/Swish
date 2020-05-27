//
//  ExpandingScrollCell.swift
//  Swish
//
//  Created by Jacob Benton on 3/10/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit

class ExpandingScrollCell: UIView {
    var isExpanded = false
    var canExpand: Bool { true }
    var collapsedHeight: CGFloat { Layout.viewHeight / 4 }

    let titleLabel = Generators.makeLabel(fontSize: 18, weight: .bold)
    let expandButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "expand"), color: .black)
    let shrinkButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "shrink"), color: .black)
    let container = Generators.makeView()
    
    weak var parentScrollView: UIScrollView?
    var expandedContentOffset: CGPoint?
    
    var topLevelViews: [UIView] {
        [titleLabel, shrinkButton, expandButton, container]
    }
    
    var containerHeightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        topLevelViews.forEach { view in
            addSubview(view)
        }

        titleLabel.pinTop(to: topAnchor, constant: 8)
        titleLabel.pinLeft(to: leftAnchor, constant: 16)
        titleLabel.pinHeight(toConstant: 32)
        
        expandButton.pinRight(to: rightAnchor, constant: -16)
        expandButton.pinHeight(to: titleLabel.heightAnchor)
        expandButton.pinWidth(to: expandButton.heightAnchor)
        expandButton.pinCenterY(to: titleLabel.centerYAnchor)
        
        shrinkButton.pinRight(to: expandButton.rightAnchor)
        shrinkButton.pinLeft(to: expandButton.leftAnchor)
        shrinkButton.pinBottom(to: expandButton.bottomAnchor)
        shrinkButton.pinTop(to: expandButton.topAnchor)
        shrinkButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        container.pinLeft(to: leftAnchor, constant: 8)
        container.pinRight(to: rightAnchor, constant: -8)
        container.pinTop(to: titleLabel.bottomAnchor, constant: 8)
        container.pinBottom(to: bottomAnchor, constant: -8)
        
        if canExpand {
            containerHeightConstraint = container.heightAnchor.constraint(equalToConstant: collapsedHeight)
            NSLayoutConstraint.activate([containerHeightConstraint])
        }
        
        expandButton.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
        shrinkButton.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
        
        expandButton.isHidden = !canExpand
        shrinkButton.isHidden = !canExpand
    }
    
    @objc func expandTapped() {
        if !isExpanded {
            expandedContentOffset = parentScrollView?.contentOffset
        }
        isExpanded = !isExpanded
        expandButton.isEnabled = !isExpanded
        shrinkButton.isEnabled = isExpanded
        
        if isExpanded {
            parentScrollView?.isScrollEnabled = false
            containerHeightConstraint.constant = (parentScrollView?.frame.height ?? Layout.viewHeight) - 56
            UIView.animate(withDuration: 0.35) { [weak self] in
                self?.expandButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.shrinkButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.parentScrollView?.contentOffset = CGPoint(
                    x: 0,
                    y: self?.frame.origin.y ?? 0
                )
                self?.parentScrollView?.layoutIfNeeded()
            }
        } else {
            containerHeightConstraint.constant = collapsedHeight
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                self?.shrinkButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.expandButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.parentScrollView?.contentOffset = self?.expandedContentOffset ?? .zero
                self?.parentScrollView?.layoutIfNeeded()
            }) { [weak self] _ in
                self?.parentScrollView?.isScrollEnabled = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
