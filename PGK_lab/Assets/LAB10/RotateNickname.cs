using TMPro;
using UnityEngine;

public class RotateNickname : MonoBehaviour
{
    public string playerObjectName = "Player";
    private Transform playerTransform;

    public TextMeshPro textBox; //pole tekstowe wy�wietlaj�ce nazw� gracza
    public string nickname = "BOT"; //tekst okre�laj�cy nazw� gracza

    private void Start()
    {
        textBox.text = nickname; //ustawienie wy�wietlanej nazwy na podany nick

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

            // Zastosuj odwr�cenie o 180 stopni w osi Y
            Quaternion targetRotation = Quaternion.LookRotation(-direction);

            // Interpoluj rotacj� do docelowej rotacji z pewn� pr�dko�ci�
            float rotationSpeed = 5f; // Pr�dko�� interpolacji rotacji, mo�na dostosowa�
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, rotationSpeed * Time.deltaTime);
        }
    }
}
