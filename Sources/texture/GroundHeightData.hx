package texture;

import kha.Image;
import kha.Color;
import kha.Loader;
import kha.math.Vector2;


class GroundHeightData {

  private var image:Image;
  private var data:Array<Int>;
  private var size:Int;


  public function new(size:Int) {
    this.size = size;
    this.image = Loader.the.getImage("heightmap1024");
    this.data = new Array<Int>();


    for (y in 0...size){
      for (x in 0...size){
        var red = image.at(x, y).Rb;
        this.data.push(red);
      }
    }
    
  }

  public function getValue(position:Vector2):Float {

    var heightMapX = Math.floor(position.x * (this.size - 1));
    var heightMapY = Math.floor(position.y * (this.size - 1));
    var i = heightMapX + heightMapY * this.size;
    
    return this.data[i] / 20;
  }

  public function getImage():Image {
    return this.image;
  }
}