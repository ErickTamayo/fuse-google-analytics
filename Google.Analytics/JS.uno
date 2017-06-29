using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Text;
using Uno.Platform;
using Uno.Platform2;
using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Google.Analytics;

namespace Google.Analytics.JS
{
    [UXGlobalModule]
    public sealed class AnalyticsModule : NativeModule
    {
        static readonly AnalyticsModule _instance;
        static AnalyticsService _analyticsService;

        public AnalyticsModule()
        {
            if(_instance != null) return;

            Uno.UX.Resource.SetGlobalKey(_instance = this, "Google/Analytics");

            AddMember(new NativeFunction("ScreenView", ScreenView));
            AddMember(new NativeFunction("TrackEvent", TrackEvent));

            _analyticsService = new AnalyticsService();

            Fuse.Platform.Lifecycle.Started += _analyticsService.StartService;

            debug_log("Analytics Module Initialized");
        }

        public object ScreenView(Context context, object[] args)
        {
            debug_log("Screen View Fired");

            var name = (string)args[0];
            _analyticsService.ScreenView(name);
            return null;
        }

        public object TrackEvent(Context context, object[] args)
        {
            debug_log("Track Event Fired");

            var eventCategory = (args.Length>0) ? (string)args[0] : null;
            var eventAction = (args.Length>1) ? (string)args[1] : null;
            var eventLabel = (args.Length>2) ? (string)args[2] : null;
            var eventValue = (args.Length>3) ? (string)args[3] : null;

            _analyticsService.TrackEvent(eventCategory, eventAction, eventLabel, eventValue);

            return null;
        }
    }
}
