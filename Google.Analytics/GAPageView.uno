using Uno.UX;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers.Actions;
using Google.Analytics.JS;

public partial class GAPageView: TriggerAction
{
    protected AnalyticsModule _analyticsModule;

    string _page;

    public string Page {
        get { return _page; }
        set { _page = value; }
    }

    [UXConstructor]
    public GAPageView() {
        _analyticsModule = new AnalyticsModule();
    }

    protected override sealed void Perform(Node target) {

        object[] args = new object[1];

        args[0] = _page;

        _analyticsModule.ScreenView(null, args);
    }
}