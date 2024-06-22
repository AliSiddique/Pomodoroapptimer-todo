//
//  Graph.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 22/06/2024.
//

import SwiftUI

// Sample Graph Model and Data....
struct Download: Identifiable{
    var id = UUID().uuidString
    var downloads: CGFloat
    var day: String
    var color: Color
}

var weekDownloads: [Download] = [

    Download(downloads: 30, day: "S", color: Color("Purple")),
    Download(downloads: 45, day: "M", color: Color("Purple")),
    Download(downloads: 60, day: "T", color: Color("Green")),
    Download(downloads: 90, day: "W", color: Color("Green")),
    Download(downloads: 40, day: "T", color: Color("Purple")),
    Download(downloads: 50, day: "F", color: Color("Green")),
    Download(downloads: 20, day: "S", color: Color("Purple")),
]


struct BarGraph: View {
    var downloads: [Download]
    
    // Gesture Properties...
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = 0
    
    // Current download to highlight while dragging...
    @State var currentDownloadID: String = ""
    
    var body: some View {
        
        HStack(spacing: 10){
            
            ForEach(downloads){download in
                CardView(download: download)
            }
        }
        .frame(height: 150)
        .animation(.easeOut, value: isDragging)
        // Gesutre...
        .gesture(
        
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    // Only updating if dragging...
                    offset = isDragging ? value.location.x : 0
                    
                    // dragging space removing the padding added to the view...
                    // total padding = 60
                    // 2 * 15 Horizontal
                    let draggingSpace = UIScreen.main.bounds.width - 60
                    
                    // Each block...
                    let eachBlock = draggingSpace / CGFloat(downloads.count)
                    
                    // getting index...
                    let temp = Int(offset / eachBlock)
                    
                    // safe Wrapping index...
                    let index = max(min(temp, downloads.count - 1), 0)
                    
                    // updating ID
                    self.currentDownloadID = downloads[index].id
                })
                .onEnded({ value in
                    
                    withAnimation{
                        offset = .zero
                        currentDownloadID = ""
                    }
                })
        )
    }
    
    @ViewBuilder
    func CardView(download: Download)->some View{
        
        VStack(spacing: 20){
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(download.color)
                    .opacity(isDragging ? (currentDownloadID == download.id ? 1 : 0.35) : 1)
                    .frame(height: (download.downloads / getMax()) * (size.height))
                    .overlay(
                    
                        Text("\(Int(download.downloads))")
                            .font(.callout)
                            .foregroundColor(download.color)
                            .opacity(isDragging && currentDownloadID == download.id ? 1 : 0)
                            .offset(y: -30)
                        
                        ,alignment: .top
                    )
                    .frame(maxHeight: .infinity,alignment: .bottom)
            }
            
            Text(download.day)
                .font(.callout)
                .foregroundColor(isDragging && currentDownloadID == download.id ? download.color : .gray)
        }
    }
    
    // to get Graph height...
    // getting max in the downloads...
    
    func getMax()->CGFloat{
        let max = downloads.max { first, second in
            return second.downloads > first.downloads
        }
        
        return max?.downloads ?? 0
    }
}

struct Home: View {
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 15){
                
                // Header..
                HStack(spacing: 15){
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }

                    Text("My Stats")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                    }

                }
                .foregroundColor(.white)
                
                // Download Stats....
                DownloadStats()
                
                // Followers Stats...
                FollowersStats()
                
                // Payment View..
                HStack{
                    
                    Text("$95.00")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("/collab")
                        .font(.callout)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Accept")
                            .font(.callout)
                            .foregroundColor(Color("BG"))
                            .padding(.vertical,10)
                            .padding(.horizontal)
                            .background(
                            
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Purple"))
                            )
                    }
                }
                .padding()
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BG").ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func FollowersStats()->some View{
        
        VStack{
            
            HStack{
                
                Button {
                    
                } label: {
                    Text("Show All")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(
                        
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("BG"))
                        )
                }
                .padding(.trailing,10)
                
                Image(systemName: "checkmark")
                    .font(.caption.bold())
                    .foregroundColor(Color("BG"))
                    .padding(6)
                    .background(Color("Green"))
                    .cornerRadius(8)
                
                Text("Followers")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.trailing,10)
                
                Image(systemName: "play.fill")
                    .font(.caption.bold())
                    .foregroundColor(Color("BG"))
                    .padding(6)
                    .background(Color("Purple"))
                    .cornerRadius(8)
                
                Text("Following")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.trailing,10)
            }
            
            VStack(spacing: 15){
                
                Text("$93.5K")
                    .font(.largeTitle.bold())
                    .scaleEffect(1.3)
                
                Text("Earning This Month")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding(.top,25)
            
            // Following Followers Stats...
            
            HStack(spacing: 10){
                
                StatView(title: "Followers", count: "87.57K", image: "checkmark", color: "Green")
                
                StatView(title: "Following", count: "27.57K", image: "play.fill", color: "Purple")
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(
        
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
        )
    }
    
    @ViewBuilder
    func StatView(title: String,count: String,image: String,color: String)->some View{
        
        VStack(alignment: .leading, spacing: 25) {
            
            HStack{
                Image(systemName: image)
                    .font(.caption.bold())
                    .foregroundColor(Color(color))
                    .padding(6)
                    .background(Color("BG"))
                    .cornerRadius(8)
                
                Text("Followers")
            }
            
            Text(count)
                .font(.title.bold())
        }
        .foregroundColor(Color("BG"))
        .padding(.vertical,22)
        .padding(.horizontal,18)
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color(color))
        .cornerRadius(15)
    }
    
    @ViewBuilder
    func DownloadStats()->some View{
        
        VStack(spacing: 15){
            
            HStack{
                
                VStack(alignment: .leading, spacing: 13) {
                    
                    Text("Ads Expense")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Menu {
                        
                    } label: {
                        
                        Label {
                            Image(systemName: "chevron.down")
                        } icon: {
                            Text("Last 7 Days")
                        }
                        .font(.callout)
                        .foregroundColor(.gray)

                    }

                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up.forward")
                        .font(.title2.bold())
                }
                .foregroundColor(.white)
                .offset(y: -10)

            }
            
            HStack{
                
                Text("$12.85")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Download")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(
                        
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("BG"))
                        )
                }

            }
            .padding(.vertical,20)
            
            // Bar Graph With Gestures...
            BarGraph(downloads: weekDownloads)
                .padding(.top,25)
        }
        .padding(15)
        .background(
        
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
        )
        .padding(.vertical,20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
