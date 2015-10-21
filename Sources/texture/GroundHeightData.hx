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
    this.image = Loader.the.getImage("heightMap");
    this.data = new Array<Int>();

    
    var bytes = this.image.lock();

    for (i in 0...Std.int(bytes.length / 4)) {
      this.data.push(bytes.get(i*4));
    }

    this.image.unlock();
    
  }

  public function getValue(position:Vector2):Int {

    var heightMapX = Math.floor(position.x * (this.size - 1));
    var heightMapY = Math.floor(position.y * (this.size - 1));
    var i = heightMapX + heightMapY * this.size;
    
    return this.data[i];
  }

  public function getImage():Image {
    return this.image;
  }
}