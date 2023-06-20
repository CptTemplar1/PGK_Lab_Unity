using EPOOutline;
using UnityEngine;

public class SonarController : MonoBehaviour
{
    public ParticleSystem particleSystemToPlay;
    public float cooldownTime = 4f;
    public float outlineDistance = 100f;

    private bool isCooldown = false;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && !isCooldown)
        {
            PlayParticleSystem();
            StartCoroutine(Cooldown());
            StartCoroutine(EnableOutlinableComponents());
        }
    }

    private void PlayParticleSystem()
    {
        ParticleSystem newParticleSystem = Instantiate(particleSystemToPlay, transform.position, transform.rotation);
        Destroy(newParticleSystem.gameObject, newParticleSystem.main.duration);
    }

    private System.Collections.IEnumerator Cooldown()
    {
        isCooldown = true;
        yield return new WaitForSeconds(cooldownTime);
        isCooldown = false;
    }

    private System.Collections.IEnumerator EnableOutlinableComponents()
    {
        yield return new WaitForSeconds(0f);

        Collider[] colliders = Physics.OverlapSphere(transform.position, outlineDistance);
        foreach (Collider collider in colliders)
        {
            if (collider.CompareTag("Outlinable"))
            {
                Outlinable outlinable = collider.GetComponent<Outlinable>();
                if (outlinable != null)
                {
                    outlinable.OutlineParameters.Enabled = true;
                    StartCoroutine(DisableOutlineWithDelay(outlinable, 3f)); // Wywo³anie metody DisableOutline z opóŸnieniem 3 sekundy
                }
            }
        }
    }

    private System.Collections.IEnumerator DisableOutlineWithDelay(Outlinable outlinable, float delay)
    {
        yield return new WaitForSeconds(delay);
        DisableOutline(outlinable);
    }

    // Wy³¹czenie podœwietlenia obiektu
    private void DisableOutline(Outlinable outlinable)
    {
        outlinable.OutlineParameters.Enabled = false;
    }
}

