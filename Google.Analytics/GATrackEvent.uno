using Uno.UX;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers.Actions;
using Google.Analytics.JS;

public partial class GATrackEvent: TriggerAction
{
    protected AnalyticsModule _analyticsModule;

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
    public GATrackEvent() {
        _analyticsModule = new AnalyticsModule();
    }

    protected override sealed void Perform(Node target) {

        object[] args = new object[4];

        args[0] = _category;
        args[1] = _action;
        args[2] = _label;
        args[3] = _value;

        _analyticsModule.TrackEvent(null, args);
    }
}