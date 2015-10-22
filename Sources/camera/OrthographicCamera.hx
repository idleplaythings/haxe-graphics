package camera;

import kha.math.Matrix4;
import kha.math.Vector3;
import kha.Sys;

class OrthographicCamera {
  
  private var position:Vector3 = new Vector3(50, 50, 50);
  private var target:Vector3 = new Vector3(0, 0, 0);
  private var vectorUp:Vector3 = new Vector3(0, 1, 0);
  //zoom is how many pixels should one tile be on screen
  private var currentZoom:Int = 40;

  private var projectionViewMatrix:Matrix4;
  private var projectionMatrix:Matrix4;
  private var viewMatrix:Matrix4;

  public function new () {}

  public function getProjectionViewMatrix():Matrix4{
    if (projectionViewMatrix != null) {
      return projectionViewMatrix;
    }

    projectionViewMatrix = Matrix4.identity()
      .multmat(this.getProjectionMatrix())
      .multmat(this.getViewMatrix());

    return projectionViewMatrix;
  }

  public function getViewMatrix():Matrix4 {
    if (viewMatrix != null) {
      return viewMatrix;
    }
    
    viewMatrix = Matrix4.lookAt(
      position, // Camera is at position, in World Space
      target, // and looks at the target
      vectorUp// Head is up (set to (0, -1, 0) to look upside-down)
    );

    return viewMatrix;
  }

  public function getProjectionMatrix():Matrix4 {
    if (projectionMatrix != null) {
      return projectionMatrix;
    }

    var width = Sys.pixelWidth / this.currentZoom;
    var height = Sys.pixelHeight / this.currentZoom;

    projectionMatrix = Matrix4.orthogonalProjection(
      -width / 2,
      width / 2,
      -height / 2, 
      height / 2, 
      0.0,
      1000.0
    ); // In world coordinates

    return projectionMatrix;
  }


}