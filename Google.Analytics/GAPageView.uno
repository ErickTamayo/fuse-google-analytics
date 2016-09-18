using Uno.UX;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers.Actions;
using Google.Analytics;

public partial class GAPageView: TriggerAction
{
    string _page;

    public string Page {
        get { return _page; }
        set { _page = value; }
    }

    [UXConstructor]
    public GAPageView() {}

    protected override sealed void Perform(Node target) {
        AnalyticsService.ScreenView(_page);
    }
}