//
//  PaywallViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI
import Localize_Swift

final class PaywallViewController: BaseViewController<PaywallViewModel> {
    
    private var nextButton = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
        
}

// MARK: - UILayout
extension PaywallViewController {
    private func setupUI() {
        setupCircleBlurBackground()
        
        view.stack(
            paywallBanner,
            paywallTitle,
            RotatingContentView().asUIKit(),
            view.stack(
                PackageButtons(vm: viewModel).asUIKit(),
                ButtonsContainer(viewModel: viewModel).asUIKit(),
                spacing: 32
            ),
            distribution: .equalSpacing
        )
        .padBottom(8)
        
        prepareDismiss()
    }
    
    private func setupCircleBlurBackground() {
        let circle1 = Circle()
            .frame(width: 80, height: 80)
            .background(Color(UIColor.appOrange).opacity(0.41))
            .blur(radius: 107)
            .asUIKit()
        
        let circle2 = Circle()
            .frame(width: 80, height: 80)
            .background(Color(UIColor.appBlue).opacity(0.4))
            .blur(radius: 107)
            .asUIKit()
        
        view.addSubview(circle1)
        circle1.topToSuperview(offset: 40, usingSafeArea: true)
        circle1.trailingToSuperview()
        
        view.addSubview(circle2)
        circle2.bottomToSuperview(offset: -250, usingSafeArea: true)
        circle2.leadingToSuperview()
        
    }
    
    private func prepareDismiss() {
        let button = Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 20, height: 20)
            .asUIKit()
        
        button.onTap { [weak self] in
            guard let self else { return }
            viewModel.didTapClose()
        }
        
        view.addSubview(button)
        button.topToSuperview(offset: 20, usingSafeArea: true)
        button.leadingToSuperview(offset: 20)
    }

    
    // MARK: cardContainer
    var cardContainer: UIView {
        
        func cardContainer(degrees: CGFloat, bgColor: UIColor, textColor: UIColor, title: String, text: String, name: String, point: String) -> some View {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(Color(uiColor: .appBlack))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color(red: 0.96, green: 0.97, blue: 0.99))
                            .cornerRadius(4)
                    }
                
                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(uiColor: textColor))
                
                HStack (alignment: .center) {
                    VStack (alignment: .leading, spacing: 0) {
                        Text(name)
                            .font(.system(size: 11))
                            .foregroundStyle(Color(uiColor: textColor))

                        Text("★ \(point)")
                            .font(.system(size: 9))
                            .foregroundStyle(Color(uiColor: textColor))
                    }
                    Spacer()
                        .frame(width: 40)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 33, height: 33)
                        .background(Color(red: 0.04, green: 0.04, blue: 0.11))
                        .cornerRadius(33)
                        .opacity(0.1)
                        .overlay(content: {
                            Image(systemName: "heart")
                                .resizable()
                                .foregroundStyle(Color(uiColor: textColor))
                                .scaledToFit()
                                .scaleEffect(0.5)
                        })
                }
            }
            .rotationEffect(Angle(degrees: degrees))
            .padding(.horizontal, 32)
            .padding(.vertical)
            .padding(.top, 20)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color(uiColor: bgColor))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 13.55, x: 0, y: 4)
                    .rotationEffect(Angle(degrees: degrees))
            }

        }
        
        return ZStack {
            
            cardContainer(
                degrees: -5.88,
                bgColor: .appBlack,
                textColor: .white,
                title: "Best Experiance 😱",
                text: "“No ads. No limits.\nCancel anytime”",
                name: "Johnson David",
                point: "5")
            .offset(x: -100, y: -75)
            
            
            cardContainer(
                degrees: 13.55,
                bgColor: .appBlue,
                textColor: .appWhite,
                title: "Boost Productivity 🚀",
                text: "“Convert multiple files\nat the same time”",
                name: "Derek Boyle (Musician)",
                point: "5")
            .offset(x:0, y: 50)
            
            cardContainer(
                degrees: 6.64,
                bgColor: .white,
                textColor: .appBlack,
                title: "Amazing Support 👑",
                text: "\"Convert any type of\naudios to 20+ formats\"",
                name: "Marry Gains (Podcaster)",
                point: "4.9")
            .offset(x:100, y: -70)

            
        }
        .frame(width: ScreenSize.width)
        .asUIKit()
    }
    
    struct ButtonsContainer: View {
        @ObservedObject var viewModel: PaywallViewModel
        var body: some View {
            VStack (spacing: 16) {
                Button {
                    didTapPurchase()
                } label: {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .frame(height: 60)
                        .foregroundStyle(Color(uiColor: .appBlue))
                        .shimmer(radius: 20)
                        .blurredBackgroundShadow(blurRadius: 25)
                        .overlay {
                            Text(viewModel.yearlySelected ? L10n.Modules.Paywall.try : L10n.Modules.Paywall.purchase)
                                .foregroundStyle(Color(uiColor: .appClearWhite))
                                .font(.system(size: 22, weight: .medium))
                        }
                        .allowsHitTesting(false)

                }
                HStack {
                    Text(L10n.Modules.Settings.Section.Other.privacy)
                        .onTapGesture {
                            didTapPrivacy()
                        }
                    Text(L10n.General.and)
                        .foregroundStyle(.secondary)
                    Text(L10n.Modules.Settings.Section.Other.terms)
                        .onTapGesture {
                            didTapTerms()
                        }
                }
                .font(.system(size: 13))
            }
            .padding(.horizontal, 30)
        }
        
        
        func didTapPurchase() {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        //    viewModel.purchase()
        }
        
        
        func didTapPrivacy() {
            viewModel.router.presentInSafari(with: .init(string: "https://docs.google.com/document/d/1LTvVWq-m_HXm2djFJhGMmRU9sQjsZ60pZUp-gH5EfMo/mobilebasic")!)
        }
        
        func didTapTerms() {
            viewModel.router.presentInSafari(with: .init(string: "https://docs.google.com/document/d/1jlTAKxcNdR6vGPGhRQyEwbdLOEzaNn9OtN8-jqE1ops/mobilebasic")!)
        }
    }
    
    var paywallBanner: UIView {
        HStack {
            if Localize.currentLanguage() == "en" {
                Spacer()
            }
        //    Image(uiImage: viewModel.paywallBannerImage)
        //        .resizable()
        //        .aspectRatio(contentMode: .fit)
        //        .frame(height: ScreenSize.height * 0.35)
        }
        .asUIKit()
    }
    
    var paywallTitle: UIView {
        Text("\(L10n.Componenets.Premium.Container.unlock) \(Text(L10n.General.premium).foregroundColor(Color(uiColor: .appBlue))) \(L10n.Componenets.Premium.features)")
            .lineLimit(2)
            .minimumScaleFactor(0.001)
            .font(.system(size: 36, weight: .bold))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(uiColor: .appBlack))
            .asUIKit()
    }
    
}

//MARK: - RotatingContentView
struct RotatingContentView: View {
    // Sayfaların içeriğini ve title'larını bir dizi olarak depolayın
    let items: [(title: String, description: String)] = [
        (L10n.Modules.Paywall.Advantages._1.title, L10n.Modules.Paywall.Advantages._1.desc),
        (L10n.Modules.Paywall.Advantages._2.title, L10n.Modules.Paywall.Advantages._2.desc),
        (L10n.Modules.Paywall.Advantages._3.title, L10n.Modules.Paywall.Advantages._3.desc)
    ]
    
    // Mevcut sayfa indeksini depolamak için bir state
    @State private var currentIndex: Int = 0
    
    // Otomatik geçiş için bir Timer kullanın
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    init() {
        // UIPageControl appearance'ını ayarlama
        UIPageControl.appearance().currentPageIndicatorTintColor = .appBlue
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.appBlue.withAlphaComponent(0.2)
    }

    var body: some View {
        // Sayfa gösterimi için bir TabView oluşturun
        TabView(selection: $currentIndex) {
            ForEach(items.indices, id: \.self) { index in
                VStack (spacing: 8) {
                    Text(items[index].title)
                        .font(.system(size: 17, weight: .semibold))
                    Text(items[index].description)
                        .font(.system(size: 13, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10) // Yatay padding'i azaltın veya kaldırın
                .padding(.vertical, 5) // Dikey padding'i azaltın veya kaldırın
                .tag(index)
            }
        }
        .frame(height: 100)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
        
    }
}

// MARK: - PackageButtons
struct PackageButtons: View {
    @ObservedObject var vm: PaywallViewModel
    
    @State var yearlyPrice = "-"
    @State var weeklyPrice = "-"
    @State var yearlyAsWeeklyPrice = "-"
    
    var body: some View {
        HStack (spacing: 16) {
            
            // Haftalık Buton
            Button(action: {
                vm.yearlySelected = false
            }) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(L10n.Modules.Paywall.weekly)
                            .font(.system(size: 13, weight: .semibold))
                        Spacer()
                        VStack (alignment: .leading) {
                            Text(weeklyPrice)
                                .font(.system(size: 17, weight: .heavy))
                            Text("/\(L10n.Modules.Paywall.week.lowercased())")
                                .font(.system(size: 15, weight: .regular))
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .foregroundStyle(Color(uiColor: .appBlack))
                .padding(.vertical, 8)
                .frame(width: (ScreenSize.width - 76) / 2)
                .frame(height: ScreenSize.height * 0.12)
                .makeGradientBackground(singleColor: false, cornerRadius: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(!vm.yearlySelected ? Color(uiColor: .appBlue) : Color(uiColor: .appClearWhite), lineWidth: 1)
                )
            }
            
            // Yıllık Buton
            Button(action: {
                vm.yearlySelected = true
            }) {
                HStack {
                    VStack (alignment: .leading) {
                        VStack (alignment: .leading) {
                            Text(L10n.Modules.Paywall.yearly)
                                .font(.system(size: 13, weight: .semibold))
                            Text("\(yearlyAsWeeklyPrice)/\(L10n.Modules.Paywall.week.lowercased())")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color(uiColor: .appHeather))
                        }
                        Spacer()
                        VStack (alignment: .leading) {
                            Text(yearlyPrice)
                                .font(.system(size: 17, weight: .heavy))
                            Text("/\(L10n.Modules.Paywall.year.lowercased())")
                                .font(.system(size: 15, weight: .regular))
                        }
                        .foregroundStyle(Color(uiColor: .appBlue))
                        
                    }
                    .foregroundStyle(Color(uiColor: .appBlack))
                    .padding(.horizontal)
                    Spacer()
                }
                .foregroundStyle(.black)
                .padding(.vertical,8)
                .frame(width: (ScreenSize.width - 76) / 2)
                .frame(height: ScreenSize.height * 0.12)
                .makeGradientBackground(singleColor: false, cornerRadius: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(vm.yearlySelected ? Color(uiColor: .appBlue) : Color(uiColor: .appClearWhite), lineWidth: 1)
                )
                .overlay(alignment: .topTrailing, content: {
                    Text("-%92")
                        .foregroundStyle(.white)
                        .font(.system(size: 9, weight: .semibold))
                        .padding(.vertical, 4)
                        .padding(.trailing, 4)
                        .padding(.leading, 24)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(Color(uiColor: .appBlue))
                        }
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 4, y: 4)
                        .padding(.top, 16)
                        .padding(.trailing, -8)
                })
                
            }
            
        }
        .onAppear {
           //Removed as no longer necessary!
            }
        }
    }

    func prepareYearlyAsWeeklyPrice() {
     //   var yearlyPriceDecimal: Double {
      //      let decimalPrice = RevenueHelper.shared.getPackage(for: .yearly)?.storeProduct.price ?? 0
      //      return NSDecimalNumber(decimal: decimalPrice).doubleValue
     //   }
        
    //    let price = String(format: "%.2f", (yearlyPriceDecimal / 52))
      //  yearlyAsWeeklyPrice = "\(Locale.current.currencySymbol ?? "")\(price)"
    }

    

