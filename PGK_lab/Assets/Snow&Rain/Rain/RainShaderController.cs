using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RainShaderController : MonoBehaviour
{
    Material rainMaterial; //materia� z shaderem deszczu

    float waterLevel = 0f; // aktualny poziom wody
    float maxWaterLevel = 1f; // maksymalny poziom wody

    private void Start()
    {
        rainMaterial = gameObject.GetComponent<Renderer>().material; //pobranie materia�u shadera deszczu

        rainMaterial.SetFloat("_WaterLevel", 0f); //ustawienie wst�pnego poziomu wody na 0
    }

    private void Update()
    {
        //zwi�kszanie/zmniejszanie wysoko�ci poziomu wody przyciskami U oraz I
        if (Input.GetKeyDown(KeyCode.U))
        {
            float tmp = rainMaterial.GetFloat("_WaterLevel") + 0.1f;
            rainMaterial.SetFloat("_WaterLevel", tmp);
            waterLevel = tmp;
        }
        else if (Input.GetKeyDown(KeyCode.I))
        {
            float tmp = rainMaterial.GetFloat("_WaterLevel") - 0.1f;
            rainMaterial.SetFloat("_WaterLevel", tmp);
            waterLevel = tmp;
        }

        // zwi�kszanie poziomu wody z czasem
        if (waterLevel < maxWaterLevel)
        {
            waterLevel += Time.deltaTime * 0.01f; // zmiana poziomu wody w czasie
            rainMaterial.SetFloat("_WaterLevel", waterLevel); // aktualizacja poziomu wody w shaderze
        }
    }
}
