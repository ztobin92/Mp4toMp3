import UIKit
import SwiftUI
import PryntTrimmerView
import CoreMedia
import MobileCoreServices
import AVFoundation

final class EditViewController: BaseViewController<EditViewModel> {
    
    private let navBar = NavBar()
    private var isViewPushed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBar()
        
      
    }

    @objc func testExportButtonTapped() {
        print("Test Export Button Tapped")
        didTapExport()  // Call the same export logic
    }
    
    public func setExportHidden(_ bool: Bool) {
        if #available(iOS 16.0, *) {
            guard let exportButton = navBar.export as? UIView else {
                print("Error: navBar.export is not a UIView or UIButton")
                return
            }
            exportButton.isHidden = bool
            print("Export button hidden status: \(exportButton.isHidden)")
        } else {
            // Fallback behavior for older iOS versions
            print("Export button not available on iOS versions earlier than 16.")
        }
    }


    
    deinit {
        print("EditViewController deinitialized")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissHistoryView.send(())

        viewModel.trimManager.forEach { tm in
            if tm.isPlaying {
                tm.play()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // Avoid pushing the EditBottomSheetViewController twice
            if #available(iOS 16, *), !self.isViewPushed { // Added check to prevent double pushing
                self.viewModel.router.presentEditBottomSheet(editVM: self.viewModel)
                self.isViewPushed = true  // Track that the view has been pushed
            }
        }
    }

    private func configureNavBar() {
        navBar.delegate = self
        print("NavBar delegate assigned")
        navBar.setBackHidden(false)

        if #available(iOS 16.0, *) {
            navBar.setExportHidden(false)
            print("NavBar Export button set to visible")
        } else {
            print("Export button not available on iOS versions earlier than 16.")
        }

        navBar.titleString = viewModel.urls.count == 1 ? L10n.Modules.Edit.edit : L10n.Modules.Batch.title
    }

}

// MARK: - NavBarDelegate
extension EditViewController: NavBarDelegate {
    func didTapClose() {
        viewModel.router.close()
    }

    func didTapExport() {
        print("Tapped Export")
        navBar.setLoadingHidden(false)
        navBar.setExportHidden(true)

        viewModel.trimManager.forEach { tm in
            if tm.isPlaying {
                tm.play()
            }
        }

        viewModel.didTapExport { [weak self] urls, allParams in
            guard let self = self else { return }

            navBar.setLoadingHidden(true)
            navBar.setExportHidden(false)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            if urls.isEmpty, allParams.isEmpty { return }

            if urls.count == 1, allParams.count == 1 {
                if let vc = AppRouter.shared.topViewController() as? EditBottomSheetViewController, let nav = self.navigationController, let urlOpt = urls.first, let urlOpt {
                    vc.viewModel.router.presentExport(parameters: .init(rootNav: nav, assetURL: urlOpt, outputParameters: allParams.first!))
                }
            } else {
                if let vc = AppRouter.shared.topViewController() as? EditBottomSheetViewController, let nav = self.navigationController {
                    vc.viewModel.router.presentBatchExport(parameters: .init(urls: urls.compactMap { $0 }, allOutputParameters: allParams, rootNav: nav))
                }
            }
        }
    }
}


// MARK: - UILayout
extension EditViewController {
    private func setupUI() {
        setupSingleBlueBackground()

        view.stack(
            view.stack(navBar).padLeft(30).padRight(30),
            contentContainer()
        ).padTop(30)
    }
    
    private func contentContainer() -> UIView {
        return ScrollView {
            
            VStack (spacing: 16) {
                if viewModel.assets.count == 1 {
                    TrimContainer(vm: viewModel, trimManager: viewModel.trimManager[0], index: 0)
//                    RangeContainer(trimManager: viewModel.trimManager[0])
                    ExpandableFormatContainer(vm: viewModel)
                        .makeGradientBackground(singleColor: false)
                    NameEditContainer(vm: viewModel)
                    if #available(iOS 16, *) { } else {ShowEditButton(inSingleScreen: true, vm: viewModel)}
                } else {
                    HStack {
                        Spacer()
                        Text("\(viewModel.urls.count) \(L10n.Modules.Edit.listed)")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 9, weight: .semibold))
                    }
                    if #available(iOS 16, *) { } else {ShowEditButton(inSingleScreen: false, vm: viewModel)}
                    LazyVStack(content: {
                        VStack(spacing: 16, content: {
                            ForEach(viewModel.assets.indices, id: \.self) { i in
                                TrimContainer(vm: self.viewModel, trimManager: self.viewModel.trimManager[i], index: i)
                            }
                        })
                    })
                    Spacer()
                        .frame(height: 80)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.top, 24)
        .keyboardSpace()
        .asUIKit()
    }
}

// MARK: - Views

struct ShowEditButton: View {
    var inSingleScreen: Bool = false
    @ObservedObject var vm: EditViewModel
    var body: some View {
        HStack {
            Image(uiImage: .icEqualizer)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(inSingleScreen ? L10n.Modules.Edit.advance : L10n.Modules.Edit.edit)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(uiColor: .appBlack))
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color(uiColor: .secondaryLabel))
        }
        .padding(16)
        .makeGradientBackground(singleColor: false)
        .onTapGesture {
            vm.router.presentEditBottomSheet(editVM: vm)
        }
    }
}

struct RangeContainer: View {
    @ObservedObject var trimManager: TrimManager
    var body: some View {
        HStack {
            Image(systemName: "scissors")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(L10n.Modules.Edit.range)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(uiColor: .appBlack))
            Spacer()
            Text("*\(stringFromTimeInterval(interval:trimManager.startTime))* : *\(stringFromTimeInterval(interval:trimManager.finishTime))*")
                .font(.system(size: 15, weight: .medium, design: .monospaced))
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color(uiColor: .secondaryLabel))
        }
        .padding(16)
        .makeGradientBackground(singleColor: false)
    }
    
    
    func stringFromTimeInterval(interval: Double) -> String {
        let milliseconds = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let interval = Int(interval)
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        let seconds = (interval % 3600) % 60
        
        // Saat bileşeni 0 ise, sadece dakika ve saniyeyi göster
        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%0.2d:%0.2d.%0.2d", minutes, seconds, milliseconds)
        }
    }

}

// MARK: - NameEditContainer
struct NameEditContainer: View {
    
    @ObservedObject var vm: EditViewModel
    @State var isNameEditing: Bool = true
    
    var body: some View {
        VStack (spacing: 16) {
            HStack {
                Image(systemName: "character.textbox")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Text(L10n.Modules.Edit.filename)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color(uiColor: .appBlack))
                Spacer()
                HStack {
                    Text(!isNameEditing ? vm.outputName : "      ")
                        .font(.system(size: 15, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Image(systemName: isNameEditing ? "chevron.up" : "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.secondary)
                        .tint(.secondary)
                }
                .onTapGesture {
                    withAnimation {
                        isNameEditing.toggle()
                    }
                }
            }
            
            if isNameEditing {
                TextField(L10n.Modules.Edit.filename, text: $vm.outputName)
                    .onSubmit(of: .text) {
                        isNameEditing.toggle()
                    }
                    .submitLabel(.done)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .foregroundStyle(Color(uiColor: .appHeather.withAlphaComponent(0.5)))
                            .frame(height: 1)
                    }
            }
            
        }
        .animation(.bouncy, value: isNameEditing)
        .padding(16)
        .makeGradientBackground(singleColor: false)
        
    }
}

// MARK: - ExpandableContainer
struct ExpandableFormatContainer: View {
    
    @ObservedObject var vm: EditViewModel
    @State var isExpanded: Bool = false
    
    private let expandedExtensions = ConvertHelper.OutputFormat.allCases
    
    private var gridItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    }
    
    var body: some View {
        VStack {
            // Extensions grid
            let extensionsToShow: [ConvertHelper.OutputFormat] = isExpanded ? expandedExtensions : Array(ConvertHelper.OutputFormat.allCases[0...3])
            VStack (spacing: 16) {
                HStack {
                    Image(systemName: "waveform")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text(L10n.Modules.Edit.format)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color(uiColor: .appBlack))
                    Spacer()
                    HStack {
                        Text(isExpanded ? L10n.General.less : L10n.General.more )
                            .font(.system(size: 15, weight: .medium))
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.secondary)
                            .tint(.secondary)
                    }
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }

                }
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(extensionsToShow, id: \.self) { ext in
                        Text(ext.rawValue)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(uiColor: vm.outputFormat == ext ? .appBlue: .appBlack))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: .appClearWhite))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(vm.outputFormat == ext ? Color(uiColor: .appBlue) : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                vm.outputFormat = ext
                            }
                    }
                }
            }
            .animation(.bouncy, value: isExpanded)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// MARK: -  TrimContainer
//struct TrimContainer: View {
//
//    var vm: EditViewModel
//    @State var thm: UIImage = UIImage()
//    @State var isNameEditing = false
//    @State var name: String = ""
//    @ObservedObject var trimManager: TrimManager
//    var index: Int
//
//    let trimmer = TrimmerView()
//
//    var body: some View {
//        HStack (alignment: .center) {
//            VStack(alignment: .leading) {
//                if vm.urls.count > 1 {
//                    HStack {
//                        Group {
//                            Image(systemName: "pencil")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 8, height: 8)
//                            TextField(name, text: $name)
//                                .font(.system(size: 9))
//                        }
//                        .foregroundStyle(Color(uiColor: .appBlue))
//                        Spacer()
//                        Text("\(stringFromTimeInterval(interval: trimManager.startTime))-\(stringFromTimeInterval(interval: trimManager.finishTime))")
//                            .font(.system(size: 9))
//                            .foregroundStyle(.secondary)
//                            .padding(.trailing, 10)
//                    }
//                }
//                GeometryReader(content: { geometry in
//                    let size = geometry.size
//                    trimmer
//                        .withSize(.init(width: size.width * 0.95, height: 40))
//                        .asSwiftUI()
//                })
//                .frame(height: 40)
//            }
//            .padding(.leading, 40)
//        }
//        .frame(height: 75)
//        .makeGradientBackground(singleColor: false, cornerRadius: 10)
//        .padding(.leading, 30)
//        .overlay(alignment: .leading, content: {
//            Image(uiImage: thm)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 60, height: 60)
//                .overlay(.black.opacity(0.4))
//                .overlay(content: {
//                    Image(systemName: trimManager.isPlaying ? "pause.fill" : "play.fill")
//                        .foregroundStyle(.white)
//                })
//                .cornerRadius(10)
//                .onTapGesture {
//                    vm.trimManager.filter({$0.trimmerView != trimmer}).forEach({ tm in
//                        if tm.isPlaying {tm.play()}
//                    })
//                    trimManager.play()
//                }
//                .blurredBackgroundShadow(blurRadius: 10)
//        })
//        .frame(height: 75)
//        .onAppear(perform: configureTrimmer)
//        .onAppear(perform: setPlayer)
//        .onAppear(perform: loadThumbnail)
//        .onChange(of: name, perform: { value in
//            vm.fileNames[index] = value
//        })
//        .onAppear(perform: {
//            name = vm.fileNames[index]
//        })
//    }
//
//    func stringFromTimeInterval(interval: Double) -> String {
//        let interval = Int(interval)
//        let hours = interval / 3600
//        let minutes = (interval % 3600) / 60
//        let seconds = (interval % 3600) % 60
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//
//    private func loadThumbnail() {
//        // Arka planda thumbnail yükleme işlemi
//        DispatchQueue.global(qos: .userInitiated).async {
//            let imageGenerator = AVAssetImageGenerator(asset: vm.assets[index])
//            imageGenerator.appliesPreferredTrackTransform = true // Doğru oryantasyon
//
//            let time = CMTime(seconds: 1, preferredTimescale: 60) // Thumbnail alınacak zaman noktası
//            let times = [NSValue(time: time)]
//
//            imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, cgImage, _, _, _ in
//                if let cgImage = cgImage {
//                    // UI güncellemesi için ana kuyruğa dön
//                    DispatchQueue.main.async {
//                        self.thm = UIImage(cgImage: cgImage)
//                        vm.trimManager[index].coverImage = UIImage(cgImage: cgImage)
//                    }
//                }
//            }
//        }
//    }
//
//    private func setPlayer() {
//        trimManager.trimmerView = trimmer
//        DispatchQueue.main.async {
//            trimManager.addVideoPlayer(with: vm.assets[index], playerView: UIView())
//        }
//    }
//
//    private func configureTrimmer() {
//        trimmer.accessibilityIdentifier = vm.fileNames[index]
//        trimmer.maxDuration = .infinity
//        trimmer.delegate = trimManager
//        trimmer.mainColor = .appBlue
//        trimmer.handleColor = .white
//        DispatchQueue.main.async {
//            trimmer.asset = vm.assets[index]
//            guard trimManager.trimmerView != nil else {return}
//            trimManager.startTime = trimmer.startTime?.seconds ?? 0
//            trimManager.finishTime = trimmer.endTime?.seconds ?? 0
//        }
//    }
//}

struct TrimContainer: View {
    
    var vm: EditViewModel
    @State var thm: UIImage = UIImage()
    @State var isNameEditing = false
    @State var name: String = ""
    @ObservedObject var trimManager: TrimManager
    var index: Int
    
    let trimmer = TrimmerView()

    var body: some View {
        VStack {
            
            VStack (alignment: .center, spacing: 8) {
                
                VStack (spacing: 8) {
                    HStack (alignment: .center) {
                        Image(uiImage: thm)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(.black.opacity(0.4))
                            .overlay(content: {
                                Image(systemName: trimManager.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white)
                            })
                            .cornerRadius(4)
                            .onTapGesture {
                                vm.trimManager.filter({$0.trimmerView != trimmer}).forEach({ tm in
                                    if tm.isPlaying {tm.play()}
                                })
                                trimManager.play()
                            }
                            .frame(width: 25, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .blurredBackgroundShadow(blurRadius: 5)
                        Text(L10n.Modules.Edit.range)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color(uiColor: .appBlack))
                        Spacer()
                        HStack {
                            Text("\(stringFromTimeInterval(interval:trimManager.startTime)) - \(stringFromTimeInterval(interval:trimManager.finishTime))")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color(uiColor: .secondaryLabel))
                        }
                    }
                    
                    VStack(alignment: .center) {
                        Spacer()
                        if vm.urls.count > 1 {
                            HStack {
                                Group {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 8, height: 8)
                                    TextField(name, text: $name)
                                        .font(.system(size: 9))
                                }
                                .foregroundStyle(Color(uiColor: .appBlue))
                                Spacer()
//                                Text("\(stringFromTimeInterval(interval: trimManager.startTime))-\(stringFromTimeInterval(interval: trimManager.finishTime))")
//                                    .font(.system(size: 9))
//                                    .foregroundStyle(.secondary)
//                                    .padding(.trailing, 10)
                            }
                        }
                        
                        GeometryReader(content: { geometry in
                            let size = geometry.size
                            trimmer
                                .withSize(.init(width: size.width * 1, height: 25))
                                .asSwiftUI()
                                .cornerRadius(3)
                        })
                        .frame(height: 25)
                    }


                }
                .padding()
                .makeGradientBackground(singleColor: false, cornerRadius: 10)

            }

        }
        .onAppear(perform: configureTrimmer)
        .onAppear(perform: setPlayer)
        .onAppear(perform: loadThumbnail)
        .onChange(of: name, perform: { value in
            vm.fileNames[index] = value
        })
        .onAppear(perform: {
            name = vm.fileNames[index]
        })
    }
    
    func stringFromTimeInterval(interval: Double) -> String {
        let milliseconds = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let interval = Int(interval)
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        let seconds = (interval % 3600) % 60
        
        // Saat bileşeni 0 ise, sadece dakika ve saniyeyi göster
        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%0.2d:%0.2d.%0.2d", minutes, seconds, milliseconds)
        }
    }

    private func loadThumbnail() {
        // Arka planda thumbnail yükleme işlemi
        DispatchQueue.global(qos: .userInitiated).async {
            let imageGenerator = AVAssetImageGenerator(asset: vm.assets[index])
            imageGenerator.appliesPreferredTrackTransform = true // Doğru oryantasyon
            
            let time = CMTime(seconds: 1, preferredTimescale: 60) // Thumbnail alınacak zaman noktası
            let times = [NSValue(time: time)]
            
            imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, cgImage, _, _, _ in
                if let cgImage = cgImage {
                    // UI güncellemesi için ana kuyruğa dön
                    DispatchQueue.main.async {
                        self.thm = UIImage(cgImage: cgImage)
                        vm.trimManager[index].coverImage = UIImage(cgImage: cgImage)
                    }
                }
            }
        }
    }
    
    private func setPlayer() {
        trimManager.trimmerView = trimmer
        DispatchQueue.main.async {
            trimManager.addVideoPlayer(with: vm.assets[index], playerView: UIView())
        }
    }
    
    private func configureTrimmer() {
        trimmer.accessibilityIdentifier = vm.fileNames[index]
        trimmer.maxDuration = .infinity
        trimmer.delegate = trimManager
        trimmer.mainColor = .appBlue
        trimmer.handleColor = .white
        DispatchQueue.main.async {
            trimmer.asset = vm.assets[index]
            guard trimManager.trimmerView != nil else {return}
            trimManager.startTime = trimmer.startTime?.seconds ?? 0
            trimManager.finishTime = trimmer.endTime?.seconds ?? 0
        }
    }
}

#Preview {
    let router = EditRouter()
    let viewModel = EditViewModel(urls: [.init(string: "google.com")!], router: router)
    let viewController = EditViewController(viewModel: viewModel)
    
    let transition = PushTransition()
    router.viewController = viewController
    router.openTransition = transition
    
    return viewController.view.asSwiftUI()
}
