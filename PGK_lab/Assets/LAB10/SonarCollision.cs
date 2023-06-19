using EPOOutline;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SonarCollision : MonoBehaviour
{
    public float outlineDuration = 3f; // Czas trwania efektu outline

    public Outlinable outlinableComponent; // Referencja do komponentu Outlinable


    private void OnParticleCollision(GameObject other)
    {
        //outlinableComponent = other.gameObject.GetComponent<Outlinable>(); // Referencja do komponentu Outlinable
        //utlinableComponent = other.
        //Debug.Log(outlinableComponent);
        Debug.Log(other.name);
        if (outlinableComponent != null)
        {
            EnableOutline(); //w³¹czenie outline
            Invoke("DisableOutline", outlineDuration); //inicjalizacja wy³¹czenia outline po x sekundach
        }
        //Debug.Log()

    }

    private void EnableOutline()
    {
        Debug.Log("W³¹czono parametry");
        outlinableComponent.OutlineParameters.Enabled = true;
    }

    private void DisableOutline()
    {
        outlinableComponent.OutlineParameters.Enabled = false;
    }
}
