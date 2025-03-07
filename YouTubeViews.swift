
import SwiftUI

struct YouTubeSearchView: View {
    @StateObject private var videoStore = VideoProcessingStore()
    @State private var searchQuery = ""
    @State private var showingClipCreator = false
    @State private var selectedVideo: YouTubeVideo?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    TextField("Search YouTube videos", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        videoStore.searchYouTube(query: searchQuery)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.primary)
                            .padding(.trailing)
                    }
                }
                .padding(.top)
                
                if videoStore.isSearching {
                    ProgressView("Searching...")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Results list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(videoStore.searchResults) { video in
                                VideoCard(video: video)
                                    .onTapGesture {
                                        selectedVideo = video
                                        showingClipCreator = true
                                    }
                            }
                        }
                        .padding()
                    }
                }
                
                // Saved clips section
                VStack(alignment: .leading) {
                    Text("My Clips")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(videoStore.savedClips) { clip in
                                ClipThumbnail(clip: clip)
                                    .frame(width: 150, height: 100)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                
                // Processing status
                if let currentClip = videoStore.currentProcessingClip {
                    ProcessingStatusView(clip: currentClip)
                        .padding()
                }
            }
            .navigationTitle("Video Creator")
            .sheet(isPresented: $showingClipCreator) {
                if let video = selectedVideo {
                    ClipCreatorView(video: video, videoStore: videoStore)
                }
            }
        }
    }
}

struct VideoCard: View {
    let video: YouTubeVideo
    
    var body: some View {
        AppStyles.cardStyle(
            VStack(alignment: .leading) {
                // This would load the actual thumbnail from URL
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(
                        Text("Thumbnail")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(video.channelTitle)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack {
                        Text(video.duration)
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        Text(formatDate(video.publishedAt))
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ClipCreatorView: View {
    let video: YouTubeVideo
    let videoStore: VideoProcessingStore
    
    @State private var startTime: Double = 0
    @State private var endTime: Double = 30
    @State private var clipTitle: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Video Details")) {
                    Text(video.title)
                        .font(.headline)
                    
                    Text("Duration: \(video.duration)")
                        .font(.subheadline)
                }
                
                Section(header: Text("Clip Settings")) {
                    TextField("Clip Title", text: $clipTitle)
                    
                    VStack {
                        Text("Start Time: \(formatTime(startTime))")
                        Slider(value: $startTime, in: 0...getMaxDuration())
                    }
                    
                    VStack {
                        Text("End Time: \(formatTime(endTime))")
                        Slider(value: $endTime, in: startTime...getMaxDuration())
                    }
                }
                
                Section {
                    Button(action: createClip) {
                        Text("Create Clip")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(clipTitle.isEmpty ? Color.gray : AppColors.primary)
                            .cornerRadius(10)
                    }
                    .disabled(clipTitle.isEmpty)
                }
            }
            .navigationTitle("Create Clip")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func getMaxDuration() -> Double {
        // In a real app, this would parse the actual duration
        return 300 // 5 minutes as example
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    private func createClip() {
        videoStore.createClip(from: video, startTime: startTime, endTime: endTime, title: clipTitle)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ClipThumbnail: View {
    let clip: VideoClip
    
    var body: some View {
        VStack(alignment: .leading) {
            // This would be the actual thumbnail
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    Text(formatTime(clip.startTime) + " - " + formatTime(clip.endTime))
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.6))
                )
            
            Text(clip.title)
                .font(.caption)
                .lineLimit(1)
            
            HStack {
                Circle()
                    .fill(statusColor(clip.status))
                    .frame(width: 8, height: 8)
                
                Text(clip.status.description)
                    .font(.caption2)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .background(AppColors.cardBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    private func statusColor(_ status: VideoProcessingStatus) -> Color {
        switch status {
        case .notStarted: return Color.gray
        case .downloading, .clipping, .generatingResponse, .addingSubtitles, .uploading: 
            return AppColors.primary
        case .complete: return Color.green
        case .failed: return Color.red
        }
    }
}

struct ProcessingStatusView: View {
    let clip: VideoClip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Processing: \(clip.title)")
                .font(.headline)
            
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                
                Text(clip.status.description)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            if case .failed(let error) = clip.status {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if let responseText = clip.responseText, !responseText.isEmpty {
                Text("AI Response: \(responseText)")
                    .font(.caption)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}
