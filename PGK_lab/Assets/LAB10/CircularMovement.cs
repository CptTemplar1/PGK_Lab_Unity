using UnityEngine;

public class CircularMovement : MonoBehaviour
{
    public float radius = 5f; // Promieñ okrêgu
    public float speed = 2f; // Prêdkoœæ poruszania siê

    private float angle = 0f; // Aktualny k¹t
    private Vector3 startPosition; // Pocz¹tkowa pozycja postaci

    private void Start()
    {
        // Zapisywanie pocz¹tkowej pozycji postaci
        startPosition = transform.position;
    }

    private void Update()
    {
        // Zwiêkszanie k¹ta proporcjonalnie do prêdkoœci
        angle += speed * Time.deltaTime;

        // Obliczanie nowej pozycji na okrêgu
        float x = Mathf.Cos(angle) * radius;
        float z = Mathf.Sin(angle) * radius;

        // Ustawianie pozycji postaci z uwzglêdnieniem pocz¹tkowej pozycji
        transform.position = startPosition + new Vector3(x, 0f, z);

        // Obliczanie kierunku ruchu
        Vector3 movementDirection = new Vector3(-Mathf.Sin(angle), 0f, Mathf.Cos(angle));

        // Sprawdzanie, czy kierunek ruchu nie jest zerowy
        if (movementDirection != Vector3.zero)
        {
            // Obliczanie rotacji do kierunku ruchu
            Quaternion targetRotation = Quaternion.LookRotation(movementDirection);

            // Wyg³adzanie rotacji za pomoc¹ slerp
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * 10f);
        }
    }
}
