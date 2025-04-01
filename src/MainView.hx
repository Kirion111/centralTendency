package ;

import k_util.UserStatics;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.events.MouseEvent;
import haxe.ui.util.Color;
import k_util.DataUtil;
import k_util.KGraph;

using StringTools;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
    public function new() {
        super();
        loadFile.onClick = function(e)
        {
            var helper = new OpenFileDialog();
            helper.show();
            helper.onDialogClosed = function (event) {
                var files = helper.selectedFiles;
                if(event.canceled || files == null)
                {
                    Dialogs.messageBox("Archivo Invalido", "Error", MessageBoxType.TYPE_ERROR, true);
                    return;
                }
                if(!files[0].name.endsWith(".txt")){
                    Dialogs.messageBox("Archivo Invalido (Nombre del archivo:" + files[0].name+ ")", "Error", MessageBoxType.TYPE_ERROR, true);
                    return;
                }
                
                UserStatics.data = [];
                for(value in DataUtil.getData(files[0].fullPath))
                {
                    if(value.length > 1)
                    {
                        for(char in value.split(""))
                        {
                            if((char.charCodeAt(0) < 48 || char.charCodeAt(0) > 57) && char.charCodeAt(0) != 44 && char.charCodeAt(0) != 46)
                            {
                                Dialogs.messageBox("Su archivo contiene caracteres invalidos", "Error", MessageBoxType.TYPE_ERROR, true);
                                return;
                            }
                        }
                    }
                    else
                    {
                        if(value == "" || value == null)
                            continue;

                        if((value.charCodeAt(0) < 48 || value.charCodeAt(0) > 57) && value.charCodeAt(0) != 44)
                        {
                            Dialogs.messageBox("Su archivo contiene caracteres invalidos", "Error", MessageBoxType.TYPE_ERROR, true);
                            return;
                        }
                    }
                    UserStatics.data.push(Std.parseFloat(value));
                }
                trace(UserStatics.data);
            }
            resetDisplay();
        }
        loadRaw.onClick = function(e){
            if(rawData.text == "" || rawData.text == null)
            {
                Dialogs.messageBox("Introduzca datos Validos en la caja de texto", "Error", MessageBoxType.TYPE_ERROR, true);
                return;
            }
            UserStatics.data = [];
            for(value in rawData.text.split(","))
            {
                if(value == "")
                    continue;

                UserStatics.data.push(Std.parseFloat(value));
            }

            trace(UserStatics.data);
            resetDisplay();
        }
        median.onClick = function (e){
            if(DataUtil.checkData())
                return;
            
            medianDisplay.htmlText = "La Mediana es: " + DataUtil.median(UserStatics.data);
        }
        mean.onClick = function (e){
            if(DataUtil.checkData())
                return;

            meanDisplay.htmlText = "El promedio es: " + DataUtil.mean(UserStatics.data);
        }
        mode.onClick = function (e){
            if(DataUtil.checkData())
                return;

            final dspl = DataUtil.mode(UserStatics.data);
            final txt:String = dspl.length > 1 ? "Las modas son: " : "La moda es: ";

            modeDisplay.htmlText = txt + dspl;
        }
        graph.onClick = function (e) {
            if(DataUtil.checkData())
                return;

            for(key=>instances in UserStatics.userModes)
            {
                var localColor:Color = 0xffffff;
                localColor.set(Std.int(Math.random()*255), Std.int(Math.random()*255), Std.int(Math.random()*255), 255);
                UserStatics.userColors.push(localColor);
            }
            
            graphDisaplay.percentHeight = 50;
            daGraph.visible = true;
            daGraph.show();
        }
        
    }
    private function resetDisplay()
    {
        medianDisplay.htmlText = "";
        meanDisplay.htmlText = "";
        modeDisplay.htmlText = "";
        graphDisaplay.percentHeight = 5;
        daGraph.visible = false;
    }
}