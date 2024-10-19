//
//  HistoryViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

final class HistoryViewController: BaseViewController<HistoryViewModel> {
    
    private let navBar = NavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.titleString = L10n.Modules.History.title
        navBar.setReorderHidden(false)
        navBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

// MARK: - NavBarDelegate
extension HistoryViewController: NavBarDelegate {
    func didTapReorder() {
        UIImpactFeedbackGenerator().impactOccurred()
        withAnimation {
            viewModel.reversed.toggle()
            viewModel.cacheModels.reverse()
        }
    }
}

extension HistoryViewController {
    private func setupUI() {
        setupSafeAreaContainer()
        view.backgroundColor = .appClearWhite
        
        safeAreaContainer.stack(
            navBar,
            contentContainer()
        ).withMargins(.init(top: 30, left: 30, bottom: -30, right: 30))
    }
    
    private func contentContainer() -> UIView {
        HistoryTable(vm: viewModel).asUIKit()
    }
        
}

// MARK: - Views

struct HistoryTable: View {
    @ObservedObject var vm: HistoryViewModel

    var body: some View {
        
        GeometryReader(content: { geometry in
            let size = geometry.size
            let bigImageWidth: CGFloat = size.width - (size.width - 20) / 3 - 10
            let smallImageWidth: CGFloat = (size.width - 20) / 3
            
            let gridItems = [GridItem(.fixed((size.width - 20) / 3), spacing: 10, alignment: .leading),
                                  GridItem(.fixed((size.width - 20) / 3), spacing: 10, alignment: .leading),
                                  GridItem(.fixed((size.width - 20) / 3), spacing: 10, alignment: .leading)]
            
            ScrollView (showsIndicators: false) {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(vm.cacheModels.indices) { i in
                        
                        HistoryCell(model: vm.cacheModels[i])
                            .frame(width: i == 0 ? bigImageWidth : smallImageWidth, height: i == 0 ? bigImageWidth : smallImageWidth)
                            .frame(height: smallImageWidth, alignment: .top)
                            .onTapGesture {
                                didTapGoDetail(model: vm.cacheModels[i])
                            }
                        
                        if i == 0 {
                            Color.clear
                        }
                        
                        if i == 1 {
                            Group {
                                Color.clear
                                Color.clear
                            }
                        }
                    }
                }
            }
            .animation(.spring, value: vm.reversed)
        })
        .padding(.top, 8)
        .overlay(content: {
            if vm.cacheModels.isEmpty {
                VStack(spacing: 16) {
                    Image(uiImage: .imgEmptyBanner)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 125)
                    Text(L10n.Modules.History.empty)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(UIColor.appHeather))
                }
            }
        })
    }
    
    func didTapGoDetail(model: CacheModel) {
        
        UIImpactFeedbackGenerator().impactOccurred()
        vm.showRating()
        
        let outputParameters = ConvertHelper.OutputParameters(
            name: model.name,
            startSecond: model.startSecond,
            finishSecond: model.finishSecond,
            format: ConvertHelper.OutputFormat(rawValue: model.format)!,
            bitrate: ConvertHelper.BitRate(rawValue: model.bitrate)!,
            sampleRate: ConvertHelper.SampleRate(rawValue: model.sampleRate)!,
            volume: model.volume,
            channels: model.channels,
            speed: model.speed,
            image: UIImage(data: model.imageData) ?? UIImage()
        )
        
        vm.router.presentExport(parameters: .init(
            rootNav: vm.router.viewController?.navigationController ?? .init(),
            assetURL: .init(string: model.url)!,
            outputParameters: outputParameters,
            comesFromCache: true
        )
        )
    }
}

struct HistoryCell: View {
    var model: CacheModel
    
    @State var size: CGSize = .zero
    
    var body: some View {
            GeometryReader(content: { geometry in
                let size = geometry.size
                VStack {
                    Image(systemName: "waveform")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: size.width * 0.4, height: size.width * 0.4)
                        .padding(.bottom, size.height * 0.2)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .onAppear(perform: {
                    self.size = size
                })
            })
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background {
            ZStack {
                Image(uiImage: .init(data: model.imageData) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Color.black.opacity(0.35)
            }
        }
        .overlay(alignment: .bottom, content: {
            HStack(spacing: size.width * 0.05, content: {
                Text(model.format)
                    .font(.system(size: size.width * 0.07, weight: .medium))
                    .minimumScaleFactor(0.001)
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width * 0.1, height: size.width * 0.1)
            })
            .foregroundStyle(.white)
            .padding(.trailing, size.width * 0.05)
            .padding(.leading, size.width * 0.1)
            .frame(height: size.height * 0.2)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.bottom,size.height * 0.08 )
        })
        .cornerRadius(10)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .appWhite), lineWidth: 2)
        )

    }
}
