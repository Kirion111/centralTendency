package k_util;

import haxe.ui.Toolkit;
import haxe.ui.components.Canvas;
import haxe.ui.geom.Point;
import haxe.ui.graphics.ComponentGraphics;
import k_util.UserStatics;
import k_util.DataUtil;

//@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class KGraph extends Canvas {
    public var grdSize:Float = 20;
    public var drawCallBack:Void->Void = function(){};
    private static var offset1:Float = 0;
    public function new() {
        super();
        //this.visible = false;
        drawGraph();
    }
    private function drawGraph()
    {
        var uCount:Int = 0;
        DataUtil.mode(UserStatics.data);
        for(key=>instances in UserStatics.userModes)
            uCount++;

        grdSize = get_height()/uCount;
        UserStatics.userGrdSz = grdSize;
        
        componentGraphics.clear();
        if(!DataUtil.fastCheckData())
        {
            drawGrid(componentGraphics, this.width, this.height, grdSize);
            drawData(componentGraphics, grdSize);
            drawCallBack();
        }

        Toolkit.callLater(drawGraph);
    }
    private function drawData(graphics:ComponentGraphics, gridSize:Float) {
        var size = 1;
        var uCount:Int = 0;
        for(data in UserStatics.orderedModes)
        {
            final curModeRep = UserStatics.userModes.get(""+UserStatics.orderedModes[UserStatics.orderedModes.indexOf(data)]);
            graphics.fillStyle(0x000000, .2);
            if(DataUtil.mode(UserStatics.data).contains(data))
                graphics.fillStyle(UserStatics.userColors[0], .2);

            graphics.strokeStyle(0x000000, size);
            graphics.moveTo(uCount*gridSize, get_height());
            graphics.lineTo(uCount*gridSize, get_height()-(curModeRep*gridSize));
            graphics.lineTo((uCount+1)*gridSize, get_height()-(curModeRep*gridSize));
            graphics.lineTo((uCount+1)*gridSize, get_height());

            graphics.rectangle(uCount*gridSize, (get_height()-(curModeRep*gridSize)), gridSize, (curModeRep*gridSize));

            uCount++;
        }

        final mid:Int = Math.round(UserStatics.data.length/2);
        var numbers = DataUtil.getOrderedData(UserStatics.data);

        final medianPoint = UserStatics.orderedModes.indexOf(numbers[mid-1]);
        final result:Float = numbers.length % 2 == 0 ? ((gridSize*medianPoint) + (gridSize*0.5)) : ((gridSize*medianPoint) + gridSize);
        graphics.strokeStyle(UserStatics.userColors[1], size);
        graphics.moveTo(result, get_height());
        graphics.lineTo(result, 0);

        for(i in 0...UserStatics.orderedModes.length)
        {
            final curValue = UserStatics.orderedModes[i];
            var nextValue:Float = 10;
            if(i < UserStatics.orderedModes.length-1)
                nextValue = UserStatics.orderedModes[i+1];
            
            if(curValue < DataUtil.mean(numbers) && DataUtil.mean(numbers) < nextValue)
            {
                graphics.strokeStyle(UserStatics.userColors[2], size);
                graphics.moveTo(((i+1)*gridSize)+(gridSize*0.5), get_height());
                graphics.lineTo(((i+1)*gridSize)+(gridSize*0.5), 0);
                break;
            }
        }
    }
    private function drawGrid(graphics:ComponentGraphics, cx:Float, cy:Float, gridSize:Float) {
        var size = .5;
        #if haxeui_heaps 
        size = 1;
        #end
        if (Toolkit.theme == "dark") {
            graphics.strokeStyle(0x222426, size);
        } else {
            graphics.strokeStyle(0x7d0000, size);
        }
        for (x in 0...Std.int((cx / gridSize)) + 1) {
            graphics.moveTo(x * gridSize + size, 0);
            graphics.lineTo(x * gridSize + size, cy);
        }
        graphics.moveTo(cx - size, 0);
        graphics.lineTo(cx - size, cy);
    
        for (y in 0...Std.int((cy / gridSize)) + 1) {
            graphics.moveTo(0, y * gridSize + size);
            graphics.lineTo(cx, y * gridSize + size);
        }
        graphics.moveTo(0, cy - size);
        graphics.lineTo(cx, cy - size);

    }
}