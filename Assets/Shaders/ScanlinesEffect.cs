using System;
using UnityEngine;

public class ScanlinesEffect : MonoBehaviour {
  public Shader shader;
  private Material _material;

  [Range(0, 10)]
  public float lineWidth = 2f;

  [Range(0, 1)]
  public float hardness = 0.9f;

  [Range(-1, 1)]
  public float Speed = 0.1f;

  [Range(0, 255)]
  public float Red = 255;

  [Range(0, 255)]
  public float Green = 255;

  [Range(0, 255)]
  public float Blue = 255;

  protected Material material {
    get {
      if (_material == null) {
        _material = new Material(shader);
        _material.hideFlags = HideFlags.HideAndDontSave;
      }
      return _material;
    }
  }

  private void OnRenderImage(RenderTexture source, RenderTexture destination) {
    if (shader == null)
      return;
    material.SetFloat("_LineWidth", lineWidth);
    material.SetFloat("_Hardness", hardness);
    material.SetFloat("_Speed", Speed);
    material.SetFloat("_Red", Red/255);
    material.SetFloat("_Green", Green/255);
    material.SetFloat("_Blue", Blue/255);
    Graphics.Blit(source, destination, material, 0);
  }

  void OnDisable() {
    if (_material) {
      DestroyImmediate(_material);
    }
  }
}