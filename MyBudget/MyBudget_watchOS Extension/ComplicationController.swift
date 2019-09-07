//
//  ComplicationController.swift
//  MyBudget_watchOS Extension
//
//  Created by Johannes on 06.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    private var modularSmallTemplate: CLKComplicationTemplateModularSmallSimpleImage {
        get {
            let image = UIImage(named: "Complication/Modular")!
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = CLKImageProvider.init(onePieceImage: image)
            template.imageProvider.tintColor = .blueActionColor
            return template
        }
    }
    
    private var graphicCircularTemplate: CLKComplicationTemplate? {
        get {
            if #available(watchOSApplicationExtension 5.0, *) {
                let image = UIImage(named: "Complication/Graphic Circular")!
                let template = CLKComplicationTemplateGraphicCircularImage()
                template.imageProvider = CLKFullColorImageProvider.init(fullColorImage: image)
                return template
            } else {
                return nil
            }
        }
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let image = UIImage(named: "Complication/Graphic Circular")!
        print(image)
        
        if complication.family == .modularSmall {
            let entry = CLKComplicationTimelineEntry.init(date: Date(), complicationTemplate: modularSmallTemplate)
            handler(entry)

        } else {
            if #available(watchOSApplicationExtension 5.0, *) {
                if complication.family == .graphicCircular {
                    let entry = CLKComplicationTimelineEntry.init(date: Date(), complicationTemplate: graphicCircularTemplate!)
                    handler(entry)
                } else {
                    handler(nil)
                }
            }
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let image = UIImage(named: "Complication/Graphic Circular")!
        print(image)
        
        if complication.family == .modularSmall {
            handler(modularSmallTemplate)
        } else {
            if #available(watchOSApplicationExtension 5.0, *) {
                if complication.family == .graphicCircular {
                    handler(graphicCircularTemplate)
                } else {
                    handler(nil)
                }
            }
        }
    }
    
    
}
