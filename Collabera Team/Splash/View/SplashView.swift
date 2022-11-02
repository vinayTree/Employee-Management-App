//
//  SplashView.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit
import RxSwift

class SplashView: BaseView {

    private let startTransitionSubject = PublishSubject<Bool>()
    var startTransitionOberver: Observable<Bool> {
        return startTransitionSubject.asObservable()
    }
            
    private lazy var containerView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Collabera \nTeam" //NSLocalizedString("SplashTitleText", comment: "")
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var splashImageView = UIImageView(image: #imageLiteral(resourceName: "collabera"))
    
    /// animated layers
    private var circularPulsingLayer = CAShapeLayer()
    private var circulatStaticLayer = CAShapeLayer()
    private var circularFillingLayer = CAShapeLayer()
    private var circularTransitionLayer = CAShapeLayer()
    
    private let pulsingAnimId = "pulsingAnimId"
    private let fillAnimId = "fillAnimId"
    private let transitionAnimId = "transitionAnimId"
    
    private let animIdKey = "animationID"
    private let strokeFillAnimIdValue = "strokeFillAnimKeyValue"
    private let transitionAnimIdValue = "transitionAnimKeyValue"
    
    override func setup() {
        setupContainerView()
        startSplashImageAnimation()
    }
    
    override func setupViews() {
        setupCircularPulsingLayer()
        setupCircularStaticLayer()
        setupCircularFillingLayer()
        
        containerView.addSubview(titleLabel)
        titleLabel.anchorCenterSuperview()
        
        setupCircularTransitionLayer()

        addSubview(splashImageView)
        splashImageView.anchorCenterSuperview(size: .init(width: 300, height: 300))
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        containerView.anchorFillSuperview()
    }
    
    private func startSplashImageAnimation() {
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseIn) {
            self.splashImageView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        } completion: { [weak self] (success) in
            self?.startLayersAnimations()

            if success {
                self?.animateContainerView()
            }
        }
    }
    
    private func animateContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1
        }
    }
        
    private func startLayersAnimations() {
        animatePuslingLayer()
        animateFillingLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circularPulsingLayer.position = center
        circulatStaticLayer.position = center
        circularFillingLayer.position = center
        circularTransitionLayer.position = center
    }
        
    private func setupCircularPulsingLayer() {
        circularPulsingLayer = createCircleShapeLayer(strokeColor: .primaryColorFaded, fillColor: .primaryColorFaded)
        containerView.layer.addSublayer(circularPulsingLayer)
    }
    
    private func setupCircularStaticLayer() {
        circulatStaticLayer = createCircleShapeLayer(strokeColor: .primaryColorFaded, fillColor: .inactiveColor)
        containerView.layer.addSublayer(circulatStaticLayer)
    }
    
    private func setupCircularFillingLayer() {
        circularFillingLayer = createCircleShapeLayer(strokeColor: .primaryColor, fillColor: .clear)
        circularFillingLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        circularFillingLayer.strokeEnd = 0
        containerView.layer.addSublayer(circularFillingLayer)
    }
    
    private func setupCircularTransitionLayer() {
        circularTransitionLayer = createCircleShapeLayer(strokeColor: .backgroundColor, fillColor: .backgroundColor, radius: 1)
        containerView.layer.addSublayer(circularTransitionLayer)
    }
    
    private func animatePuslingLayer() {
        let animData = BasicAnimData(keyPath: .transformScale, toValue: 1.5, duration: 0.8,
                                     autoreverses: true, isRemovedOnCompletion: false, repeatCount: .infinity,
                                     timingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        let animation = createBaseAnimation(animData: animData)

        circularPulsingLayer.add(animation, forKey: pulsingAnimId)
    }
    
    private func animateFillingLayer() {
        let animData = BasicAnimData(keyPath: .fillStroke, delay: 0.5, toValue: 1, duration: 3, fillMode: .forwards,
                                     autoreverses: false, isRemovedOnCompletion: false, repeatCount: 0,
                                     timingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),
        animId: strokeFillAnimIdValue, animIdKey: animIdKey)
        let animation = createBaseAnimation(animData: animData)
        animation.delegate = self

        circularFillingLayer.add(animation, forKey: fillAnimId)
    }
    
    func animateTransitionLayer() {
        let animData = BasicAnimData(keyPath: .transformScale, toValue: 100, duration: 2, fillMode: .forwards,
                                     autoreverses: false, isRemovedOnCompletion: false, repeatCount: 0,
                                     timingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),
        animId: transitionAnimIdValue, animIdKey: animIdKey)
        let animation = createBaseAnimation(animData: animData)
        animation.delegate = self

        circularTransitionLayer.add(animation, forKey: transitionAnimId)
    }
    
}

extension SplashView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animationID = anim.value(forKey: animIdKey) as? String {
            if animationID == strokeFillAnimIdValue {
                animateTransitionLayer()
            }
            else if animationID == transitionAnimIdValue {
                layer.removeAllAnimations()
                startTransitionSubject.onCompleted()
            }
        }
    }
    
}
