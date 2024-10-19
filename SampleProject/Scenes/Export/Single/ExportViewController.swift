//
//  ExportViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 17.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


final class ExportViewController: BaseViewController<ExportViewModel> {
    
    weak var rootNavController: UINavigationController?
    
    let navBar = NavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.setCloseHidden(false)
        navBar.setEditHidden(false)
        navBar.titleString = L10n.Modules.Export.title
        navBar.delegate = self
        if viewModel.parameters.comesFromCache {navBar.setEditHidden(true)}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.audioPlayerManager.isPlaying {
            viewModel.audioPlayerManager.playPause()
        }
    }
    
}

// MARK: - UILayout
extension ExportViewController {
    private func setupUI() {
        
        view.stack(
            view.stack(navBar).padLeft(30).padRight(30),
            contentContainer(),
            spacing: 32
        )
        .padTop(30)
    }
    
    
    private func contentContainer() -> UIView {
        
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
                        Text(L10n.Modules.Export.share)
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
                
        var mediaInfoContainer: some View {
            HStack {
                VStack (alignment: .leading, spacing: 8) {
                    Text(viewModel.parameters.outputParameters.name)
                        .font(.system(size: 24, weight: .bold))
                        .lineLimit(1)
                      .foregroundColor(Color(uiColor: .appClearBlack))
                    HStack {
                        Text("\(viewModel.audioPlayerManager.stringFromTimeInterval(long: true)) | .\(viewModel.parameters.outputParameters.format.rawValue) | \(viewModel.fileSize)")
                            .font(.system(size: 15))
                            .foregroundColor(Color(uiColor: .appClearBlack.withAlphaComponent(0.6)))
                        Menu {
                            Text("\(L10n.Modules.Edit.bit): \(viewModel.parameters.outputParameters.bitrate.str())")
                            Text("\(L10n.Modules.Edit.sample): \(viewModel.parameters.outputParameters.sampleRate.str())")
                            Text("\(L10n.Modules.Edit.channels): \(viewModel.parameters.outputParameters.channels)")
                            Text("\(L10n.Modules.Edit.speed): \(viewModel.parameters.outputParameters.speed)")
                            Text("\(L10n.Modules.Edit.volume): \(viewModel.parameters.outputParameters.volume)")
                            Text("\(L10n.Modules.Edit.format): \(viewModel.parameters.outputParameters.format.rawValue)")
                        } label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height:15)
                        }

                            
                    }
                }
                Spacer()
            }
        }
        
        var coverImage: some View {
            

            let  width = ScreenSize.width * 0.8
            let image = Rectangle()
                .foregroundColor(.clear)
                .frame(width: width, height: width)
                .background(
                    Image(uiImage: viewModel.parameters.outputParameters.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .clipped()
                    .cornerRadius(10)
                )
                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                .overlay(.black.opacity(0.35))
                .cornerRadius(10)
                .blurredBackgroundShadow(blurRadius: 25)
                .hoverEffect()
                .padding(.horizontal, 30)
                .overlay (alignment: .bottom) {
                    Text(".\(viewModel.parameters.outputParameters.format.rawValue)")
                        .foregroundStyle(.white)
                        .font(.system(size: 15, weight: .bold))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background (
                            .ultraThinMaterial,
                            in: Capsule()
                        )
                        .padding(.bottom,24)
                }
                .overlay {
                    SoundWaveView(pm: viewModel.audioPlayerManager )
                }
            
            return image
        }
        
        func didTapDownload() {
            viewModel.download()
        }
        
        func didTapShare() {
            viewModel.share()
        }
        
        return ScrollView {
            VStack(spacing: 24) {
                VStack (spacing: 24) {
                    coverImage
                    mediaInfoContainer
                        .padding(.horizontal, 40)
                }
                Spacer()
                VStack (spacing: 16) {
                    AudioWaveformView(pm: viewModel.audioPlayerManager)
                    AudioControlContainer(pm: viewModel.audioPlayerManager)
                }
                .padding(.horizontal, 40)
                Spacer()
            }
            .padding(.bottom, 70)
        }
        .clipped(antialiased: false)
        .overlay(alignment: .bottom, content: {
            HStack (spacing: 16) {
                shareButton
                downloadButton
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
        })
        .asUIKit()
    }
    
    struct AudioControlContainer: View {
        @ObservedObject var pm: AudioPlayerManager
        var body: some View {
            HStack (spacing: 24) {
                Spacer()
                Button {
                    pm.goBackward10()
                } label: {
                    Image(systemName: "gobackward.10")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .opacity(0.6)
                }
                Button {
                    withAnimation {
                        pm.playPause()
                    }
                } label: {
                    Image(systemName: pm.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
                Button {
                    pm.goForward10()
                } label: {
                    Image(systemName: "goforward.10")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .opacity(0.6)
                }
                

                Spacer()
            }
            .animation(.bouncy, value: pm.isPlaying)
            .foregroundStyle(Color(uiColor: .appClearBlack))
        }
    }
    
    struct AudioWaveformView: View {
    @State private var dragOffset: CGFloat = 0 // Kullanıcının kaydırma yer değiştirmesi
    @ObservedObject var pm: AudioPlayerManager

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 2) {
                    ForEach(0..<pm.audioSamples.count, id: \.self) { index in
                        Capsule()
                            .fill(index < Int(pm.playbackPosition * CGFloat(pm.audioSamples.count)) ? Color(uiColor: .appBlue) : Color(uiColor: .appHeather.withAlphaComponent(0.5)))
                            .frame(height: geometry.size.height * pm.audioSamples[index])
                    }
                }
                HStack {
                    Text(pm.currentTime)
                    Spacer()
                    Text(pm.endTime)
                }
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let totalWidth = geometry.size.width
                        dragOffset = min(max(0, gesture.location.x), totalWidth)
                        pm.playbackPosition = dragOffset / totalWidth
                        pm.updatePlaybackPosition(newPosition: dragOffset/totalWidth)
                    }
            )
        }
        .frame(height: 50)
    }
}

    struct SoundWaveView: View {
        let numberOfBars = 6
        let animationDuration = 0.25
        let minHeight: CGFloat = 20
        let maxHeight: CGFloat = 100

        @State private var barHeights: [CGFloat] = []
        @State private var timers: [AnyCancellable] = []
        @ObservedObject var pm: AudioPlayerManager
        var initValues: [CGFloat] = [30, 65, 100, 40, 70, 35]

        init(pm: AudioPlayerManager) {
            self._pm = ObservedObject(wrappedValue: pm)
            _barHeights = State(initialValue: initValues)
        }

        var body: some View {
            HStack(alignment: .center, spacing: 8) {
                ForEach(0..<numberOfBars, id: \.self) { index in
                    Capsule()
                        .foregroundStyle(.white)
                        .frame(width: 8, height: self.barHeights[index])
                        .animation(.easeInOut(duration: animationDuration), value: barHeights[index])
                        
                }
            }
            .onChange(of: pm.isPlaying) { isPlaying in
                        if isPlaying {
                            startAnimatingBars()
                        } else {
                            stopAnimatingBars()
                        }
                    }
            .onAppear {
                // İlk kez göründüğünde bar yüksekliklerini ayarla
                for i in 0..<numberOfBars {
                    barHeights[i] = CGFloat.random(in: minHeight...maxHeight)
                }
            }
        }
        
        private func startAnimatingBars() {
                timers = (0..<numberOfBars).map { index in
                    Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect().sink { _ in
                        self.barHeights[index] = CGFloat.random(in: minHeight...maxHeight)
                    }
                }
            }
            
            // Animasyonları durdur
            private func stopAnimatingBars() {
                timers.forEach { $0.cancel() }
                timers.removeAll()
                resetBarHeights()
            }
            
            // Bar yüksekliklerini başlangıç değerlerine sıfırla
            private func resetBarHeights() {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    self.barHeights = initValues
                }
            }
    }
    
}

// MARK: - NavBarDelegate
extension ExportViewController: NavBarDelegate {
    func didTapClose() {
        switch viewModel.parameters.comesFromCache {
        case true:
            viewModel.router.close()
        case false:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self else { return }
                rootNavController?.popToRootViewController(animated: true)
                viewModel.router.close()
            }
            viewModel.cache()
        }
    }
    
    func didTapEdit() {
        viewModel.router.close()
    }
}
