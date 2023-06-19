using TMPro;
using UnityEngine;

public class RotateNickname : MonoBehaviour
{
    public string playerObjectName = "Player";
    private Transform playerTransform;

    public TextMeshPro textBox; //pole tekstowe wyœwietlaj¹ce nazwê gracza
    public string nickname = "BOT"; //tekst okreœlaj¹cy nazwê gracza

    private void Start()
    {
        textBox.text = nickname; //ustawienie wyœwietlanej nazwy na podany nick

        GameObject playerObject = GameObject.Find(playerObjectName);
        if (playerObject != null)
        {
            playerTransform = playerObject.transform;
        }
    }

    private void Update()
    {
        if (playerTransform != null)
        {
            // Oblicz wektor kierunku od napisu do gracza
            Vector3 direction = playerTransform.position - transform.position;

            // Zastosuj odwrócenie o 180 stopni w osi Y
            Quaternion targetRotation = Quaternion.LookRotation(-direction);

            // Interpoluj rotacjê do docelowej rotacji z pewn¹ prêdkoœci¹
            float rotationSpeed = 5f; // Prêdkoœæ interpolacji rotacji, mo¿na dostosowaæ
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, rotationSpeed * Time.deltaTime);
        }
    }
}
