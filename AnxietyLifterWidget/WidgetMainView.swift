//
//  WidgetMainView.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import SwiftUI
import UIKit
import WidgetKit
import AnxietyLifterCore

struct WidgetMainView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black.opacity(0.90)
            HStack(spacing: 8) {
                StopLightView(.go)
                    .frame(width: 60, height: 140)
                    .padding([.top, .bottom], 6)
                
                VStack(spacing: 0) {
                    DataPointPreviewView(text: "100%", image: #imageLiteral(resourceName: "AdmissionIcon"))
                    DataPointPreviewView(text: "8", image: #imageLiteral(resourceName: "DeathIcon"))
                    DataPointPreviewView(text: "80%", image: #imageLiteral(resourceName: "HospitalIcon"))
                }
                .padding([.top, .bottom], 10)
                .frame(width: 60)
            }
        }
    }
}

private struct DataPointPreviewView: View {
    let text: String
    let image: UIImage
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 18)
            
            Text(text)
                .font(.footnote)
                .bold()
                .foregroundColor(.white)                
            Spacer()
        }
    }
}

struct WidgetMainView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMainView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
