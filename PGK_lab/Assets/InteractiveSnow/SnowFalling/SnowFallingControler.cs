using UnityEngine;

public class SnowFallingControler : MonoBehaviour
{
    private Transform target;

    void Start()
    {
        target = GameObject.FindGameObjectWithTag("Player").transform;
    }

    void Update()
    {
        Transform myPosition = GetComponent<Transform>();
        Vector3 myPos = target.position;
        myPos.y = myPosition.position.y;
        myPosition.position = myPos;

        if (GetComponent<ParticleSystem>().isPaused)
            GetComponent<ParticleSystem>().Play();
    }
}
