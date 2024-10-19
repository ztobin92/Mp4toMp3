//
//  UIView+Extensions.swift
//  UIComponents
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import UIKit

final class ClickListener: UITapGestureRecognizer {
    private var action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc
    private func execute() {
        action()
    }
}


public extension UIView {
    func onTap(_ action: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let click = ClickListener(action)
        self.addGestureRecognizer(click)
    }
}

import SwiftUI

public extension SwiftUI.View {
    // SwiftUI objesini UIKit ile uyumlu bir UIView olarak döndüren fonksiyon
    func asUIKit() -> UIView {
        // SwiftUI objesini bir UIHostingController'a atayalım
        let controller = UIHostingController(rootView: self)
        // UIHostingController'ın view'ini alalım
        let view = controller.view
        // view'ın arka plan rengini şeffaf yapalım
        view?.backgroundColor = .clear
        // view'ı döndürelim
        return view!
    }
}

// UIView için bir extension oluşturun
public extension UIView {
    // UIView'ı SwiftUI View'ına dönüştüren fonksiyon
    func asSwiftUI() -> some View {
        // UIViewRepresentable protokolünü uygulayan bir yapı oluşturun
        UIViewWrapper(view: self)
    }
}

// UIView'ı temsil edecek yapı
public struct UIViewWrapper<UIViewType: UIView>: UIViewRepresentable {
    let view: UIViewType

    // UIViewRepresentable protokolünü uygulayın
    public func makeUIView(context: Context) -> UIViewType {
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        // UIView güncellendiğinde yapılacak işlemler
    }
}

public extension View {
    func makeGradientBackground(singleColor: Bool = true, cornerRadius: CGFloat = 10, borderColor: UIColor = .appClearWhite) -> some View {
        self
            .background(
                Rectangle()
                    .foregroundColor(.clear)
                    .background(content: {
                        if singleColor {
                            Color(uiColor: .appWhite)
                        } else {
                            LinearGradient(
                              stops: [
                                Gradient.Stop(color: Color(uiColor: .appClearWhite).opacity(0.72), location: 0.00),
                                Gradient.Stop(color: Color(uiColor: .appClearWhite).opacity(0.36), location: 1.00),
                              ],
                              startPoint: UnitPoint(x: 0, y: 0),
                              endPoint: UnitPoint(x: 1, y: 1.02)
                            )

                        }
                    })
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .inset(by: 0.5)
                            .stroke(Color(uiColor: borderColor), lineWidth: 1)
                    )
            )
    }
}


public struct ShimmerEffect: ViewModifier {
    var isActive: Bool
    @State private var isVisible = false
    var radius: CGFloat = 0
    
    public func body(content: Content) -> some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.7), Color.clear]),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        return content
            .overlay(
                ZStack {
                    if isActive {
                        gradient
                            .frame(width: UIScreen.main.bounds.width / 2)
//                            .mask(content)
                            .padding(.horizontal, 30)
                            .offset(x: isVisible ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width / 2)
                            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isVisible)
                            .onAppear {
                                isVisible = true
                            }
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

public extension View {
    func shimmer(isActive: Bool = true, radius: CGFloat = 0) -> some View {
        self.modifier(ShimmerEffect(isActive: isActive, radius: radius))
    }
}

public struct BouncyButtonEffect: ViewModifier {
    @State private var isPressed: Bool = false

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .onTapGesture {
                withAnimation {
                    self.isPressed = true
                }
                withAnimation {
                    self.isPressed = false
                }
            }
    }
}

public extension View {
    func bouncyButton() -> some View {
        self.modifier(BouncyButtonEffect())
    }
}


public extension View {
    func blurredBackgroundShadow(blurRadius: CGFloat = 25) -> some View {
        self
            .background(alignment: .bottom, content: {
                GeometryReader { geo in
                    let size = geo.size
                    self
                        .opacity(0.5)
                        .scaleEffect(0.8)
                        .blur(radius: blurRadius) // Blur efektini uygula
                        .offset(y: size.height * 0.2) // Belirtilen y kadar offset uygula
                }
            })
    }
}

let keyboardSpaceD = KeyboardSpace()
public extension View {
    func keyboardSpace() -> some View {
        modifier(KeyboardSpace.Space(data: keyboardSpaceD))
    }
}

import Combine
class KeyboardSpace: ObservableObject {
    var sub: AnyCancellable?
    
    @Published var currentHeight: CGFloat = 0
    var heightIn: CGFloat = 0 {
        didSet {
            withAnimation {
                if UIWindow.keyWindow != nil {
                    //fix notification when switching from another app with keyboard
                    self.currentHeight = heightIn
                }
            }
        }
    }
    
    init() {
        subscribeToKeyboardEvents()
    }
    
    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height - (UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0)}
    
    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }
    
    private func subscribeToKeyboardEvents() {
        sub?.cancel()
        sub = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.self.heightIn, on: self)
    }
    
    deinit {
        sub?.cancel()
    }
    
    struct Space: ViewModifier {
        @ObservedObject var data: KeyboardSpace
        
        func body(content: Content) -> some View {
            VStack(spacing: 0) {
                content
                
                Rectangle()
                    .foregroundColor(Color(.clear))
                    .frame(height: data.currentHeight)
                    .frame(maxWidth: .greatestFiniteMagnitude)

            }
        }
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive }
            .flatMap { $0 as? UIWindowScene }?.windows
            .first { $0.isKeyWindow }
        return keyWindow
    }
}
