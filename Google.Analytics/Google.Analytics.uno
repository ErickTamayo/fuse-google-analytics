using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;
using Uno.Threading;
using Uno.Platform2;

namespace Google.Analytics
{
    [extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'Google/Analytics'")]
    [extern(iOS) Require("Source.Import","Google/Analytics.h")]
    extern(iOS)
    internal class AnalyticsService
    {
        [Foreign(Language.ObjC)]
        extern(iOS)
        public void StartService(ApplicationState state)
        @{
            NSError *configureError;
            [[GGLContext sharedInstance] configureWithError:&configureError];
            NSCAssert(!configureError, @"Error configuring Google services: %@", configureError);

            // Optional: configure GAI options.
            GAI *gai = [GAI sharedInstance];
            gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
            gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public void ScreenView(string name)
        @{
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:name];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            [[GAI sharedInstance] dispatch];
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public void TrackEvent(string eventCategory, string eventAction, string eventLabel, string eventValue)
        @{
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *eventValueNumber = [formatter numberFromString:eventValue];

            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventCategory
                                                      action:eventAction
                                                       label:eventLabel
                                                       value:eventValueNumber] build]];
            [[GAI sharedInstance] dispatch];
        @}
    }

    [extern(Android) ForeignInclude(Language.Java,
        "com.google.android.gms.analytics.GoogleAnalytics",
        "com.google.android.gms.analytics.Tracker",
        "com.google.android.gms.analytics.HitBuilders",
        "android.content.res.XmlResourceParser",
        "org.xmlpull.v1.XmlPullParserException",
        "java.io.IOException")]
    [extern(Android) Require("Gradle.Dependency.ClassPath", "com.google.gms:google-services:3.0.0")]
    [extern(Android) Require("Gradle.Dependency.Compile", "com.google.android.gms:play-services-analytics:9.4.0")]
    [extern(Android) Require("Gradle.BuildFile.End", "apply plugin: 'com.google.gms.google-services'")]
    extern(Android)
    internal class AnalyticsService
    {
        extern(Android) Java.Object _defaultTracker;

        extern(Android)
        public void StartService(ApplicationState state)
        {
            _defaultTracker = createDefaultTracker();
        }

        extern(Android)
        public void ScreenView(string name)
        {
            ScreenViewWithTracker(_defaultTracker, name);
        }

        extern(Android)
        public void TrackEvent(string eventCategory, string eventAction, string eventLabel, string eventValue)
        {
            TrackEventWithTracker(_defaultTracker, eventCategory, eventAction, eventLabel, eventValue);
        }

        [Foreign(Language.Java)]
        extern (Android)
        protected Java.Object createDefaultTracker()
        @{
            int gs = 0;

            try {
                String rStr = com.fuse.Activity.getRootActivity().getClass().getPackage().getName().concat(".R");
                Class<?> rClass = Class.forName(rStr);
                for (Class<?> item : rClass.getClasses()) {
                    if(item.getName().equals(rStr.concat("$xml"))) {
                        gs = item.getField("google_services").getInt(item);
                    }
                }
            } catch (Exception e) {
                return null;
            }

            GoogleAnalytics analytics = GoogleAnalytics.getInstance(com.fuse.Activity.getRootActivity());

            XmlResourceParser parser = com.fuse.Activity.getRootActivity()
                .getResources()
                .getXml(gs);

                String trackingId = "";

                try {
                    int eventType = parser.getEventType();
                    boolean trackingTag = false;

                    while (eventType != XmlResourceParser.END_DOCUMENT) {
                        if(eventType == XmlResourceParser.START_TAG && parser.getName().equals("tracking_id")) {
                            trackingTag = true;
                        } else if(eventType == XmlResourceParser.TEXT && trackingTag) {
                            trackingId = parser.getText();
                            trackingTag = false;
                        }
                        eventType = parser.next();
                    }
                } catch (Exception e) {
                    return null;
                }

            debug_log(trackingId);
            return analytics.newTracker(trackingId);
        @}

        [Foreign(Language.Java)]
        extern(Android)
        public void ScreenViewWithTracker(Java.Object tracker, string name)
        @{
            if (tracker == null) {
                debug_log("Tracker not initialized");
                return;
            }

            Tracker tr = (Tracker) tracker;
            tr.setScreenName(name);
            tr.send(new HitBuilders.ScreenViewBuilder().build());

            GoogleAnalytics.getInstance(com.fuse.Activity.getRootActivity()).dispatchLocalHits();
        @}

        [Foreign(Language.Java)]
        extern(Android)
        public void TrackEventWithTracker(Java.Object tracker, string eventCategory, string eventAction, string eventLabel, string eventValue)
        @{
            if (tracker == null) {
                debug_log("Tracker not initialized");
                return;
            }

            Tracker tr = (Tracker) tracker;
            tr.send(new HitBuilders.EventBuilder()
                .setCategory(eventCategory)
                .setAction(eventAction)
                .setLabel(eventLabel)
                .setValue(Long.parseLong(eventValue))
                .build());

            GoogleAnalytics.getInstance(com.fuse.Activity.getRootActivity()).dispatchLocalHits();
        @}
    }

    extern(!mobile)
    internal class AnalyticsService
    {
        public void StartService(ApplicationState state) {
            debug_log("Google Analytics not supported in this platform.");
        }
        public void ScreenView(string page) {
            debug_log("Google Analytics not supported in this platform.");
        }
        public void TrackEvent(string eventCategory, string eventAction, string eventLabel, string eventValue) {
            debug_log("Google Analytics not supported in this platform.");
        }
    }
}
