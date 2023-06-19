using UnityEngine;

public class CircularMovement : MonoBehaviour
{
    public float radius = 5f; // Promie� okr�gu
    public float speed = 2f; // Pr�dko�� poruszania si�

    private float angle = 0f; // Aktualny k�t
    private Vector3 startPosition; // Pocz�tkowa pozycja postaci

    private void Start()
    {
        // Zapisywanie pocz�tkowej pozycji postaci
        startPosition = transform.position;
    }

    private void Update()
    {
        // Zwi�kszanie k�ta proporcjonalnie do pr�dko�ci
        angle += speed * Time.deltaTime;

        // Obliczanie nowej pozycji na okr�gu
        float x = Mathf.Cos(angle) * radius;
        float z = Mathf.Sin(angle) * radius;

        // Ustawianie pozycji postaci z uwzgl�dnieniem pocz�tkowej pozycji
        transform.position = startPosition + new Vector3(x, 0f, z);

        // Obliczanie kierunku ruchu
        Vector3 movementDirection = new Vector3(-Mathf.Sin(angle), 0f, Mathf.Cos(angle));

        // Sprawdzanie, czy kierunek ruchu nie jest zerowy
        if (movementDirection != Vector3.zero)
        {
            // Obliczanie rotacji do kierunku ruchu
            Quaternion targetRotation = Quaternion.LookRotation(movementDirection);

            // Wyg�adzanie rotacji za pomoc� slerp
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * 10f);
        }
    }
}
