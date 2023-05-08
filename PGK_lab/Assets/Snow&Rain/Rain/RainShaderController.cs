using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RainShaderController : MonoBehaviour
{
    Material rainMaterial; //materia³ z shaderem deszczu

    private void Start()
    {
        rainMaterial = gameObject.GetComponent<Renderer>().material; //pobranie materia³u shadera deszczu

        rainMaterial.SetFloat("_WaterLevel", 0f); //ustawienie wstêpnego poziomu wody na 0
    }

    private void Update()
    {
        if(Input.GetKeyUp(KeyCode.U))
        {
            float tmp = rainMaterial.GetFloat("_WaterLevel");
            rainMaterial.SetFloat("_WaterLevel", tmp+0.1f);
        }
        else if (Input.GetKeyUp(KeyCode.I))
        {
            float tmp = rainMaterial.GetFloat("_WaterLevel");
            rainMaterial.SetFloat("_WaterLevel", tmp - 0.1f);
        }
    }
}
