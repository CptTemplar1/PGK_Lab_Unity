using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor.PackageManager;
using UnityEngine;

public class KillDoll : MonoBehaviour
{
    //zmienna przechowujaca dystnas z jakiego mozemy podjac interakcje z przedmiotem
    public float itemDetectionDistance = 10f;

    //obiekt z glowna kamera
    private Camera mainCamera;

    //obiekt RaycastHit pomagajacy w namierzeniu obiektow
    private RaycastHit hitInfo;

    void Start()
    {
        // Przypisanie komponentu kamery z obiektu podrzêdnego
        mainCamera = GetComponentInChildren<Camera>();
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            // Utworzenie promienia od gracza do miejsca, gdzie "celuje" gracz
            Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);

            // Wykrycie kolizji miêdzy promieniem, a innymi obiektami na scenie w odleg³oœci okreœlonej przez zmienn¹
            if (Physics.Raycast(ray, out hitInfo) && hitInfo.distance < itemDetectionDistance)
            {
                // Sprawdzenie, czy kolizja wystêpuje w obiektem z tagiem "Item"
                if (hitInfo.collider.gameObject.CompareTag("Doll") || hitInfo.collider.gameObject.layer == 6)
                {
                    Debug.Log("Wybrano postac");
                    //pobieranie obiektu ktory wybralismy
                    GameObject item = hitInfo.collider.gameObject;

                    //pobranie animatora
                    Animator animator = item.GetComponentInParent<Animator>();
                    animator.enabled = false;
                }
            }
        }
    }
}
