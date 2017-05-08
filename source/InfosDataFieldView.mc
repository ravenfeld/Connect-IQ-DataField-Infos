
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class InfosDataFieldView extends Ui.DataField
{
	hidden var SIZE_DATAFIELD_1 = 240;
	hidden var gps;
	hidden var old_battery_low=0;
	hidden var old_gps_low=0;
     
    function initialize() {
        DataField.initialize();
    }
    
    function compute(info)
    {
        gps = info.currentLocationAccuracy;
    }
    
    function onUpdate(dc)
    {     
    	var battery =  App.getApp().getProperty("battery_display");
    	var gps =  App.getApp().getProperty("gps_display");
    	var x = dc.getWidth()/2;
        
    	if(battery){
    		var y = dc.getWidth()/2;
    		if(gps){
    			y = dc.getHeight()/4;
    		}
			drawBattery(System.getSystemStats().battery,x,y,dc);
		}
		if(gps){
		   	var y = dc.getHeight()/2;
    		if(battery){
    			y = y + dc.getHeight()/4;
    		}
			drawGPS(x,y,dc);
		}		
    }
        
    function drawBattery(battery,x,y, dc) {      
        var color =  getColor(App.getApp().getProperty("battery_color"), getTextColor());
    	var color_low = getColor(App.getApp().getProperty("battery_color_low"), Graphics.COLOR_RED);
		var color_text_default = getColor(App.getApp().getProperty("battery_color_text"), getTextColor());
		var color_text_low = getColor(App.getApp().getProperty("battery_color_text_low"), Graphics.COLOR_RED);
		var color_text = color_text_default;
		var scale_property = App.getApp().getProperty("battery_scale");
		var scale;
		if(dc.getWidth()==SIZE_DATAFIELD_1 && dc.getHeight()==SIZE_DATAFIELD_1 && scale_property==1){
			scale=2;
		}else if(dc.getWidth()==SIZE_DATAFIELD_1 && dc.getHeight()==SIZE_DATAFIELD_1 && scale_property==2){
			scale=2.75;
		}else {
			scale=1;
		}
        var flag = getObscurityFlags();
        var width = dc.getWidth();
        var height = dc.getHeight()/2;
        var size_w = 50*scale;
        var size_h = 27*scale;
    	x = x-size_w/2;
        y = y- size_h/2+5;
          
        dc.setColor( color, Gfx.COLOR_TRANSPARENT );

        if(flag>=OBSCURE_BOTTOM){
        	y = y-10;
        	flag=flag-OBSCURE_BOTTOM;
        }                
        if(flag>=OBSCURE_RIGHT){
        	x = x-10;
        	flag=flag-OBSCURE_RIGHT;
        } 
        if(flag>=OBSCURE_TOP){
            y = y+15;
        	flag=flag-OBSCURE_TOP;
        }
        if(flag>=OBSCURE_LEFT){
            x = x+10;
        }
                  
        dc.drawRectangle(x, y, size_w, size_h);
        dc.fillRectangle(x + size_w - 1, y + 7, 4*scale, size_h - 14); 
                 
       	var battery_low =  App.getApp().getProperty("battery_low");
    	if(battery<=battery_low){
    		var battery_alarm =  App.getApp().getProperty("battery_alarm");
    		if(battery_alarm && old_battery_low!=battery_low){
    			old_battery_low=battery_low;
    			alarm();
    		}
    		color_text = color_text_low;
            dc.setColor(color_low, Graphics.COLOR_TRANSPARENT);
        }
        
        var display_percentage = App.getApp().getProperty("battery_percentage");
        
        if(display_percentage){
        	var font = Graphics.FONT_SMALL;
        	if (scale_property == 1 ){
        		font = Graphics.FONT_NUMBER_MEDIUM;
        	}else if (scale_property == 2){
        		font = Graphics.FONT_NUMBER_HOT;
        	}
        	dc.setColor(color_text, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x+size_w/2 , y+size_h/2, font, format("$1$%", [battery.format("%d")]), Graphics.TEXT_JUSTIFY_VCENTER| Graphics.TEXT_JUSTIFY_CENTER);
        }else{
        	dc.fillRectangle(x + 1, y + 1, (size_w-2) * battery / 100, size_h - 2);
        }
    }
        
    function drawGPS(x,y,dc){    
        var flag = getObscurityFlags();
		var scale_property = App.getApp().getProperty("gps_scale");
		var scale;

		if(dc.getWidth()==SIZE_DATAFIELD_1 && dc.getHeight()==SIZE_DATAFIELD_1 && scale_property==1){
			scale=1.4;
		}else if(dc.getWidth()==SIZE_DATAFIELD_1 && dc.getHeight()==SIZE_DATAFIELD_1 && scale_property==2){
			scale=1.8;
		}else {
			scale=1;
 		}

        var width = dc.getWidth();
        var height = dc.getHeight()/2;
        var bar_height = height / 2;
        
        var size_w = width/12 * scale;
        var size_h = bar_height/4 ;
        var space = size_w/4;
        
        y = y -bar_height/2;
        
        var color = getColor(App.getApp().getProperty("gps_color"), getTextColor());
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        
        if(flag>=OBSCURE_BOTTOM){
        	y = y-15;
        	flag=flag-OBSCURE_BOTTOM;
        } 
        if(flag>=OBSCURE_RIGHT){
        	x = x-10;
        	flag=flag-OBSCURE_RIGHT;
        }
        if(flag>=OBSCURE_TOP){
            y = y+5;
        	flag=flag-OBSCURE_TOP;
        } 
        if(flag>=OBSCURE_LEFT){
            x = x+10;
        }
        
		
    	if(gps!=null){
    		var gps_low =  App.getApp().getProperty("gps_low");
    		var gps_alarm =  App.getApp().getProperty("gps_alarm");
    		if( gps_alarm && gps_low >= gps && old_gps_low != gps){
    			old_gps_low = gps;
    			alarm();
    		}
    		if( gps == 4){
    			dc.fillRectangle(x+size_w+space/2+space, y, size_w, bar_height);
			}
			if(gps >=3 ) {
				dc.fillRectangle(x+space/2, y+size_h, size_w, bar_height-size_h);
			}
			if(gps >= 2 ) {
				dc.fillRectangle(x-size_w-space/2, y+2*size_h, size_w, bar_height-2*size_h);
			}
			if(gps >= 1 ) {
				dc.fillRectangle(x-size_w*2-space/2-space, y+3*size_h, size_w, bar_height-3*size_h);			
			}
		}
		dc.drawRectangle(x-size_w*2-space/2-space, y+3*size_h, size_w, bar_height-3*size_h);
		dc.drawRectangle(x-size_w-space/2, y+2*size_h, size_w, bar_height-2*size_h);
		dc.drawRectangle(x+space/2, y+size_h, size_w, bar_height-size_h);
		dc.drawRectangle(x+size_w+space/2+space, y, size_w, bar_height);
		
    }
        
    function getColor(color_property, color_default){
        if (color_property == 1) {
        	return Gfx.COLOR_BLUE;
        }else if (color_property == 2) {
        	return Gfx.COLOR_DK_BLUE;
        }else if (color_property == 3) {
        	return Gfx.COLOR_GREEN;
        }else if (color_property == 4) {
        	return Gfx.COLOR_DK_GREEN;
        }else if (color_property == 5) {
        	return Gfx.COLOR_LT_GRAY;
        }else if (color_property == 6) {
        	return Gfx.COLOR_DK_GRAY;
        }else if (color_property == 7) {
        	return Gfx.COLOR_ORANGE;
        }else if (color_property == 8) {
        	return Gfx.COLOR_PINK;
        }else if (color_property == 9) {
        	return Gfx.COLOR_PURPLE;
        }else if (color_property == 10) {
        	return Gfx.COLOR_RED;
        }else if (color_property == 11) {
        	return Gfx.COLOR_DK_RED;
        }else if (color_property == 12) {
        	return Gfx.COLOR_YELLOW;
        }
        return color_default;
    }
    
    function getTextColor(){
    	return (getBackgroundColor() == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
    }
    
    function alarm(){
		if (Attention has :vibrate) {
			var vibrateData = [
				new Attention.VibeProfile(  25, 100 ),
				new Attention.VibeProfile(  50, 100 ),
				new Attention.VibeProfile(  75, 100 ),
				new Attention.VibeProfile( 100, 100 ),
				new Attention.VibeProfile(  75, 100 ),
				new Attention.VibeProfile(  50, 100 ),
				new Attention.VibeProfile(  25, 100 )
			];

			Attention.vibrate(vibrateData);
		} 
	}
}
