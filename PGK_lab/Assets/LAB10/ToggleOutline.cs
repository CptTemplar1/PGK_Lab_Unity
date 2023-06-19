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
        // Wyszukiwanie obiektu "Player" w scenie
        GameObject player = GameObject.Find(playerObjectName);

        // Sprawdzanie, czy znaleziono obiekt "Player"
        if (player != null)
        {
            // Sprawdzanie, czy tag gracza jest taki sam jak tag obiektu
            if (player.CompareTag(gameObject.tag))
            {
                // W³¹czanie komponentu Outlinable
                outlinable = GetComponent<Outlinable>();
                if (outlinable != null)
                {
                    outlinable.enabled = true;
                }
            }
            else
            {
                // Wy³¹czanie komponentu Outlinable
                outlinable = GetComponent<Outlinable>();
                if (outlinable != null)
                {
                    outlinable.enabled = false;
                }
            }
        }

        //zmiana koloru postaci w zale¿noœci od tego jaki ma tag teamu
        objectRenderer = GetComponentInChildren<Renderer>();

        if (gameObject.tag == "Team Red")
        {
            objectRenderer.material = redMaterial;
        }
        else if (gameObject.tag == "Team Blue")
        {
            objectRenderer.material = blueMaterial;
        }
    }
}
