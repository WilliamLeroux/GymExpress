//
//  DashboardClientView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//


//
//  DashboardClientView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct DashboardTrainerView: View {
    var body: some View {
        Grid {
            GridRow {
                VStack{
                    HStack{
                        smallBox(title: "DASHBOARD", view: Text("Allo"))
                        smallBox(view: Text("Allo"))
                    }
                    HStack{
                        smallBox(view: Text("Allo"))
                        smallBox(view: Text("Allo"))
                    }
                    
                    
                }
                
                mediumBox(view: Text("Allo"))
            }
            GridRow {
                //smallBox(view: Text("Allo"))
                longBox(view: Text("allo"))
            }
            .gridCellColumns(3)
        }
        
    }
}
#Preview {
    RootNavigation()
}
