package mesh;

import shaders.GroundShaderProgram;
import kha.graphics4.Graphics;
import kha.graphics4.BlendingOperation;
import kha.graphics4.CompareMode;
import kha.math.Vector3;
import camera.OrthographicCamera;

class Ground{

  private var program:GroundShaderProgram;
  private var groundCells:Array<GroundCell> = new Array<GroundCell>();

  private static var groundCellSize:Int = 32;
  
  public function new () {
    this.program = new GroundShaderProgram();

    var groundCell = new GroundCell(new Vector3(0, 0, 0), groundCellSize, this.program);
    groundCells.push(groundCell);
  }

  public function render(g4:Graphics, camera:OrthographicCamera):Void {
    g4.setProgram(this.program.getShaderProgram());
    this.program.init(g4);
    this.program.setProjectionView(g4, camera.getProjectionViewMatrix());
    //g4.setDepthMode(false, CompareMode.Never);
    //g4.setBlendingMode(BlendingOperation.InverseSourceAlpha, BlendingOperation.SourceAlpha);
   
    for (groundCell in groundCells) {
      groundCell.render(g4);
    }
  }

}