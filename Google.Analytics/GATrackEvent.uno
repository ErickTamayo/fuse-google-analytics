using Uno.UX;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers.Actions;
using Google.Analytics;

public partial class GATrackEvent: TriggerAction
{
    string _category;
    string _action;
    string _label;
    string _value;

    public string Category {
        get { return _category; }
        set { _category = value; }
    }

    public string Action {
        get { return _action; }
        set { _action = value; }
    }

    public string Label {
        get { return _label; }
        set { _label = value; }
    }

    public string Value {
        get { return _value; }
        set { _value = value; }
    }

    [UXConstructor]
    public GATrackEvent() {}

    protected override sealed void Perform(Node target) {
        AnalyticsService.TrackEvent(_category, _action, _label, _value);
    }
}