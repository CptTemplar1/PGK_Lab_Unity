using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RainShaderController : MonoBehaviour
{
    Material rainMaterial; //materia³ z shaderem deszczu

    float waterLevel = 0f; // aktualny poziom wody
    float maxWaterLevel = 1f; // maksymalny poziom wody

    private void Start()
    {
        rainMaterial = gameObject.GetComponent<Renderer>().material; //pobranie materia³u shadera deszczu

        rainMaterial.SetFloat("_WaterLevel", 0f); //ustawienie wstêpnego poziomu wody na 0
    }

    private void Update()
    {
        // zwiêkszanie poziomu wody z czasem
        if (waterLevel < maxWaterLevel)
        {
            waterLevel += Time.deltaTime * 0.01f; // zmiana poziomu wody w czasie
            rainMaterial.SetFloat("_WaterLevel", waterLevel); // aktualizacja poziomu wody w shaderze
        }
    }
}
