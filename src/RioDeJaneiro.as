package
{
	
	import assets.Texto;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	
	[SWF(width='396',height='559',backgroundColor='#000000',frameRate='120')]
	
	public class RioDeJaneiro extends Sprite
	{
		
		
		private var bitmapDataBase:BitmapData;
		private var bitmapDataView:BitmapData;
		private var bitmap:Bitmap;
		
		private var points:Vector.<Point>;
		private var current:int = 0;

		
		public function RioDeJaneiro()
		{
			bitmapDataBase = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			bitmapDataView = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0xff000000);
			bitmap = new Bitmap(bitmapDataView);	
			addChild(bitmap);
			
			bitmapDataBase.draw(new Texto());
			
			points = new Vector.<Point>(3000);
			for (var i:int = 0; i < points.length; i++) {
				points[i] = new Point(Math.random()*stage.stageWidth, Math.random()*stage.stageHeight);
				//points[i] = new Point(Math.random()*stage.stageWidth, 0);
			}
			
			current = 0;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void
		{
			bitmapDataBase.lock();
			bitmapDataView.lock();
			
			var px:int;
			var py:int;
			for (var i:int = 0; i < points.length; i++)
			{
				current++;
				if (current == points.length) {
					current = 0;
				}
				
				px = points[current].x;
				py = points[current].y;
				
				//se encontrar o chão ou outro pixel
				if (bitmapDataBase.getPixel32(px, py+1) == 0xff000001 || bitmapDataBase.getPixel32(px, py+1) == 0xffffffff) {
					//nao fazer nada
				}
				//se abaixo estiver vazio
				else if (bitmapDataBase.getPixel32(px, py+1) == 0x00000000) {
					//cair
					bitmapDataBase.setPixel32(px, py, 0x00000000);
					//pequena chance de ir para o lado livremente
					var xDiff:int = 0;
					if (Math.random() > 0.1) {
						xDiff = (Math.random() > 0.5) ? 1 : -1;
						if (px+xDiff < 0 || px+xDiff > stage.stageWidth) {
							xDiff = 0;
						}
					}
					bitmapDataBase.setPixel32(px+xDiff, py+1, 0xffffffff);
					points[current].y++;
					points[current].x += xDiff;
				} 
				else {
					//se escolher ir para a direita
					if (current%2 == 1) {
						//se a direita estiver vazia
						if (bitmapDataBase.getPixel32(px+1, py) == 0x00000000) {
							//ir para a direita
							bitmapDataBase.setPixel32(px, py, 0x00000000);
							bitmapDataBase.setPixel32(px+1, py, 0xffffffff);
							points[current].x++;
						}
					}
					//se escolher ir para a esquerda
					else {
						//se a esquerda tiver vazia
						if (bitmapDataBase.getPixel32(px-1, py) == 0x00000000) {
							//ir para a esquerda
							bitmapDataBase.setPixel32(px, py, 0x00000000);
							bitmapDataBase.setPixel32(px-1, py, 0xffffffff);
							points[current].x--;
						}
					}
				}
				
				//se sair da tela, retornar
				if (points[current].y >= stage.stageHeight) {
					//retornar no topo
					points[current].x = Math.random()*stage.stageWidth;
					points[current].y = 0;
				}
				
			}
			
			//bitmapDataView.applyFilter(bitmapDataView, bitmapDataView.rect, new Point(), new BlurFilter(1,1,1));
			var c:ColorTransform = new ColorTransform(1,0.8,0,0.1);
			bitmapDataView.draw(bitmapDataBase, null, c);
			
			
			bitmapDataBase.unlock();
			bitmapDataView.unlock();
			
		}
	}
}