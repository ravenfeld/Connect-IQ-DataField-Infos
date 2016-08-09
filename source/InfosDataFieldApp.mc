using Toybox.Application as App;

class InfosDataFieldApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }
    
    function onStart(state) {
    }

    function onStop(state) {
    }
    
    function getInitialView()
    {
        return [new DataFieldView()];
    }
    
    function onSettingsChanged()
    {
        Ui.requestUpdate();
    }

}