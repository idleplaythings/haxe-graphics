package mesh;

import shaders.GroundShaderProgram;
import kha.graphics4.Graphics;
import kha.math.Vector3;
import kha.Image;
import kha.Loader;
import texture.GroundCellTestAtlasTexture;
import texture.GroundHeightData;

class GroundCell{
  
  private var program:GroundShaderProgram;
  private var mesh:GroundCellMesh;
  private var tileAtlasImage:Image;
  private var heightMap:GroundHeightData;

  public function new(position:Vector3, size:Int, program:GroundShaderProgram) {
    this.program = program;
    this.heightMap = new GroundHeightData(1024);
    this.mesh = GroundMaker.getMesh(size, size*3, this.heightMap);
    this.program.link(this.mesh);
    this.tileAtlasImage = new GroundCellTestAtlasTexture(size).getImage();
    
  }

  public function render(g4:Graphics):Void {
    g4.setVertexBuffer(mesh.getVertexBuffer());
    g4.setIndexBuffer(mesh.getIndexBuffer());

    this.program.setModelView(g4, mesh.getModelViewMatrix());
    this.program.setTileAtlasTexture(g4, this.tileAtlasImage);
    
    // Draw!
    g4.drawIndexedVertices();
  }
}