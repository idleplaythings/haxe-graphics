package texture;

import kha.Image;
import kha.Color;
import kha.graphics2.Graphics1;


class GroundCellTestAtlasTexture {

  private var image:Image;


  public function new(size:Int) {

    this.image = Image.createRenderTarget(size, size);
    
    var g = this.image.g2;
    g.begin();

    
    for (x in 0...size) {
      for (y in 0...size) {
        g.color = Color.fromBytes(
          this.selectRandomHighGrass(),
          this.selectRandomBrush(),
          255,
          255
        );

        g.fillRect(x, y, 1, 1);
      }
    }

    g.end();
    
  }

  public function getImage():Image {
    return this.image;
  }

  private function selectRandomBrush():Int{
    return Math.floor(Math.random()*8)+56;
  }

  private function selectRandom():Int{
    return Math.floor(Math.random()*37);
  }

  private function selectMud():Int{
    return Math.floor(Math.random()*0)+40;
  }

  private function selectRandomGrass():Int{
    return Math.floor(Math.random()*24);
  }

  private function selectRandomSmallGrass():Int{
    return Math.floor(Math.random()*16);
  }

  private function selectRandomHighGrass():Int{
    return Math.floor(Math.random()*8);
  }

  private function selectRandomMediumGrass():Int{
    return Math.floor(Math.random()*8)+8;
  }

  private function selectRandomLowGrass():Int{
    return Math.floor(Math.random()*8)+16;
  }

  private function selectRandomGravel():Int{
    return Math.floor(Math.random()*8)+24;
  }

  private function selectRandomTwigs():Int{
    return Math.floor(Math.random()*5)+32;
  }

}