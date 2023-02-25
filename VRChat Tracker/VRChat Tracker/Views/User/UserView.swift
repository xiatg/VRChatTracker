//
//  UserView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/24/23.
//

import SwiftUI
import SwiftVRChatAPI
import CachedAsyncImage

struct UserView: View {
    let user: User
    let world: World?
    let instance: Instance?
    
    @State var averageColor: Color?
    @State var isAverageColorLight: Bool = false
    
    init(user: User, world: World? = nil, instance: Instance? = nil) {
        self.user = user
        self.world = world
        self.instance = instance
    }
    
    var body: some View {
        VStack {
            
            HStack {
                AsyncImage(url: URL(string: user.currentAvatarThumbnailImageUrl!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .onAppear {
                                let averageUIColor = image.asUIImage().averageColor!
                                averageColor = Color(uiColor: averageUIColor)
                                isAverageColorLight = averageUIColor.isLight
                            }
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(10)
                .padding([.horizontal, .top], 10)
                
                VStack(alignment: .leading, spacing: ((user.userIcon ?? "") == "") ? 0 : -20) {

                    HStack {
                        if (user.userIcon ?? "" != "") {
                            AsyncImage(url: URL(string: user.userIcon!)) { image in
                                    image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle().stroke(.white, lineWidth: 4)
                                    }
                                    .shadow(radius: 7)
                            } placeholder: {
                                ProgressView()
                            }
                        }

                        HStack(spacing: -10) {
                            Text("\(user.displayName!)")
                                .ignoresSafeArea()
                                .font(.title)
                                .bold()
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                                .padding(.trailing, ((user.userIcon ?? "") == "") ? 0 : -40)

                            Spacer()
                        }
                    }
                    .offset(x: ((user.userIcon ?? "") == "") ? 0 : -50)

                    VStack {
                        HStack {
                            Spacer()
                            Text("\(user.state!)")
                            Text("\(user.status!)")
                        }
                        .padding(.trailing, 10)
                    }
                }
                .foregroundColor(isAverageColorLight ? .black : .white)
                .padding(.top, 10)
                
                Spacer()
            }
            
            HStack {
                Text("\(user.statusDescription!)")
                    .foregroundColor(isAverageColorLight ? .black : .white)
                    .minimumScaleFactor(0.01)
                    .lineLimit(3)
                
                Spacer()
            }
            .padding(.leading, 10)
            
            if let world = world {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: world.thumbnailImageUrl!)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                    } placeholder: {
                        ProgressView()
                    }

                    VStack(alignment: .leading) {
                        Text("\(world.name!)")
                            .lineLimit(1)
                            .bold()

                        Text("\(world.description!)")
                            .lineLimit(1)
                            .foregroundColor(.secondary)

                        HStack {
                            if let instance = instance {
                                Text("\(instance.type!)")

                                switch instance.region {
                                case "jp":
                                    Text("🇯🇵")
                                case "us":
                                    Text("🇺🇸")
                                case "eu":
                                    Text("🇪🇺")
                                default:
                                    Text("🌍")
                                }

                                Text("\(instance.n_users!)/\(instance.capacity!)")
                            }
                        }
                    }
                    .foregroundColor(isAverageColorLight ? .black : .white)

                    Spacer()
                }
                .frame(height: 40)
//                .background(Color.red)
                .padding(10)
            }
            
            Spacer()
        }
        .background(averageColor ?? Color.gray)
        .cornerRadius(10)
        .frame(width: 300, height: 200)
    }
}

// https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
        
// https://stackoverflow.com/questions/57028484/how-to-convert-a-image-to-uiimage
extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

// https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: PreviewData.load(name: "UserPreview")!,
                 world: PreviewData.load(name: "WorldPreview")!,
                 instance: PreviewData.load(name: "InstancePreview")!)
    }
}
