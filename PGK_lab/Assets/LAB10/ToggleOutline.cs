using EPOOutline;
using UnityEngine;

public class ToggleOutline : MonoBehaviour
{
    public string playerObjectName = "Player"; // Nazwa obiektu gracza

    private Outlinable outlinable; // Referencja do komponentu Outlinable

    public Material redMaterial;
    public Material blueMaterial;

    private Renderer objectRenderer;

    private void Start()
    {
        outlinable = GetComponent<Outlinable>();

        //zmiana koloru postaci w zale�no�ci od tego jaki ma tag teamu
        objectRenderer = GetComponentInChildren<Renderer>();

        if (gameObject.tag == "Team Red")
        {
            objectRenderer.material = redMaterial;
            outlinable.FrontParameters.Color = Color.red;
            outlinable.BackParameters.Color = Color.red;
        }
        else if (gameObject.tag == "Team Blue")
        {
            objectRenderer.material = blueMaterial;
            outlinable.FrontParameters.Color = Color.blue;
            outlinable.BackParameters.Color = Color.blue;
        }


        // Wyszukiwanie obiektu "Player" w scenie
        GameObject player = GameObject.Find(playerObjectName);

        // Sprawdzanie, czy znaleziono obiekt "Player"
        if (player != null)
        {
            // Sprawdzanie, czy tag gracza inny ni� tag obiektu i wy��czenie widzenia przez �cian� je�li jest inny
            if (!player.CompareTag(gameObject.tag))
            {
                if (outlinable != null)
                {
                    outlinable.BackParameters.Enabled = false;
                }
            }
        }
    }
}
