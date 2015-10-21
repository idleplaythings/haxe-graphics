package mesh;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.math.Matrix4;
import kha.Scheduler;
import kha.math.Vector3;
import kha.math.Vector2;

class GroundCellMesh {
  
  private var vertices:Array<Float>;
  private var uvs:Array<Float>;
  private var normals:Array<Float>;
  private var indices:Array<Int>;

  private static var structureLength:Int = 8;

  private var vertexBuffer:VertexBuffer;
  private var indexBuffer:IndexBuffer;
  private var modelViewMatrix:Matrix4;

  private var position:Vector3 = new Vector3(0, 0, 0);
  
  public function new (
    vertices:Array<Float>,
    uvs:Array<Float>,
    indices:Array<Int>,
    normals:Array<Float>
  ) {
    this.vertices = vertices;
    this.uvs = uvs;
    this.normals = normals;
    this.indices = indices;
  };

  public function getVertexStructure():VertexStructure {
    var structure = new VertexStructure();
    structure.add("pos", VertexData.Float3);
    structure.add("normal", VertexData.Float3);
    structure.add("uv", VertexData.Float2);
    return structure;
  }

  public function getModelViewMatrix():Matrix4 {
    if (modelViewMatrix != null) {
      return modelViewMatrix;
    }
    
    modelViewMatrix = Matrix4.translation(position.x, position.y, position.z);
      //.multmat(Matrix4.rotationY(Scheduler.time()))
      //.multmat(Matrix4.rotationX(Scheduler.time()));
    //return Matrix4.identity();

    return modelViewMatrix;
  }

  public function getVertexBuffer():VertexBuffer {
    if (vertexBuffer != null) {
      return vertexBuffer;
    }

    vertexBuffer = new VertexBuffer(
      Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
      this.getVertexStructure(), // Vertex structure
      Usage.StaticUsage // Vertex data will stay the same
    );


  // Copy vertices and uvs to vertex buffer
    var vbData = vertexBuffer.lock();
    for (i in 0...Std.int(vbData.length / structureLength)) {
      vbData.set(i * structureLength + 0, vertices[i * 3 + 0]);
      vbData.set(i * structureLength + 1, vertices[i * 3 + 1]);
      vbData.set(i * structureLength + 2, vertices[i * 3 + 2]);
      vbData.set(i * structureLength + 3, normals[i * 3 + 0]);
      vbData.set(i * structureLength + 4, normals[i * 3 + 1]);
      vbData.set(i * structureLength + 5, normals[i * 3 + 2]);
      vbData.set(i * structureLength + 6, uvs[i * 2]);
      vbData.set(i * structureLength + 7, uvs[i * 2 + 1]);
    }
    vertexBuffer.unlock();

    return vertexBuffer;
  }

  public function getIndexBuffer():IndexBuffer {
    if (indexBuffer != null) {
      return indexBuffer;
    }

    // Create index buffer
    indexBuffer = new IndexBuffer(
      this.indices.length, // Number of indices for our cube
      Usage.StaticUsage // Index data will stay the same
    );

      // Copy indices to index buffer
    var iData = indexBuffer.lock();
    for (i in 0...iData.length) {
      iData[i] = this.indices[i];
    }
    indexBuffer.unlock();

    return indexBuffer;
  }
}