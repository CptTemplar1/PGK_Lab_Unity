using EPOOutline;
using TMPro;
using UnityEngine;
using UnityEngine.TextCore.Text;

public class ToggleOutline : MonoBehaviour
{
    public string playerObjectName = "Player"; // Nazwa obiektu gracza

    private Outlinable outlinable; // Referencja do komponentu Outlinable

    public Material redMaterial;
    public Material blueMaterial;

    private Renderer objectRenderer;

    //czcionki do nicków dla dru¿yny przeciwnej i naszej (jedne s¹ widoczne przez œciany, inne nie)
    public TMP_FontAsset friendlyTeam;
    public TMP_FontAsset enemyTeam; 

    private void Start()
    {
        outlinable = GetComponent<Outlinable>();

        //zmiana koloru postaci w zale¿noœci od tego jaki ma tag teamu
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


        //wy³¹czenie widzialnoœci przez œciany nicków postaci z przeciwnej dru¿yny
        TextMeshPro textMeshPro = gameObject.GetComponentInChildren<TextMeshPro>();  //pobranie tmp dla nicku postaci

        // Wyszukiwanie obiektu "Player" w scenie
        GameObject player = GameObject.Find(playerObjectName);

        // Sprawdzanie, czy znaleziono obiekt "Player"
        if (player != null)
        {
            // Sprawdzanie, czy tag gracza inny ni¿ tag obiektu i wy³¹czenie widzenia przez œcianê jeœli jest inny
            if (!player.CompareTag(gameObject.tag))
            {
                if (outlinable != null)
                {
                    outlinable.BackParameters.Enabled = false;
                    textMeshPro.font = enemyTeam;
                }
            }
            //jeœli dru¿yny s¹ takie same to w³¹czamy widzenie nicków przez œciany
            else
            {
                textMeshPro.font = friendlyTeam;
            }
        }
    }
}
