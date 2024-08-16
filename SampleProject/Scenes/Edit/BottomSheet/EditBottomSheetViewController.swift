//
//  EditBottomSheetViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

final class EditBottomSheetViewController: BaseViewController<EditBottomSheetViewModel> {
    
    private let navBar = NavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.delegate = self
        navBar.titleString = viewModel.editVM.urls.count == 1 ? L10n.Modules.Edit.advance : L10n.Modules.Edit.edit
        
        if #available(iOS 16, *) {
            navBar.setExpandHidden(false)
        } else {
            navBar.setCloseHidden(false)
        }
    }
    
}

extension EditBottomSheetViewController: NavBarDelegate {
    func didTapClose() {
        viewModel.router.close()
    }
}


// MARK: - UILayout
extension EditBottomSheetViewController {
    private func setupUI() {
        view.backgroundColor = .appClearWhite

        view.stack(
            navBar,
            editOptions()
        ).withMargins(.init(top: 30, left: 30, bottom: 0, right: 30))
    }
    
    private func editOptions() -> UIView {
        
        let volume = HStack {
            Image(systemName: "speaker.wave.2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(L10n.Modules.Edit.volume)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(uiColor: .appBlack))
            Spacer()
                .frame(width: 32)
            VolumeSlider(editVM: viewModel.editVM)
        }
            .padding(16)
            .makeGradientBackground()
        
        return ScrollView(showsIndicators: false, content: {
            LazyVStack(spacing:16) {
                if viewModel.editVM.urls.count > 1 {
                    ExpandableFormatContainer(vm: viewModel.editVM)
                        .makeGradientBackground()
                }
//                SpeedCell(editVM: viewModel.editVM)
                BitRateCell(editVM: viewModel.editVM)
                SampleRateCell(editVM: viewModel.editVM)
                volume
                ChannelCell(editVM: viewModel.editVM)
                Spacer()
            }
        })
        .padding(.top, 16)
        .asUIKit()
    }
    
}

// MARK: - Views

struct ChannelCell: View {
    @ObservedObject var editVM: EditViewModel
    var body: some View {
        HStack {
            Image(systemName: "arrow.triangle.branch")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(L10n.Modules.Edit.channels)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(uiColor: .appBlack))
            Spacer()
                .frame(width: 32)
            Picker("Channel", selection: $editVM.outputChannel) {
                ForEach(EditBottomSheetViewModel.Channel.allCases) { gender in
                    Text(gender.rawValue).tag(gender.value)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

        }
            .padding(16)
            .makeGradientBackground()
    }
}

struct SpeedCell: View {
    // Slider değerleri
    private let values: [Double] = [0.5, 1.0, 1.5, 2.0]
    // Slider çubuğunun boyutları
    private let trackHeight: CGFloat = 1
    private let thumbSize: CGFloat = 20

    @ObservedObject var editVM: EditViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "hare")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Text(L10n.Modules.Edit.speed)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color(uiColor: .appBlack))
            }
            GeometryReader { geometry in
                VStack {
                    
                    HStack {
                        ForEach(values, id: \.self) { value in
                            Text("\(value, specifier: "%.1f")x")
                                .font(.caption)
                                .fontWeight(editVM.outputSpeed == value ? .bold : .regular)
                            if value != values.last {
                                Spacer()
                            }
                        }
                    }
                    
                    ZStack(alignment: .leading) {
                        // Slider çubuğu
                        Rectangle()
                            .fill(Color(uiColor: .appClearBlack))
                            .frame(height: trackHeight)
                        
                        // Seçici (thumb)
                        Circle()
                            .fill(Color(uiColor: .appClearBlack))
                            .frame(width: thumbSize, height: thumbSize)
                            .offset(x: self.computeOffset(geometry: geometry), y: 0)
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        self.editVM.outputSpeed = self.valueFromGesture(value: value, geometry: geometry)
                                    })
                            )
                    }
                    // Slider'ın altındaki değerler
                }
            }
            .padding(.horizontal,20)
            .frame(height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .padding(.bottom, 8)
        .makeGradientBackground()
    }
    
    // DragGesture'den gelen değeri kullanarak sliderValue'yi güncelle
    private func valueFromGesture(value: DragGesture.Value, geometry: GeometryProxy) -> Double {
        let sliderWidth = geometry.size.width
        let newValue = Double(value.location.x / sliderWidth) * (values.last! - values.first!) + values.first!
        let closest = values.min(by: { abs($0 - newValue) < abs($1 - newValue) }) ?? newValue
        return closest
    }
    
    // Seçili değere göre thumb'un X offset'ini hesapla
    private func computeOffset(geometry: GeometryProxy) -> CGFloat {
        let sliderWidth = geometry.size.width - thumbSize
        let normalizedValue = CGFloat((editVM.outputSpeed - values.first!) / (values.last! - values.first!))
        let offset = normalizedValue * sliderWidth
        return offset
    }
}

struct BitRateCell: View {
    @ObservedObject var editVM: EditViewModel
    @State var bitRates: [ConvertHelper.BitRate] = ConvertHelper.BitRate.allCases
    var body: some View {
        HStack {
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(L10n.Modules.Edit.bit)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(uiColor: .appBlack))
            Spacer()
            Menu {
                ForEach(ConvertHelper.BitRate.allCases, id: \.rawValue) { bitRate in
                    Button(bitRate == .v144 ? "\(bitRate.str()) (\(L10n.General.default))" : bitRate.str()) {
                        self.editVM.outputBitRate = bitRate
                    }
                }
            } label: {
                HStack {
                    Text(editVM.outputBitRate.str())
                        .font(.system(size: 15, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .tint(.secondary)
                }
            }

        }
        .padding(16)
        .makeGradientBackground()
    }
    
}

struct SampleRateCell: View {
    @ObservedObject var editVM: EditViewModel

    var body: some View {
        HStack {
            Image(systemName: "circle.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(L10n.Modules.Edit.sample)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(uiColor: .appBlack))
            Spacer()
            Menu {
                ForEach(editVM.availableSampleRates, id: \.self) { sampleRate in
                    Button(sampleRate == .v44100 ? "\(sampleRate.str()) (\(L10n.General.default))" : sampleRate.str()) {
                        self.editVM.outputSampleRate = sampleRate
                    }
                }

            } label: {
                HStack {
                    Text(editVM.outputSampleRate.str())
                        .font(.system(size: 15, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .tint(.secondary)
                }
            }

        }
        .padding(16)
        .makeGradientBackground()
    }
}

struct VolumeSlider: View {
    @ObservedObject var editVM: EditViewModel
    
//    @State private var volume: Double = 1.0
    private let trackHeight: CGFloat = 1
    private let thumbSize: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Slider çubuğu
                RoundedRectangle(cornerRadius: trackHeight / 2.0)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: trackHeight)
                
                // Dolu alan
                RoundedRectangle(cornerRadius: trackHeight / 2.0)
                    .fill(Color(uiColor: .appClearBlack))
                    .frame(width: self.computeFilledTrackWidth(geometry: geometry), height: trackHeight)
                
                // Seçici (thumb)
                Circle()
                    .fill(Color(uiColor: .appClearBlack))
                    .frame(width: thumbSize, height: thumbSize)
                    .overlay(
                        Text(String(format: "%.1f", editVM.outputVolume))
                            .foregroundColor(Color(uiColor: .appClearWhite))
                            .font(.system(size: thumbSize / 3))
                    )
                    .offset(x: self.computeThumbOffset(geometry: geometry), y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                self.editVM.outputVolume = self.valueFromGesture(value: value, geometry: geometry)
                            })
                    )
            }
        }
        .frame(height: thumbSize)
    }

    // DragGesture'den gelen değeri kullanarak volume'yi güncelle
    private func valueFromGesture(value: DragGesture.Value, geometry: GeometryProxy) -> Double {
        let sliderWidth = geometry.size.width - thumbSize
        let newValue = Double(value.location.x / sliderWidth) * 2.0
        return min(max(newValue, 0.0), 2.0)  // Değeri 0.0 ile 2.0 arasında sınırla
    }

    // Seçiciyi yatay eksende doğru konuma yerleştirmek için thumb offset'ini hesapla
    private func computeThumbOffset(geometry: GeometryProxy) -> CGFloat {
        let sliderWidth = geometry.size.width - thumbSize
        let normalizedValue = CGFloat(editVM.outputVolume / 2.0)
        let offset = normalizedValue * sliderWidth
        return offset
    }

    // Dolu alanın genişliğini hesapla
    private func computeFilledTrackWidth(geometry: GeometryProxy) -> CGFloat {
        let sliderWidth = geometry.size.width - thumbSize
        let normalizedValue = CGFloat(editVM.outputVolume / 2.0)
        let filledWidth = normalizedValue * sliderWidth
        return filledWidth
    }
}
