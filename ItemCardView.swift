//
//  ItemCardView.swift
//  cobacloudkit
//
//  Created by Nicholas  on 07/04/25.
//

import SwiftUI

struct ItemCardView: View {

    
    var item : Item
    
    var body: some View {
        HStack{
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading){
                HStack {
                    Text(item.itemName)
                        .font(.system(size: 13))
                    
                    if(item.itemStatus == "Unclaimed"){
                        Image(systemName: "clock")
                            .foregroundColor(Color.orange)
                            .frame(width: 16, height: 16)
                    }
                    else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.green)
                            .frame(width: 16, height: 16)
                    }
                    
                }
                .padding(.bottom, 10)
                
                if(item.itemStatus == "Unclaimed"){
                    Text("Found at \(formattedDate(item.dateFound))")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                }
                else{
                    Text("Claimed at \(formattedDate(item.dateFound))")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                }
                            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment : .trailing){
                Text(item.itemCategory)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#F7C154"))
                    .frame(width: 13, height: 13)
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        
    }
    
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
}



#Preview {
        ItemCardView(item: Item.dummy)
}
