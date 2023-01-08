//
//  DownloadArtContentMediaViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 10/03/2022.
//

import SwiftUI
import AVKit
import PhotosUI

// Refactoring structures using in download art content media views.
struct CustomArtContentProgressView: View {
    
    @Binding var downloadedPercentage: Double
    @Binding var percentageToAdd: Double
    @Binding var downloadIsOver: Bool
    @Binding var isLoading: Bool
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ProgressView("Downloading…", value: downloadedPercentage)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .onReceive(timer) { _ in
                    if isLoading {
                        if percentageToAdd < 1 {
                            downloadedPercentage = percentageToAdd
                        } else if downloadIsOver {
                            downloadedPercentage = 1
                        }
                    }
                }
        }.isHidden(isLoading ? false : true)
        .progressViewStyle(CustomCircularProgressViewStyle())
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
                .rotationEffect(.degrees(-90))
                .frame(width: 200)
            
            if let fractionCompleted = configuration.fractionCompleted {
                Text(fractionCompleted < 1 ?
                        "Completed \(Int((configuration.fractionCompleted ?? 0) * 100))%"
                        : "Done!"
                )
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(width: 180)
            }
        }
    }
}

struct DetermineMediaItem: View {
    
    var item: Media
    
    var body: some View {

        if item.mediaType == .photo {
            Image(uiImage: item.photo ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .scaleEffect(anchor: .center)
        } else if item.mediaType == .video {
            if let url = item.url {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 200)
            } else { EmptyView() }
        } else {
            if let livePhoto = item.livePhoto {
                LivePhotoView(livePhoto: livePhoto)
                    .frame(height: 200)
            } else { EmptyView() }
        }
    }
}
