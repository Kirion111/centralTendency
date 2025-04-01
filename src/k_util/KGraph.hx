package k_util;

import lime.math.ColorMatrix;
import haxe.ui.Toolkit;
import haxe.ui.components.Canvas;
import haxe.ui.geom.Point;
import haxe.ui.graphics.ComponentGraphics;
import k_util.UserStatics;
import k_util.DataUtil;

//@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class KGraph extends Canvas {
    private static var grdSize:Float = 20;
    private static var offset1:Float = 0;
    public function new() {
        super();
        this.visible = false;
        drawGraph();
    }
    private function drawGraph()
    {
        var uCount:Int = 0;
        DataUtil.mode(UserStatics.data);
        for(key=>instances in UserStatics.userModes)
            uCount++;

        grdSize = get_height()/uCount;
        
        componentGraphics.clear();
        drawGrid(componentGraphics, this.width, this.height, grdSize);
        drawData(componentGraphics, grdSize);

        Toolkit.callLater(drawGraph);
    }
    private function drawData(graphics:ComponentGraphics, gridSize:Float) {
        var size = 2;
        var uCount:Int = 0;
        #if haxeui_heaps 
        size = 3;
        #end
        for(key=>instances in UserStatics.userModes)
        {
            graphics.fillStyle(UserStatics.userColors[uCount], .2);
            graphics.strokeStyle(UserStatics.userColors[uCount], size);
            graphics.moveTo(uCount*gridSize, get_height());
            graphics.lineTo(uCount*gridSize, instances*gridSize);
            graphics.lineTo((uCount+1)*gridSize, instances*gridSize);
            graphics.lineTo((uCount+1)*gridSize, get_height());

            graphics.rectangle(uCount*gridSize, get_height()-(get_height()-(instances*gridSize)), gridSize, get_height()-(instances*gridSize));

            uCount++;
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