package mesh;

import kha.math.Vector3;
import texture.GroundHeightData;

class GroundMaker{
  
  public static function getMesh(size:Int, sections:Int, heightData:GroundHeightData):GroundCellMesh {
    var vertices = new Array<Float>();
    var uvs = new Array<Float>();
    var indices = new Array<Int>();
    var normals = new Array<Float>();

    var sectionLength = size/sections;
    var halfSize = size/2;

    for (z in 0...sections+1) {
      for (x in 0...sections+1){

        vertices.push(x * sectionLength - halfSize);
        vertices.push(0);
        vertices.push(z * sectionLength - halfSize);

        normals.push(0);
        normals.push(0);
        normals.push(0);

        uvs.push(x / sections);
        uvs.push(z / sections);

      }
    }

    for (i in 0...Std.int(vertices.length / 3)) {
      var x:Int = i % (sections + 1);
      var y:Int = Math.floor(i / (sections + 1));
      
      if (y >= sections){
        continue;
      }
      
      if (x > 0) {
        indices.push(i+sections);
        indices.push(i+sections + 1);
        indices.push(i);
      }

      if (x < sections) {
        indices.push(i);
        indices.push(i+sections + 1);
        indices.push(i+1);
      }
      
      
    }

    computeNormals(vertices, indices, normals);
    
    trace(vertices.length);
    trace(indices.length);
    trace(normals.length);
    return new GroundCellMesh(vertices, uvs, indices, normals);
  }


  public static function computeNormals2(vertices:Array<Float>, indices:Array<Int>, normals:Array<Float>){

    var nbFaces = Std.int(indices.length / 3);
    for (index in 0...nbFaces) {
      var i1:Int = indices[index * 3];
      var i2:Int = indices[index * 3 + 1];
      var i3:Int = indices[index * 3 + 2];

      var p1:Vector3 = new Vector3(
        vertices[i1 * 3 + 0],
        vertices[i1 * 3 + 1],
        vertices[i1 * 3 + 2]
      );

      var p2:Vector3 = new Vector3(
        vertices[i2 * 3 + 0],
        vertices[i2 * 3 + 1],
        vertices[i2 * 3 + 2]
      );

      var p3:Vector3 = new Vector3(
        vertices[i3 * 3 + 0],
        vertices[i3 * 3 + 1],
        vertices[i3 * 3 + 2]
      );

      var u:Vector3 = p2.sub(p1);
      var v:Vector3 = p3.sub(p1);
      var cross:Vector3 = u.cross(v);

      normals[index * 3 + 0] = cross.x;
      normals[index * 3 + 1] = cross.y;
      normals[index * 3 + 2] = cross.z;

    }
  }

  public static function computeNormals(positions:Array<Float>, indices:Array<Int>, normals:Array<Float>) {
    // temp Vector3
    var p1p2 = new Vector3();
    var p3p2 = new Vector3();
    var faceNormal = new Vector3();
    
    var vertexNormali1 = new Vector3();
    
    for (index in 0...positions.length) {
      normals[index] = 0.0;
    }
    
    // indice triplet = 1 face
    var nbFaces = Std.int(indices.length / 3);
    for (index in 0...nbFaces) {
      var i1 = indices[index * 3];
      var i2 = indices[index * 3 + 1];
      var i3 = indices[index * 3 + 2];

      p1p2.x = positions[i2 * 3] - positions[i1 * 3];
      p1p2.y = positions[i2 * 3 + 1] - positions[i1 * 3 + 1];
      p1p2.z = positions[i2 * 3 + 2] - positions[i1 * 3 + 2];
      
      p3p2.x = positions[i3 * 3] - positions[i1 * 3];
      p3p2.y = positions[i3 * 3 + 1] - positions[i1 * 3 + 1];
      p3p2.z = positions[i3 * 3 + 2] - positions[i1 * 3 + 2];

      /*
      p1p2.x = positions[i1 * 3] - positions[i2 * 3];
      p1p2.y = positions[i1 * 3 + 1] - positions[i2 * 3 + 1];
      p1p2.z = positions[i1 * 3 + 2] - positions[i2 * 3 + 2];
      
      p3p2.x = positions[i3 * 3] - positions[i2 * 3];
      p3p2.y = positions[i3 * 3 + 1] - positions[i2 * 3 + 1];
      p3p2.z = positions[i3 * 3 + 2] - positions[i2 * 3 + 2];
      */

      faceNormal = p1p2.cross(p3p2);
      faceNormal.normalize();
      
      normals[i1 * 3] += faceNormal.x;
      normals[i1 * 3 + 1] += faceNormal.y;
      normals[i1 * 3 + 2] += faceNormal.z;
      normals[i2 * 3] += faceNormal.x;
      normals[i2 * 3 + 1] += faceNormal.y;
      normals[i2 * 3 + 2] += faceNormal.z;
      normals[i3 * 3] += faceNormal.x;
      normals[i3 * 3 + 1] += faceNormal.y;
      normals[i3 * 3 + 2] += faceNormal.z;
    }
    
    // last normalization
    var normLength = Std.int(normals.length / 3);
    for (index in 0...normLength) {
      vertexNormali1 = new Vector3(normals[index * 3], normals[index * 3 + 1], normals[index * 3 + 2]);
      vertexNormali1.normalize();
      normals[index * 3] = vertexNormali1.x;
      normals[index * 3 + 1] = vertexNormali1.y;
      normals[index * 3 + 2] = vertexNormali1.z;
    }
  }
}