package k_util;

import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox;
import haxe.ds.Map;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class DataUtil{

    public static function getData(path:String):Array<String> {
        #if sys
        if(!FileSystem.exists(path))
            return [];

        return File.getContent(path).replace("\n", "").replace(" ", "").replace(String.fromCharCode(9), "").replace(String.fromCharCode(10), "").replace(String.fromCharCode(11), "")
        .replace(String.fromCharCode(12), "").replace(String.fromCharCode(13), "").replace(String.fromCharCode(32), "").split(",");
        #end
        return [];
    }

    /**
        @return true if there is no data loaded yet \\ false otherwise
    **/
    public static function checkData():Bool
    {
        if(UserStatics.data.length < 1)
            Dialogs.messageBox("Primero Carga datos desde un archivo\no de forma manual", "Error", MessageBoxType.TYPE_ERROR, true);

        return UserStatics.data.length < 1;
    }

    public static function mode(numbers:Array<Float>):Array<Float> {
        var uniqueNums:Map<String, Int> = new Map();
        var modes:Array<Float> = [];
        for(num in numbers)
        {
            if(uniqueNums.exists(""+num))
            {
                uniqueNums.set(""+num, uniqueNums.get(""+num)+1);
                continue;
            }
            uniqueNums.set(""+num, 1);
        }
        for(number=>instances in uniqueNums)
        {
            if(modes.length <= 0)
            {
                modes.push(Std.parseFloat(number));
                continue;
            }
            for(mod in modes)
            {
                if(instances > uniqueNums.get(""+mod))
                {
                    modes = [];
                    modes.push(Std.parseFloat(number));
                    break;
                }
                if(instances == uniqueNums.get(""+mod))
                {
                    modes.push(Std.parseFloat(number));
                    break;
                }
            }
        }
        return modes;
    }
    public static function median(numbers:Array<Float>):Float {
        final mid:Int = Math.round(numbers.length/2);
        var result:Float = numbers.length % 2 == 0 ? (numbers[mid-1]+numbers[mid])/2 : numbers[mid-1];
        
        return result;
    }
    public static function mean(numbers:Array<Float>):Float {
        var result:Float = 0;
        for(num in numbers)
            result+=num;
        
        return result/numbers.length;
    }
}