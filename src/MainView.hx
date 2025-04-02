package ;

import haxe.ui.Toolkit;
import k_util.UserStatics;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.components.Label;
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
            resetDisplay();
            UserStatics.data = [];
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
                daGraph.visible = true;
                trace(UserStatics.data);
            }
        }
        loadRaw.onClick = function(e){
            resetDisplay();
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
            daGraph.visible = true;
            trace(UserStatics.data);
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
        daGraph.drawCallBack = function()
        {
            resetGraphMarks();
            //trace("called");
        }
        
    }
    public function resetGraphMarks()
    {
        leftData.removeChildren();
        rightData.removeChildren();
        var uCount:Int = 0;
        for(data in UserStatics.orderedModes)
        {
            //final curModeRep = UserStatics.userModes.get(""+UserStatics.orderedModes[UserStatics.orderedModes.indexOf(data)]);
            var rightTxt = new Label();

            rightTxt.x = (UserStatics.userGrdSz)*(uCount+1) + (UserStatics.userGrdSz*0.5);
            rightTxt.width = (UserStatics.userGrdSz)*(uCount+1);
            rightTxt.htmlText = ""+data;

            rightData.addChildAt(rightTxt, uCount);
            uCount++;
        }
        for(i in 0...Std.int(daGraph.height/UserStatics.userGrdSz)+1)
        {
            var leftTxt = new Label();
            leftTxt.y = daGraph.height-((UserStatics.userGrdSz)*i);
            leftTxt.height = UserStatics.userGrdSz*i;
            leftTxt.htmlText = ""+(i);

            leftData.addChildAt(leftTxt, i);
        }
    }
    private function resetDisplay()
    {
        medianDisplay.htmlText = "";
        meanDisplay.htmlText = "";
        modeDisplay.htmlText = "";
        daGraph.visible = false;
    }
}