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
    //[extern(Android) ForeignInclude(Language.Java, "android.os.Bundle", "ccom.google.gms.google-services")]
    [extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'Google/Analytics'")]
    [extern(iOS) Require("Source.Import","Google/Analytics.h")]
    extern(mobile)
    internal class AnalyticsService
    {
        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void StartService(ApplicationState state)
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
        public static void ScreenView(string name)
        @{
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:name];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void TrackEvent(string eventCategory, string eventAction, string eventLabel, string eventValue)
        @{
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *eventValueNumber = [formatter numberFromString:eventValue];

            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventCategory
                                                      action:eventAction
                                                       label:eventLabel
                                                       value:eventValueNumber] build]];
        @}

        [Foreign(Language.Java)]
        extern(Android)
        public static void StartService(ApplicationState state)
        @{

        @}

        [Foreign(Language.Java)]
        extern(Android)
        public static void ScreenView(string message)
        @{

        @}

        [Foreign(Language.Java)]
        extern(Android)
        public static void TrackEvent(string eventCategory, string eventAction, string eventLabel, string eventValue)
        @{

        @}
    }

    extern(!mobile)
    internal class AnalyticsService
    {
        public static void StartService(ApplicationState state) {
            debug_log("Google Analytics not supported in this platform.");
        }
        public static void ScreenView(string message) {
            debug_log("Google Analytics not supported in this platform.");
        }
        public static void TrackEvent(string eventCategory, string eventAction, string eventLabel, string eventValue) {
            debug_log("Google Analytics not supported in this platform.");
        }
    }
}
