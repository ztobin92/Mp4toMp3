//
//  BatchExportViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 24.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

final class BatchExportViewController: BaseViewController<BatchExportViewModel> {
    
    let navBar = NavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.titleString = L10n.Modules.Export.title
        navBar.delegate = self
        navBar.setCloseHidden(false)
        navBar.setEditHidden(false)
    }
    
}

extension BatchExportViewController: NavBarDelegate {
    func didTapClose() {
        viewModel.didTapClose()
    }
    
    func didTapEdit() {
        viewModel.router.close()
    }
}

// MARK: - UILayout
extension BatchExportViewController {
    private func setupUI() {
        view.stack(
            view.stack(navBar).padLeft(30).padRight(30),
            contentContainer(),
            spacing: 32
        )
        .padTop(30)
    }
    
    private func contentContainer() -> UIView {

        return MainScrollView(viewModel: viewModel)
        .asUIKit()
    }
}

struct MainScrollView: View {
    
    @ObservedObject var viewModel: BatchExportViewModel
    @State  var downloadTipSeenState = false
    @AppStorage("downloadTipSeen") var downloadTipSeen = false
    
    var body: some View {
        ScrollView(content: {
            LazyVStack(spacing: 16, content: {
                if !downloadTipSeenState {
                    HStack(content: {
                        Text(L10n.Modules.Batch.tip)
                            .font(.system(size: 11))
                            .padding(.vertical, 8)
                            .foregroundStyle(Color(uiColor: .appBlue))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(uiColor: .appBlue))
                    })
                    .padding(.horizontal, 10)
                    .makeGradientBackground(singleColor: false)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: didTapCloseDownloadTip)
                }
                ForEach(viewModel.parameters.urls.indices, id: \.self) { i in
                    BatchPlayerCell(index: i, vm: self.viewModel)
                }
                Spacer()
                    .frame(height: 80)
            })
            .padding(.horizontal, 30)
        })
        .overlay(alignment: .bottom, content: {
            HStack (spacing: 16) {
                shareButton
                downloadButton
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
        })
        .onAppear(perform: {
            downloadTipSeenState = downloadTipSeen
        })
    }
    
    var downloadButton: some View {
        Button {
            didTapDownload()
        } label: {
            HStack {
                HStack(alignment: .center, spacing: 8) {
                    Image(uiImage: .icDownload.withRenderingMode(.alwaysTemplate))
                        .resizable()
                        .foregroundStyle(Color(uiColor: .appBlue))
                        .aspectRatio(contentMode: .fit)
                }
                .foregroundStyle(Color(uiColor: .appBlue))
                .padding(.horizontal)
                .padding(.vertical, 16)
                .frame(width: 50, height: 50)
                .makeGradientBackground(singleColor: false, cornerRadius: 10)
                .cornerRadius(10)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(uiColor: .appBlue), lineWidth: 1)
                )
            }
        }

    }
    
    var shareButton: some View {
        Button {
            didTapShare()
        } label: {
            HStack {
                HStack(alignment: .center, spacing: 8) {
                    Spacer()
                    Image(uiImage: .icShare.withRenderingMode(.alwaysTemplate))
                        .resizable()
                        .foregroundStyle(Color(uiColor: .appBlue))
                        .aspectRatio(contentMode: .fit)
                    Text("\(L10n.Modules.Batch.share) (\(viewModel.parameters.urls.count))")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                }
                .foregroundStyle(Color(uiColor: .appBlue))
                .padding(.horizontal)
                .padding(.vertical, 16)
                .frame(height: 50)
                .makeGradientBackground(singleColor: false, cornerRadius: 10)
                .cornerRadius(10)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(uiColor: .appBlue), lineWidth: 1)
                )
            }
        }
    }
    
    
    func didTapCloseDownloadTip() {
        downloadTipSeen = true
        downloadTipSeenState = true
    }
    
    func didTapDownload() {
        viewModel.downloadAll()
    }
    
    func didTapShare() {
        viewModel.shareAll()
    }

}

// MARK: - Views
struct BatchPlayerCell: View {
    @StateObject var manager = AudioPlayerManager()
    var index: Int
    @ObservedObject var vm: BatchExportViewModel
    
    var body: some View {
        HStack (alignment: .center) {
            VStack(alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("\(vm.parameters.allOutputParameters[index].name).\(vm.parameters.allOutputParameters[index].format.rawValue.lowercased())")
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                    BatchAudioWaveformView(manager: manager)
                    HStack {
                        Text(manager.currentTime)
                        Spacer()
                        Text(manager.endTime)
                    }
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 10)
            .padding(.vertical, 12)
        }
        .frame(height: 75)
        .makeGradientBackground(singleColor: false, cornerRadius: 10)
        .padding(.leading, 30)
        .overlay(alignment: .leading, content: {
            Image(uiImage: vm.parameters.allOutputParameters[index].image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .overlay(.black.opacity(0.4))
                .overlay(content: {
                    Image(systemName: manager.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                })
                .overlay(alignment: .bottom, content: {
                    HStack(spacing: 4, content: {
                        Text(vm.parameters.allOutputParameters[index].format.rawValue)
                            .font(.system(size: 8, weight: .medium))
                    })
                    .padding(.trailing, 8)
                    .padding(.leading, 8)
                    .padding(.vertical, 4)
                    .foregroundStyle(.white)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 7)
                })
                .cornerRadius(10)
                .onTapGesture(perform: didTapPlay)
                .blurredBackgroundShadow(blurRadius: 10)
        })
        .frame(height: 75)
        .onAppear(perform: setupPlayer)
    }
    
    func setupPlayer() {
        manager.url = vm.parameters.urls[index]
        manager.setupPlayer()
        vm.allPlayerManagers.append(manager)
    }
    
    func didTapPlay() {
        vm.allPlayerManagers.filter({$0 != manager}).forEach { pm in
            if pm.isPlaying {pm.playPause()}
        }
        manager.playPause()
    }
    
    public struct BatchAudioWaveformView: View {
        @State private var dragOffset: CGFloat = 0 // Kullanıcının kaydırma yer değiştirmesi
        @ObservedObject var manager: AudioPlayerManager
        
        var body: some View {
            GeometryReader { geometry in
                VStack {
                    HStack(spacing: 2) {
                        ForEach(0..<manager.audioSamples.count, id: \.self) { index in
                            Capsule()
                                .fill(index < Int(manager.playbackPosition * CGFloat(manager.audioSamples.count)) ? Color(uiColor: .appBlue) : Color(uiColor: .appHeather.withAlphaComponent(0.5)))
                                .frame(height: geometry.size.height * manager.audioSamples[index])
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let totalWidth = geometry.size.width
                            dragOffset = min(max(0, gesture.location.x), totalWidth)
                            manager.playbackPosition = dragOffset / totalWidth
                            manager.updatePlaybackPosition(newPosition: dragOffset/totalWidth)
                        }
                )
            }
            .frame(height: 30)
        }
    }
}
